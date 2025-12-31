
import pandas as pd
import numpy as np
import psycopg2
import json
import os
import sys
from datetime import datetime, timedelta
from typing import List, Dict, Any, Union, Optional
from dataclasses import dataclass

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

# --- CONSTANTS & TYPES ---
ConditionJSON = Dict[str, Any]
StrategyJSON = Union[List[ConditionJSON], Dict[str, Any]] # List (Legacy) or Dict (New)

@dataclass
class MarketData:
    symbol: str
    df: pd.DataFrame

# --- 1. INDICATOR LIBRARY (Self-Contained) ---
class Indicators:
    @staticmethod
    def sma(series: pd.Series, length: int) -> pd.Series:
        return series.rolling(window=length).mean()

    @staticmethod
    def ema(series: pd.Series, length: int) -> pd.Series:
        return series.ewm(span=length, adjust=False).mean()

    @staticmethod
    def rsi(series: pd.Series, length: int = 14) -> pd.Series:
        delta = series.diff()
        gain = (delta.where(delta > 0, 0)).rolling(window=length).mean()
        loss = (-delta.where(delta < 0, 0)).rolling(window=length).mean()
        rs = gain / loss
        return 100 - (100 / (1 + rs))

    @staticmethod
    def macd(series: pd.Series, fast: int = 12, slow: int = 26, signal: int = 9) -> pd.DataFrame:
        ema_fast = Indicators.ema(series, fast)
        ema_slow = Indicators.ema(series, slow)
        macd_line = ema_fast - ema_slow
        signal_line = Indicators.ema(macd_line, signal)
        return pd.DataFrame({'MACD': macd_line, 'MACD_signal': signal_line})

# --- 2. CONDITION ENGINE ---

# --- 5. DATA UTILS ---

def fetch_universe_symbols(universe_def: Union[str, List[str]]) -> List[str]:
    """
    Resolves a universe definition (Index Name or List of Symbols) into a list of symbols.
    Handles expansion of Index Names (e.g., 'NIFTY 50') into constituents.
    """
    inputs = []
    if isinstance(universe_def, str):
        inputs = [universe_def]
    elif isinstance(universe_def, list):
        inputs = universe_def
    else:
        return []
        
    conn = get_db_connection()
    if not conn: return inputs # Fallback
    
    final_symbols = set()
    
    try:
        with conn.cursor() as cur:
            # 1. Try to fetch constituents for all inputs treating them as potential Index Names
            # Using ANY for efficiency
            cur.execute("""
                SELECT index_name, stock_symbol 
                FROM ref.index_mapping 
                WHERE index_name = ANY(%s)
            """, (inputs,))
            
            rows = cur.fetchall()
            
            # Map found indices to their symbols
            found_indices = set()
            for idx_name, sym in rows:
                final_symbols.add(sym)
                found_indices.add(idx_name)
                
            # 2. For inputs that were NOT indices, treat them as raw symbols
            for item in inputs:
                if item not in found_indices:
                    final_symbols.add(item)
                    
    except Exception as e:
        print(f"Error fetching universe: {e}")
        # On error, fallback to returning inputs as is
        return inputs
    finally:
        conn.close()
        
    return list(final_symbols)

def fetch_data_for_symbol(symbol: str, limit: int = 200) -> Optional[pd.DataFrame]:
    """Fetches daily OHLC data for a symbol."""
    conn = get_db_connection()
    if not conn: return None
    
    try:
        query = """
            SELECT date, open, high, low, close, volume 
            FROM trading.ohlc_daily 
            WHERE symbol = %s 
            ORDER BY date ASC
        """ 
        # We fetch all history to ensure indicators (SMA 200) have enough data
        # But we can limit if needed for performance
        
        df = pd.read_sql(query, conn, params=(symbol,), parse_dates=['date'])
        if df.empty: return None
        
        df.set_index('date', inplace=True)
        return df
    except Exception as e:
        print(f"Data Fetch Error {symbol}: {e}")
        return None
    finally:
        conn.close()

