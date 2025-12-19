import os
import sys
import json
import time
import datetime
import argparse
import concurrent.futures
# import psycopg2
from psycopg2.pool import ThreadedConnectionPool
from psycopg2.extras import execute_batch, RealDictCursor
from kiteconnect import KiteConnect, exceptions as kite_exceptions
from dotenv import load_dotenv
from db_logger import EnterpriseLogger
from modules import notifier

# --- Config ---
load_dotenv()
API_KEY = os.getenv("KITE_API_KEY")

# Execution Tuning
WORKERS_PER_BATCH = int(os.getenv("OHLC_MAX_WORKERS_PER_BATCH", 3))
BATCH_DELAY = float(os.getenv("OHLC_BATCH_DELAY", 2.0))
JOB_TIMEOUT = int(os.getenv("OHLC_JOB_KILL_IN_SEC", 20)) 
MAX_CONCURRENT = int(os.getenv("OHLC_MAX_CONCURRENT_JOBS", 10))

# Backfill Configuration
BACKFILL_RULES = {
    "60minute": int(os.getenv("OHLC_BACKFILL_DAYS_HOURLY", 365)), 
    "day": int(os.getenv("OHLC_BACKFILL_DAYS_DAILY", 1100))        
}

# --- NEW: Buffer Configuration (Overlap/Self-Healing) ---
BUFFER_RULES = {
    "60minute": int(os.environ["OHLC_BUFFER_DAYS_HOURLY"]), # Overlap last 2 days
    "day": int(os.environ["OHLC_BUFFER_DAYS_DAILY"])        # Overlap last 5 days
}

# Zerodha Fetch Limits
LIMIT_DAYS_HOURLY = 300  
LIMIT_DAYS_DAILY = 2000

logger = EnterpriseLogger("data_collector")

# --- SQL Queries (Unchanged) ---
GET_UNIVERSE_SQL = """
    SELECT DISTINCT s.trading_symbol, s.instrument_token
    FROM ref.symbol s
    LEFT JOIN ref.index_mapping m_stock ON s.trading_symbol = m_stock.stock_symbol
    LEFT JOIN ref.index_mapping m_index ON s.trading_symbol = m_index.index_name
    LEFT JOIN trading.portfolio_view p ON s.trading_symbol = p.symbol
    WHERE s.is_active = TRUE
      AND (
          (s.segment = 'INDICES' AND m_index.index_name IS NOT NULL)
          OR 
          (s.segment <> 'INDICES' AND m_stock.stock_symbol IS NOT NULL)
          OR 
          (p.net_quantity > 0)
      )
"""

GET_LAST_CANDLE_SQL_TEMPLATE = "SELECT MAX(candle_start) as last_candle FROM ohlc.candles_{suffix} WHERE symbol = %s"

UPSERT_SQL_TEMPLATE = """
    INSERT INTO ohlc.candles_{suffix} 
    (symbol, candle_start, open, high, low, close, volume, exchange_code)
    VALUES (%s, %s, %s, %s, %s, %s, %s, 'NSE')
    ON CONFLICT (symbol, candle_start) DO UPDATE 
    SET close = EXCLUDED.close, 
        volume = EXCLUDED.volume,
        high = GREATEST(ohlc.candles_{suffix}.high, EXCLUDED.high),
        low = LEAST(ohlc.candles_{suffix}.low, EXCLUDED.low);
"""

# --- Functions ---

import config

def load_kite_session() -> KiteConnect:
    try:
        with open(config.TOKENS_FILE, "r") as f:
            tokens = json.load(f)
        kite = KiteConnect(api_key=API_KEY)
        kite.set_access_token(tokens["access_token"])
        return kite
    except Exception as e:
        logger.log("error", "Session Load Failed", exc_info=True)
        raise e

def fetch_data_chunked(kite, token, from_date, to_date, timeframe):
    all_candles = []
    chunk_size_days = LIMIT_DAYS_DAILY if timeframe == "day" else LIMIT_DAYS_HOURLY
    current_from = from_date
    
    while current_from < to_date:
        current_to = min(current_from + datetime.timedelta(days=chunk_size_days), to_date)
        if (current_to - current_from).total_seconds() < 60:
            break
        # Let exceptions propagate to the caller (process_symbol) for centralized handling
        chunk_data = kite.historical_data(token, current_from, current_to, timeframe)
        if chunk_data:
            all_candles.extend(chunk_data)
        current_from = current_to

    return all_candles

