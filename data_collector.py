"""
MODULE: DATA COLLECTOR
======================
Purpose:
  Fetches OHLC (Open, High, Low, Close) market data from Zerodha Kite Connect 
  and stores it in the PostgreSQL database (TimescaleDB).

Key Features:
  1. Concurrency: Uses ThreadPoolExecutor to fetch data for multiple symbols in parallel.
  2. Incremental Fetch: 
     - Detects the last available candle in DB.
     - Fetches only missing data (plus a buffer overlap).
  3. Backfill Mode: 
     - If no data exists, fetches a configurable history.
  4. Self-Healing Token Mechanism:
     - Automatically detects 'TokenException' and retries with refreshed tokens from DB.

Configuration:
  - Controlled via Environment Variables and portfolio_rules.json.
"""

import os
import sys
import json
import time
import datetime
import argparse
import concurrent.futures
from psycopg2.pool import ThreadedConnectionPool
from psycopg2.extras import execute_batch, RealDictCursor
from kiteconnect import exceptions as kite_exceptions
from dotenv import load_dotenv
from db_logger import EnterpriseLogger
from modules import notifier
import config
from modules.brokers import get_broker_client

# --- Config ---
load_dotenv()

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

# Buffer Configuration
BUFFER_RULES = {
    "60minute": int(os.environ.get("OHLC_BUFFER_DAYS_HOURLY", 2)),
    "day": int(os.environ.get("OHLC_BUFFER_DAYS_DAILY", 5))
}

# Zerodha Fetch Limits
LIMIT_DAYS_HOURLY = 300  
LIMIT_DAYS_DAILY = 2000

logger = EnterpriseLogger("data_collector")