def resample_data(df: pd.DataFrame, timeframe: str) -> pd.DataFrame:
    """Resamples Daily Data to Higher Timeframes."""
    if not timeframe or timeframe in ['1d', 'day']:
        return df
    
    # Map to pandas offset aliases
    rule_map = {
        '1w': 'W-FRI', 'week': 'W-FRI',
        '2w': '2W-FRI', 'fortnight': '2W-FRI',
        '1mo': 'ME', 'month': 'ME', # 'M' is deprecated for 'ME' or check pandas version. Using 'M' usually safe for older pandas
        '3mo': '3ME', 'quarter': '3ME',
        '1y': 'YE', 'year': 'YE'
    }
    
    # Handle pandas version diffs for Month/Year if needed, usually 'M' and 'Y' work
    # Safest is likely 'M' and 'A'/'Y'. 
    # '1mo' -> 'M'
    
    rule = rule_map.get(timeframe.lower())
    if not rule:
        # Fallback manual map
        if 'mo' in timeframe: rule = timeframe.replace('mo', 'M')
        elif 'y' in timeframe: rule = timeframe.replace('1y', 'A')
        else: return df # Unknown or '60m' (cannot resample Day to 60m)

    try:
        # Logic for OHLC resampling
        agg_dict = {
            'open': 'first',
            'high': 'max',
            'low': 'min',
            'close': 'last',
            'volume': 'sum'
        }
        resampled = df.resample(rule).agg(agg_dict)
        return resampled.dropna()
    except Exception as e:
        print(f"Resample Error {timeframe}: {e}")
        return df

# --- 2. CONDITION ENGINE (Updated) ---
class ConditionEngine:
    """Interprets JSON strategies and applies them to DataFrames."""
    
    def apply_strategy(self, market_data: MarketData, strategy_input: StrategyJSON) -> bool:
        # ... existing logic ...
        if market_data.df is None or market_data.df.empty:
            return False

        conditions = []
        logic = "AND"

        # Handle Format Polymorphism
        if isinstance(strategy_input, list):
            conditions = strategy_input 
        elif isinstance(strategy_input, dict):
            conditions = strategy_input.get("conditions", [])
            logic = strategy_input.get("logic", "AND")
        else:
            return True 

        if not conditions:
            return True

        results = []
        for cond in conditions:
            results.append(self.evaluate_condition(market_data.df, cond))
            
        if logic == "AND":
            return all(results)
        elif logic == "OR":
            return any(results)
        return False

    def evaluate_condition(self, base_df: pd.DataFrame, cond: ConditionJSON) -> bool:
        """Evaluates a single condition."""
        try:
            # 1. Parse Left Side
            # Check for specific timeframe override
            tf_left = cond.get("timeframe", "1d")
            df_left = resample_data(base_df, tf_left)
            
            target_series = self._resolve_indicator(df_left, cond.get("indicator"), cond)
            left_val = self._get_value_at_offset(target_series, cond.get("offset", 0))

            # 2. Parse Right Side (Value or Indicator)
            if "right_indicator" in cond:
                tf_right = cond.get("right_timeframe", "1d")
                df_right = resample_data(base_df, tf_right) # Might differ from left
                
                right_series = self._resolve_indicator(df_right, cond.get("right_indicator"), cond, prefix="right_")
                right_val = self._get_value_at_offset(right_series, cond.get("right_offset", 0))
            else:
                right_val = float(cond.get("value", 0))

            # 3. Compare
            op = cond.get("operator")
            return self._compare(left_val, op, right_val)
        except Exception as e:
            # print(f"Condition Eval Error: {e}")
            return False
    
    # ... _resolve_indicator, _get_value_at_offset, _compare same as before ...
    def _resolve_indicator(self, df: pd.DataFrame, name: str, params: Dict, prefix: str = "") -> pd.Series:
        if not name: return pd.Series([0]*len(df))
        name = name.lower()
        if name in ['close', 'open', 'high', 'low', 'volume']:
            return df[name]
        length = int(params.get(f"{prefix}length", 14))
        if name == 'sma': return Indicators.sma(df['close'], length)
        elif name == 'ema': return Indicators.ema(df['close'], length)
        elif name == 'rsi': return Indicators.rsi(df['close'], length)
        elif name == 'macd': return Indicators.macd(df['close'])['MACD'] 
        elif name == 'macd_signal': return Indicators.macd(df['close'])['MACD_signal']
        raise ValueError(f"Unknown indicator: {name}")

    def _get_value_at_offset(self, series: pd.Series, offset: int) -> float:
        idx = -1 - int(offset)
        if abs(idx) > len(series): return 0.0
        return float(series.iloc[idx])

    def _compare(self, left: float, op: str, right: float) -> bool:
        if op == ">": return left > right
        if op == "<": return left < right
        if op == "==": return left == right
        if op == ">=": return left >= right
        if op == "<=": return left <= right
        return False

# --- 4. ENGINE EXECUTION (Refactored) ---

