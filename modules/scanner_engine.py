
import pandas as pd
import numpy as np
import psycopg2
import json
import os
import sys
from datetime import datetime, timedelta

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def get_db_connection():
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except Exception as e:
        print(f"Engine DB Conn Failed: {e}", file=sys.stderr)
        return None

def fetch_universe_symbols(universe_name):
    """Get list of symbols for a given universe."""
    conn = get_db_connection()
    if not conn: return []
    
    symbols = []
    try:
        with conn.cursor() as cur:
            if universe_name == 'Nifty 50':
                # TODO: Retrieve from actual collection or static list. 
                # For now using indices definition if available, else defaulting to a few known ones for testing
                # In a real scenario, this would query a 'ref.indices' or 'ref.instruments' table
                query = "SELECT DISTINCT symbol FROM ohlc.candles_1d LIMIT 50" # Fallback to top 50 active
                cur.execute(query)
                symbols = [r[0] for r in cur.fetchall()]
            elif universe_name == 'Nifty 500' or universe_name == 'ALL':
                 cur.execute("SELECT DISTINCT symbol FROM ohlc.candles_1d")
                 symbols = [r[0] for r in cur.fetchall()]
            else:
                 # Default fallback
                 cur.execute("SELECT DISTINCT symbol FROM ohlc.candles_1d LIMIT 10")
                 symbols = [r[0] for r in cur.fetchall()]
    finally:
        conn.close()
    return symbols

def calculate_rsi(series, period=14):
    """Calculate RSI manually using Pandas."""
    delta = series.diff()
    gain = (delta.where(delta > 0, 0)).rolling(window=period).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(window=period).mean()
    rs = gain / loss
    return 100 - (100 / (1 + rs))

def fetch_data_for_symbol(symbol, days=250):
    """Fetch OHLC data for a symbol."""
    conn = get_db_connection()
    if not conn: return None
    
    try:
        query = """
            SELECT candle_start as date, open, high, low, close, volume 
            FROM ohlc.candles_1d 
            WHERE symbol = %s 
            ORDER BY candle_start ASC 
            LIMIT %s
        """ # LIMIT is simplistic, better to filter by date range
        
        # Better: get last N days
        df = pd.read_sql(query, conn, params=(symbol, days))
        if not df.empty:
            df['close'] = pd.to_numeric(df['close'])
            df['open'] = pd.to_numeric(df['open'])
            df['high'] = pd.to_numeric(df['high'])
            df['low'] = pd.to_numeric(df['low'])
            df['volume'] = pd.to_numeric(df['volume'])
        return df
    except Exception as e:
        print(f"Error fetching data for {symbol}: {e}")
        return None
    finally:
        conn.close()

def evaluate_conditions(df, conditions):
    """
    Apply logic conditions to the latest row of the DataFrame.
    Returns: (is_match, match_data_dict)
    """
    if df is None or df.empty: return False, {}
    
    # 1. Pre-calculate necessary indicators based on fields used in conditions
    # This is a naive implementation; optimize by only calculating what's needed
    
    # SMAs
    df['SMA_20'] = df['close'].rolling(window=20).mean()
    df['SMA_50'] = df['close'].rolling(window=50).mean()
    df['SMA_200'] = df['close'].rolling(window=200).mean()
    
    # RSI
    df['RSI_14'] = calculate_rsi(df['close'], 14)
    
    # Get latest row
    latest = df.iloc[-1]
    prev = df.iloc[-2] if len(df) > 1 else None
    
    cols_map = {
        "Close": "close", "Open": "open", "High": "high", "Low": "low", "Volume": "volume",
        "RSI_14": "RSI_14", "SMA_20": "SMA_20", "SMA_50": "SMA_50", "SMA_200": "SMA_200"
    }

    match_data = {}
    all_passed = True
    
    for cond in conditions:
        field = cond.get('field')
        op = cond.get('operator')
        val_str = cond.get('value')
        
        # Resolve Field Value
        df_col = cols_map.get(field)
        if not df_col: continue # specific error handling needed
        
        current_val = latest[df_col]
        match_data[field] = float(current_val)
        
        # Resolve Comparison Value (could be number or another field like 'SMA_50')
        compare_val = 0
        if val_str in cols_map:
            compare_val = latest[cols_map[val_str]]
        else:
            try:
                compare_val = float(val_str)
            except:
                compare_val = 0 # Fallback
        
        # Check Condition
        passed = False
        if op == ">":
            passed = current_val > compare_val
        elif op == "<":
            passed = current_val < compare_val
        elif op == "=":
             passed = current_val == compare_val
        elif op == "crosses_above":
            if prev is not None:
                prev_val = prev[df_col]
                prev_compare = 0
                if val_str in cols_map:
                    prev_compare = prev[cols_map[val_str]]
                else:
                    prev_compare = float(val_str)
                
                passed = (prev_val <= prev_compare) and (current_val > compare_val)
                
        elif op == "crosses_below":
             if prev is not None:
                prev_val = prev[df_col]
                prev_compare = 0
                if val_str in cols_map:
                    prev_compare = prev[cols_map[val_str]]
                else:
                    prev_compare = float(val_str)
                
                passed = (prev_val >= prev_compare) and (current_val < compare_val)
                
        if not passed:
            all_passed = False
            break
            
    return all_passed, match_data

def run_scanner_engine(scanner_id):
    """Main entry point to execute a scanner."""
    conn = get_db_connection()
    if not conn: return False
    
    try:
        with conn.cursor() as cur:
            # 1. Fetch Config
            cur.execute("SELECT source_universe, logic_config FROM sys.scanners WHERE id = %s", (scanner_id,))
            res = cur.fetchone()
            if not res: 
                print(f"Scanner {scanner_id} not found")
                return False
                
            source, logic = res
            if isinstance(logic, str):
                logic = json.loads(logic)
            
            # 2. Get Universe
            symbols = fetch_universe_symbols(source)
            print(f"Scanning {len(symbols)} symbols for Scanner {scanner_id}...")
            
            matches = []
            
            # 3. Iterate and Evaluate
            for sym in symbols:
                df = fetch_data_for_symbol(sym)
                if df is not None and len(df) > 50: # Minimum data check
                    is_match, data = evaluate_conditions(df, logic)
                    if is_match:
                        matches.append((sym, data))
            
            # 4. Save Results
            # Clear old results for same day? Or just append? 
            # Usually we snapshot for the run.
            
            # Getting current timestamp for the run
            run_time = datetime.now()
            
            print(f"Found {len(matches)} matches.")
            
            for sym, data in matches:
                cur.execute("""
                    INSERT INTO trading.scanner_results (scanner_id, run_date, symbol, match_data)
                    VALUES (%s, %s, %s, %s)
                """, (scanner_id, run_time, sym, json.dumps(data)))
                
            # Update Scanner Metadata
            cur.execute("UPDATE sys.scanners SET last_run_at = %s, updated_at = NOW() WHERE id = %s", (run_time, scanner_id))
            
            conn.commit()
            return True

    except Exception as e:
        print(f"Scanner Logic Failed: {e}")
        import traceback
        traceback.print_exc()
        return False
    finally:
        conn.close()