# --- SQL Queries ---
GET_UNIVERSE_SQL = """
    SELECT DISTINCT s.trading_symbol, s.instrument_token
    FROM ref.symbol s
    WHERE s.is_active = TRUE
    AND (
        -- 1. Part of any Tracked Index
        EXISTS (
            SELECT 1 FROM ref.index_mapping ic 
            WHERE ic.stock_symbol = s.trading_symbol
        )
        OR
        -- 2. In Portfolio (Holdings)
        EXISTS (
            SELECT 1 FROM trading.portfolio p 
            WHERE p.symbol = s.trading_symbol
        )
        OR
        -- 3. In Open Positions
        EXISTS (
            SELECT 1 FROM trading.positions pos 
            WHERE pos.symbol = s.trading_symbol
        )
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

def load_data_session():
    """Finds the configured account to use for data fetching."""
    
    # Read strict config from rules
    sys_config = config.PORTFOLIO_RULES.get("system_config", {}).get("ohlc_provider")
    
    selected_account = None
    selected_details = None
    
    if sys_config:
        user_ref = sys_config.get("user_ref")
        account_ref = sys_config.get("account_ref")
        
        # Resolve to details
        try:
            selected_details = config.PORTFOLIO_RULES["accounts"][user_ref][account_ref]
            selected_account = f"{user_ref}_{account_ref}"
            logger.log("info", f"Using Configured Data Source: {selected_account}")
        except KeyError:
            logger.log("error", f"Invalid system_config: {user_ref}.{account_ref} not found")
            
    # Fallback to heuristic if config is missing or invalid
    if not selected_account:
        logger.log("warning", "System Config missing/invalid. Falling back to heuristic.")
        preferred_order = ["komal_investing_passive", "kapil_investing_passive"]
        accounts = list(config.get_operational_accounts())
        
        # helper
        def find_account(acc_id):
            for user, acc_type, aid, details in accounts:
                if aid == acc_id and details['broker'] == "ZERODHA":
                    return aid, details
            return None, None
    
        # Try preferred
        for pid in preferred_order:
            selected_account, selected_details = find_account(pid)
            if selected_account: break
        
        # Fallback
        if not selected_account:
            for user, acc_type, aid, details in accounts:
                if details['broker'] == "ZERODHA":
                    selected_account = aid
                    selected_details = details
                    break
                    
    if not selected_account:
        # Final Fallback check for Angel
        for user, acc_type, aid, details in accounts:
            if details['broker'] == "ANGEL_ONE":
                selected_account = aid
                selected_details = details
                break

    if not selected_account:
        raise Exception("No Operational ZERODHA/ANGEL account found for Data Collection")
        
    print(f"📡 Using Data Source Account: {selected_account} ({selected_details['broker']})")
    # Instantiate Broker
    broker = get_broker_client(selected_details['broker'], selected_details['credential_id'])
    # Login might fail if token expired, but let's try
    if not broker.login():
        print(f"⚠️ Initial Login failed for {selected_account}. Job might fail if tokens are invalid.")
        # We don't raise immediately, let the worker thread try or fail
        
    if selected_details['broker'] == "ANGEL_ONE":
        # Angel One has strict rate limits ( ~3 req/sec )
        print("⚠️ Throttling for Angel One (Max 1 thread + Delay)")
        global MAX_CONCURRENT
        MAX_CONCURRENT = 1
        global BATCH_DELAY
        BATCH_DELAY = 1.0 # Extra delay between batches
        
    return broker

def fetch_data_chunked(broker, symbol, token, from_date, to_date, timeframe):
    """
    Fetches historical data using the broker interface.
    """
    all_candles = []
    chunk_size_days = LIMIT_DAYS_DAILY if timeframe == "day" else LIMIT_DAYS_HOURLY
    current_from = from_date
    
    while current_from < to_date:
        current_to = min(current_from + datetime.timedelta(days=chunk_size_days), to_date)
        if (current_to - current_from).total_seconds() < 60:
            break
            
        # Rate Limit Pacing
        if not hasattr(broker, 'kite'):
             time.sleep(2.0) 

        # Broker wrapper handles the call
        # broker.get_historical_data signature: symbol, token, from, to, interval
        chunk_data = broker.get_historical_data(symbol, token, current_from, current_to, timeframe)
        if chunk_data:
            all_candles.extend(chunk_data)
        current_from = current_to

    return all_candles

def process_symbol(broker, pool, symbol, token, timeframe, table_suffix):
    """
    Worker function to process a single symbol in its own thread.
    """
    conn = None
    max_retries = 1
    
    for attempt in range(max_retries + 1):
        try:
            conn = pool.getconn()
            
            # Only relevant for ZERODHA. Angel maps internally.
            current_token = token
            if hasattr(broker, 'kite'):
                if attempt > 0:
                    with conn.cursor() as cur:
                        cur.execute("SELECT instrument_token FROM ref.symbol WHERE trading_symbol = %s", (symbol,))
                        res = cur.fetchone()
                        if res and res[0] != token:
                            logger.log("warning", "Token Healed (Pre-fetch)", symbol=symbol, old=token, new=res[0])
                            current_token = res[0]
        
            with conn: # Transaction block
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    max_days = BACKFILL_RULES.get(timeframe, 365)
                    buffer_days = BUFFER_RULES.get(timeframe, 5)

                    query_last = GET_LAST_CANDLE_SQL_TEMPLATE.format(suffix=table_suffix)
                    cur.execute(query_last, (symbol,))
                    result = cur.fetchone()
                    last_candle = result['last_candle'] if result and 'last_candle' in result else None
                    
                    if last_candle and isinstance(last_candle, datetime.date) and not isinstance(last_candle, datetime.datetime):
                        last_candle = datetime.datetime.combine(last_candle, datetime.time.min).replace(tzinfo=datetime.timezone.utc)

                    to_date = datetime.datetime.now().astimezone()
                    
                    if last_candle:
                        from_date = last_candle - datetime.timedelta(days=buffer_days)
                        mode = f"INCREMENTAL (Buffer -{buffer_days}d)"
                    else:
                        from_date = to_date - datetime.timedelta(days=max_days)
                        mode = f"BACKFILL"

                    # Fetch Data
                    data = fetch_data_chunked(broker, symbol, current_token, from_date, to_date, timeframe)
                    
                    if not data:
                        return {"status": "NO_DATA", "symbol": symbol, "msg": "No data returned"}

                    # Transform
                    rows = []
                    for candle in data:
                        rows.append((symbol, candle['date'], candle['open'], candle['high'], candle['low'], candle['close'], candle['volume']))

                    # Upsert
                    if rows:
                        query_upsert = UPSERT_SQL_TEMPLATE.format(suffix=table_suffix)
                        execute_batch(cur, query_upsert, rows)
                        return {"status": "SUCCESS", "symbol": symbol, "count": len(rows), "mode": mode}
                    else:
                        return {"status": "EMPTY", "symbol": symbol, "msg": "Data empty after parsing"}

        except kite_exceptions.InputException as e:
            # --- SELF-HEALING LOGIC (Instrument Token Mismatch) ---
            # InputException is raised when the instrument token is invalid/unknown to Kite
            if attempt < max_retries:
                logger.log("warning", "Instrument Token Invalid - Attempting Self-Heal", symbol=symbol, attempt=attempt+1)
                if conn:
                    pool.putconn(conn)
                    conn = None
                
                # Fetch fresh token
                fresh_conn = pool.getconn()
                try:
                    with fresh_conn.cursor() as cur:
                        cur.execute("SELECT instrument_token FROM ref.symbol WHERE trading_symbol = %s", (symbol,))
                        res = cur.fetchone()
                        if res and res[0] != token:
                             token = res[0]
                        else:
                             # If DB has same token, we can't heal it
                             raise e
                finally:
                    pool.putconn(fresh_conn)
                continue
            else:
                 logger.log("error", "Instrument Token Healing Failed", symbol=symbol, exc_info=True)
                 raise Exception(f"Instrument Token Invalid for {symbol}") from e

        except Exception as e:
            # Catch-all for Angel or other errors
            if "Session Expired" in str(e):
                 logger.log("error", "Session Token Expired/Invalid", symbol=symbol, exc_info=True)
                 raise Exception("CRITICAL: User Session Expired.") from e
            raise Exception(f"Failed processing '{symbol}': {e}") from e
        finally:
            if conn:
                pool.putconn(conn)

def main():
    """Main Orchestrator."""
    parser = argparse.ArgumentParser(description="Setu V3 OHLC Collector")
    parser.add_argument("timeframe", choices=["day", "60minute"], help="Timeframe to fetch")
    args = parser.parse_args()

    suffix_map = {"day": "1d", "60minute": "60m"}
    table_suffix = suffix_map[args.timeframe]
    
    start_time = time.time()
    
    logger.log("info", f"Starting Data Collector", timeframe=args.timeframe)
    notifier.send_notification("Data Collector Started", f"Starting {args.timeframe} collection")

    try:
        # Load Broker
        broker = load_data_session()
        
        db_pool = ThreadedConnectionPool(
            minconn=1, maxconn=MAX_CONCURRENT,
            host=os.getenv("DB_HOST", "localhost"), database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"), password=os.getenv("DB_PASS"),
            port=os.getenv("DB_PORT", "5432")
        )

        with db_pool.getconn() as conn:
            with conn.cursor() as cur:
                cur.execute(GET_UNIVERSE_SQL)
                universe = cur.fetchall()
        db_pool.putconn(conn)
        
        print(f"🚀 Starting Collection for {len(universe)} symbols ({args.timeframe})")

        with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_CONCURRENT) as executor:
            future_to_symbol = {}
            
            def chunker(seq, size):
                return (seq[pos:pos + size] for pos in range(0, len(seq), size))

            total_batches = (len(universe) // WORKERS_PER_BATCH) + 1
            batch_num = 0

            for batch in chunker(universe, WORKERS_PER_BATCH):
                batch_num += 1
                for symbol, token in batch:
                    future = executor.submit(process_symbol, broker, db_pool, symbol, token, args.timeframe, table_suffix)
                    future_to_symbol[future] = symbol
                time.sleep(BATCH_DELAY)

            print("⏳ Waiting for jobs...")
            completed = 0
            errors = 0
            error_counts = {}
            failed_jobs = []

            for future in concurrent.futures.as_completed(future_to_symbol):
                symbol = future_to_symbol[future]
                try:
                    result = future.result(timeout=JOB_TIMEOUT)
                    status = result.get("status")
                    if status == "SUCCESS":
                        completed += 1
                    elif status == "NO_DATA":
                         # Optional: Track no data separately if needed
                         pass
                except Exception as e:
                    errors += 1
                    err_msg = str(e)
                    
                    # Categorize Error
                    category = "General Error"
                    if "timed out" in err_msg: category = "Connection Timeout"
                    elif "Access denied" in err_msg: category = "Rate Limit Exceeded"
                    elif "Instrument Token" in err_msg: category = "Token Invalid"
                    elif "Session Expired" in err_msg: category = "Session Expired"
                    
                    error_counts[category] = error_counts.get(category, 0) + 1
                    
                    failed_jobs.append((symbol, err_msg))
                    print(f"❌ {symbol} Failed: {e}")

        duration = time.time() - start_time
        logger.log("info", "Job Complete", duration=duration, completed=completed, errors=errors)
        print(f"✅ DONE. Time: {duration:.2f}s | Success: {completed} | Errors: {errors}")

        # Notification logic
        msg_title = f"Data Collector Report ({args.timeframe})"
        msg_body = (
            f"✅ Success: {completed}\n"
            f"❌ Failed: {errors}\n"
            f"⏱️ Duration: {duration:.1f}s\n"
        )
        
        if errors > 0:
            msg_body += "\n⚠️ Error Breakdown:\n"
            for cat, count in error_counts.items():
                msg_body += f"- {cat}: {count}\n"
                
            priority = "high"
        else:
            msg_body += "\n✨ All symbols processed successfully."
            priority = "normal"
            
        notifier.send_notification(msg_title, msg_body, priority=priority)

    except Exception as e:
        logger.log("error", "Critical Collector Failure", exc_info=True)
        print(f"🔥 CRITICAL FAIL: {e}")
        notifier.send_notification("Data Collector Failed", str(e), priority="critical")
    finally:
        if 'db_pool' in locals() and db_pool:
            db_pool.closeall()

if __name__ == "__main__":
    main()