def process_symbol(kite_session, pool, symbol, token, timeframe, table_suffix):
    """
    Processes a single symbol using a shared Kite session and a DB connection from the pool.
    This function is designed to be run in a separate thread.
    """
    conn = None
    try:
        # Get a connection from the pool; ensure it's returned with 'finally'.
        conn = pool.getconn()
        with conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                max_days = BACKFILL_RULES.get(timeframe, 365)
                buffer_days = BUFFER_RULES.get(timeframe)

                query_last = GET_LAST_CANDLE_SQL_TEMPLATE.format(suffix=table_suffix)
                cur.execute(query_last, (symbol,))
                result = cur.fetchone()
                last_candle = result['last_candle'] if result and 'last_candle' in result else None
                
                # --- FIX: Ensure last_candle is DateTime, not Date ---
                if last_candle and isinstance(last_candle, datetime.date) and not isinstance(last_candle, datetime.datetime):
                    last_candle = datetime.datetime.combine(last_candle, datetime.time.min).replace(tzinfo=datetime.timezone.utc)

                
                to_date = datetime.datetime.now().astimezone()
                
                if last_candle:
                    from_date = last_candle - datetime.timedelta(days=buffer_days)
                    mode = f"INCREMENTAL (Buffer -{buffer_days}d)"
                else:
                    from_date = to_date - datetime.timedelta(days=max_days)
                    mode = f"BACKFILL"

                data = fetch_data_chunked(kite_session, token, from_date, to_date, timeframe)
                
                if not data:
                    return {"status": "NO_DATA", "symbol": symbol, "msg": "No data returned"}

                rows = []
                for candle in data:
                    rows.append((symbol, candle['date'], candle['open'], candle['high'], candle['low'], candle['close'], candle['volume']))

                if rows:
                    query_upsert = UPSERT_SQL_TEMPLATE.format(suffix=table_suffix)
                    execute_batch(cur, query_upsert, rows)
                    return {"status": "SUCCESS", "symbol": symbol, "count": len(rows), "mode": mode}
                else:
                    return {"status": "EMPTY", "symbol": symbol, "msg": "Data empty after parsing"}

    except kite_exceptions.TokenException as e:
        # This is a critical, non-recoverable error for this run.
        # Re-raise to stop the entire collector job immediately.
        logger.log("error", "Kite Token Exception - Session may have expired. Stopping job.", symbol=symbol, exc_info=True)
        notifier.send_notification("Job Failed: Data Collector", "Kite Token Exception: Token is invalid or expired.", priority="high")
        raise Exception("Kite session invalid, stopping collector.") from e
    except Exception as e:
        # Re-raise the exception to be caught by the main thread's executor loop.
        # This preserves the full stack trace for better debugging.
        raise Exception(f"Failed processing '{symbol}': {e}") from e
    finally:
        if conn:
            pool.putconn(conn)

def main():
    parser = argparse.ArgumentParser(description="Setu V3 OHLC Collector")
    parser.add_argument("timeframe", choices=["day", "60minute"], help="Timeframe to fetch")
    args = parser.parse_args()

    suffix_map = {"day": "1d", "60minute": "60m"}
    table_suffix = suffix_map[args.timeframe]
    
    start_time = time.time()
    backfill_days = BACKFILL_RULES.get(args.timeframe, 0)
    buffer_days = BUFFER_RULES.get(args.timeframe, 0)
    
    logger.log("info", f"Starting Data Collector", timeframe=args.timeframe, backfill=backfill_days, buffer=buffer_days)

    try:
        # --- REFACTOR: Initialize shared resources once ---
        kite_session = load_kite_session()
        
        # --- FIX: Use a connection pool ---
        db_pool = ThreadedConnectionPool(
            minconn=1, maxconn=MAX_CONCURRENT,
            host=os.getenv("DB_HOST"), database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"), password=os.getenv("DB_PASS")
        )

        # Get the universe of symbols to process
        with db_pool.getconn() as conn:
            with conn.cursor() as cur:
                cur.execute(GET_UNIVERSE_SQL)
                universe = cur.fetchall()
        db_pool.putconn(conn) # Return the connection
        
        logger.log("info", f"Universe Loaded", count=len(universe))
        print(f"🚀 Starting Collection for {len(universe)} symbols ({args.timeframe})")

        with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_CONCURRENT) as executor:
            futures = []
            
            def chunker(seq, size):
                return (seq[pos:pos + size] for pos in range(0, len(seq), size))

            total_batches = (len(universe) // WORKERS_PER_BATCH) + 1
            batch_num = 0

            for batch in chunker(universe, WORKERS_PER_BATCH):
                batch_num += 1
                for symbol, token in batch:
                    # Pass shared resources to the worker
                    future = executor.submit(process_symbol, kite_session, db_pool, symbol, token, args.timeframe, table_suffix)
                    futures.append(future)

                print(f"⚡ Fired Batch {batch_num}/{total_batches} ({len(batch)} jobs)...")
                time.sleep(BATCH_DELAY)

            print("⏳ Waiting for all jobs to finish...")
            completed = 0
            errors = 0
            
            for future in concurrent.futures.as_completed(futures):
                try:
                    # Get result from worker
                    result = future.result(timeout=JOB_TIMEOUT) # This will re-raise exceptions from the worker
                    
                    status = result.get("status")
                    
                    if status == "SUCCESS":
                        completed += 1
                        logger.log("info", "Job Success", symbol=result['symbol'], count=result['count'], mode=result['mode'])
                    elif status == "SKIP":
                        pass
                        
                except concurrent.futures.TimeoutError:
                    errors += 1
                    logger.log("error", "Job Timeout (Killed)")
                    print("❌ A job timed out!")
                except Exception as e:
                    # --- REFACTOR: Catch propagated exceptions from the worker ---
                    # The logger automatically includes the stack trace because exc_info=True is set in EnterpriseLogger.
                    errors += 1
                    logger.log("error", "Job crashed in executor", exc_info=True)
                    print(f"❌ Job Failed: {e}")

        duration = time.time() - start_time
        logger.log("info", "Job Complete", duration=duration, completed=completed, errors=errors)
        print(f"✅ DONE. Time: {duration:.2f}s | Success: {completed} | Errors: {errors}")

    except Exception as e:
        logger.log("error", "Critical Collector Failure", exc_info=True)
        print(f"🔥 CRITICAL FAIL: {e}")
    finally:
        if 'db_pool' in locals() and db_pool:
            db_pool.closeall()

if __name__ == "__main__":
    main()