def execute_scan_logic(logic: dict, limit_results: int = 50) -> Dict[str, Any]:
    """
    Executes the scanner logic on the database WITHOUT saving results.
    Used for Preview/Dry-Run.
    Returns: { "matches": [...], "stats": { "universe": ..., "primary": ..., "refiner": ... } }
    """
    print(f"Executing Dry Run Logic: {json.dumps(logic)[:100]}...")
    engine = ConditionEngine()
    
    # Parse Logic
    if isinstance(logic, list): # Legacy
        universe_def = "Nifty 50" 
        primary_filter = logic
        refiner = []
    else:
        universe_def = logic.get("universe", ["Nifty 50"])
        primary_filter = logic.get("primary_filter", [])
        refiner = logic.get("refiner", [])

    # Layer 1
    universe_symbols = fetch_universe_symbols(universe_def)
    stats = { "universe": len(universe_symbols), "primary": 0, "refiner": 0 }
    
    matches = []
    
    for sym in universe_symbols:
        df = fetch_data_for_symbol(sym)
        if df is None or len(df) < 50: continue
        
        market_data = MarketData(sym, df)

        # Layer 2
        if not engine.apply_strategy(market_data, primary_filter):
            continue
        stats["primary"] += 1
            
        # Layer 3
        if refiner:
            if engine.apply_strategy(market_data, refiner):
                 stats["refiner"] += 1
                 matches.append({"symbol": sym, "close": float(df.iloc[-1]['close'])})
        else:
            stats["refiner"] += 1
            matches.append({"symbol": sym, "close": float(df.iloc[-1]['close'])})
            
        if len(matches) >= limit_results:
            break
            
    return {"matches": matches, "stats": stats}

def run_scanner_engine(scanner_id):
    """Main entry point to execute a scanner (Persisted Run)."""
    print(f"Starting Scanner Engine for ID: {scanner_id}")
    # ... (Keep existing DB fetching logic, but use execute_scan_logic logic??)
    # Actually, reusing the loop is cleaner but `execute_scan_logic` returns simplified dicts.
    # The full run needs full data dumping. 
    # For now, I'll keep `run_scanner_engine` as is (duplicated loop) or refactor it to use `engine` class directly.
    # I will keep `run_scanner_engine` mostly as is but ensure it uses the NEW ConditionEngine class.
    
    # RE-IMPLEMENTING run_scanner_engine to ensure it uses the class defined above
    conn = get_db_connection()
    if not conn: return False
    engine = ConditionEngine()
    
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT name, logic_config FROM sys.scanners WHERE id = %s", (scanner_id,))
            res = cur.fetchone()
            if not res: return False
            scanner_name, logic = res
            if isinstance(logic, str): logic = json.loads(logic)
            
            # ... Parsing logic ...
            if isinstance(logic, list):
                universe_def = "Nifty 50" 
                primary_filter = logic
                refiner = []
            else:
                universe_def = logic.get("universe", ["Nifty 50"])
                primary_filter = logic.get("primary_filter", [])
                refiner = logic.get("refiner", [])

            universe_symbols = fetch_universe_symbols(universe_def)
            stats = { "universe": len(universe_symbols), "primary": 0, "refiner": 0 }
            print(f"[{scanner_name}] Universe: {len(universe_symbols)}")
            
            matches = []
            for sym in universe_symbols:
                df = fetch_data_for_symbol(sym)
                if df is None or len(df) < 50: continue
                
                market_data = MarketData(sym, df)
                
                # Logic Application
                if not engine.apply_strategy(market_data, primary_filter): continue
                stats["primary"] += 1
                
                final_match = False
                if refiner:
                    if engine.apply_strategy(market_data, refiner): 
                        final_match = True
                        stats["refiner"] += 1
                else:
                    final_match = True
                    stats["refiner"] += 1
                    
                if final_match:
                    # Capture Data
                    last_row = df.iloc[-1].to_dict()
                    last_row = {k: str(v) for k, v in last_row.items()}
                    matches.append((sym, last_row))
            
            # Save
            run_time = datetime.now()
            batch_values = [(scanner_id, run_time, sym, json.dumps(data)) for sym, data in matches]
            if batch_values:
                query = "INSERT INTO trading.scanner_results (scanner_id, run_date, symbol, match_data) VALUES %s"
                from psycopg2.extras import execute_values
                execute_values(cur, query, batch_values)
            
            cur.execute("""
                UPDATE sys.scanners 
                SET last_run_at = %s, last_match_count = %s, last_run_stats = %s, updated_at = NOW() 
                WHERE id = %s
            """, (run_time, len(matches), json.dumps(stats), scanner_id))
            conn.commit()
            return True
            
    except Exception as e:
        print(f"Scanner Logic Failed: {e}")
        import traceback
        traceback.print_exc()
        return False
    finally:
        conn.close()
