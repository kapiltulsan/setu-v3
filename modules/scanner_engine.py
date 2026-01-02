
# ==================================================================================================
# MODULE: SCANNER ENGINE
# ==================================================================================================
# Purpose:
#   Core logic engine for the "Smart Stock Scanner".
#   It evaluates user-defined strategies (JSON) against market data (PostgreSQL).
#
# Architecture (3-Layer Filtering):
#   1. Layer 1: Universe Selection (The "Sieve")
#      - Input: List of Index Names (e.g., "NIFTY 50") or individual symbols.
#      - Logic: 
#           - If an Index is selected, the engine FIRST checks if the Index ITSELF matches 
#             optional "Index Filters" (e.g., Index Close > SMA 200).
#           - If the Index passes, ALL its constituent stocks are added to the pool.
#           - If the Index fails, NO stocks from it are added.
#
#   2. Layer 2: Primary Filter (Mandatory)
#      - Input: The pool of stocks from Layer 1.
#      - Logic: Applied to every stock. Efficient "coarse" filtering (e.g., Price > 100, SMA Trend).
#
#   3. Layer 3: Refiner (Optional / Strategy Signals)
#      - Input: Stocks that passed Layer 2.
#      - Logic: "Fine" filtering for specific entry signals (e.g., RSI Crossover, MACD Buy).
#
# ==================================================================================================

import pandas as pd
import numpy as np
import psycopg2
import json
import os
import sys
from datetime import datetime, timedelta
from typing import List, Dict, Any, Union, Optional, Tuple, Set
from dataclasses import dataclass

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def get_db_connection():
    """Establishes a connection to the PostgreSQL database."""
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except Exception as e:
        print(f"Engine DB Conn Failed: {e}", file=sys.stderr)
        return None

# --- CONSTANTS & TYPES ---
ConditionJSON = Dict[str, Any]
StrategyJSON = Union[List[ConditionJSON], Dict[str, Any]] # Supports both legacy list and new dict formats

@dataclass
class MarketData:
    """Holds the dataframe for a specific symbol to ensure type safety."""
    symbol: str
    df: pd.DataFrame

# --- 1. INDICATOR LIBRARY (Self-Contained) ---
class Indicators:
    """
    Standard Technical Analysis Indicators.
    All methods expect a pandas Series/DataFrame and return a Series/DataFrame aligned to the index.
    """
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
        # Returns a localized DataFrame with columns 'MACD' and 'MACD_signal'
        return pd.DataFrame({'MACD': macd_line, 'MACD_signal': signal_line})

# --- DATA UTILS ---

def fetch_universe_symbols(universe_def: Union[str, List[str]], filters: List[ConditionJSON] = None) -> Tuple[List[str], int]:
    """
    LAYER 1: Defines the 'Target Universe'.
    
    Resolves a universe definition (Index Names) into a granular list of stock symbols.
    
    CRITICAL LOGIC ("The Gatekeeper"):
        If 'filters' are provided, they are applied to the INDEX ITSELF first.
        Example: "Nifty 50" with filter "Close > SMA(200)"
        - Step 1: Fetch NIFTY 50 Index OHLC data.
        - Step 2: Check if NIFTY 50 Close > NIFTY 50 SMA(200).
        - Step 3:
            - PASS: Return ALL 50 stocks in Nifty.
            - FAIL: Return 0 stocks.
    
    Args:
        universe_def: List of Index Names (e.g. ["Nifty 50"]) or explicit Symbols.
        filters: (Optional) List of logic conditions to check against the Index's own data.
        
    Returns:
        (List[str], int): 
            - List of unique stock symbols to scan.
            - Count of Indices that passed the filter (useful for stats).
    """
    inputs = []
    if isinstance(universe_def, str):
        inputs = [universe_def]
    elif isinstance(universe_def, list):
        inputs = universe_def
    else:
        return [], 0
        
    conn = get_db_connection()
    if not conn: return inputs, 0 # Fallback
    
    final_symbols = set()
    filtered_index_count = 0
    engine = ConditionEngine()
    
    try:
        with conn.cursor() as cur:
            # 1. Identify which inputs are Indices vs Symbols
            # We look up the 'ref.index_mapping' table. 
            # Any input matching 'index_name' column is treated as an Index.
            cur.execute("""
                SELECT index_name, stock_symbol 
                FROM ref.index_mapping 
                WHERE index_name = ANY(%s)
            """, (inputs,))
            
            rows = cur.fetchall()
            
            # Map Index -> [List of Stocks]
            index_constituents = {}
            for idx_name, sym in rows:
                if idx_name not in index_constituents:
                    index_constituents[idx_name] = []
                index_constituents[idx_name].append(sym)
                
            found_indices = set(index_constituents.keys())

            # 2. Iterate through user inputs
            for item in inputs:
                # Case A: Input is a known Index (e.g. "NIFTY 50")
                if item in found_indices:
                    #GATEKEEPER CHECK: Apply Filters to the Index itself
                    should_include = True
                    if filters:
                        # Fetch OHLC data for the INDEX ITSELF (symbol="NIFTY 50")
                        idx_df = fetch_data_for_symbol(item)
                        
                        # Fail Closed: If no index data, we cannot verify condition, so exclude it.
                        if idx_df is None or len(idx_df) < 20: 
                            should_include = False
                        else:
                            # Evaluate Conditions
                            idx_market_data = MarketData(item, idx_df)
                            if not engine.apply_strategy(idx_market_data, filters):
                                should_include = False
                                
                    if should_include:
                        filtered_index_count += 1
                        # Add all stocks from this index to our scanning list
                        for sym in index_constituents[item]:
                            final_symbols.add(sym)
                            
                # Case B: Input is likely a direct Symbol (e.g. "RELIANCE")
                else:
                    final_symbols.add(item)
                    
    except Exception as e:
        print(f"Error fetching universe: {e}")
        return inputs, 0
    finally:
        conn.close()
        
    return list(final_symbols), filtered_index_count

def fetch_data_for_symbol(symbol: str, limit: int = 200) -> Optional[pd.DataFrame]:
    """
    Fetches daily OHLC data for a given symbol from 'ohlc.candles_1d'.
    Used for both Stocks and Indices.
    """
    conn = get_db_connection()
    if not conn: return None
    
    try:
        # We perform a robust fetch. While 'limit' could optimize, we generally fetch enough 
        # history (e.g. 200+ days) to calculate long-term moving averages (SMA 200).
        query = """
            SELECT candle_start as date, open, high, low, close, volume 
            FROM ohlc.candles_1d 
            WHERE symbol = %s 
            ORDER BY candle_start ASC
        """ 
        
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
    """
    Resamples Daily Data (D) to Higher Timeframes (W, M, Q, Y).
    Crucial for Multi-Timeframe Analysis (e.g. Close(Weekly) > SMA(20, Weekly)).
    """
    if not timeframe or timeframe in ['1d', 'day']:
        return df
    
    # Pandas Offset Aliases Mapping
    rule_map = {
        '1w': 'W-FRI', 'week': 'W-FRI',
        '2w': '2W-FRI', 'fortnight': '2W-FRI',
        '1mo': 'ME', 'month': 'ME', 
        '3mo': '3ME', 'quarter': '3ME',
        '1y': 'YE', 'year': 'YE'
    }
    
    rule = rule_map.get(timeframe.lower())
    if not rule:
        # Heuristic fallback for other strings
        if 'mo' in timeframe: rule = timeframe.replace('mo', 'M')
        elif 'y' in timeframe: rule = timeframe.replace('1y', 'A')
        else: return df 

    try:
        # Standard OHLC Aggregation Rule
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

# --- 2. CONDITION ENGINE ---
class ConditionEngine:
    """
    The Brain. Interprets JSON strategies and applies them to Market Data.
    """
    
    def apply_strategy(self, market_data: MarketData, strategy_input: StrategyJSON) -> bool:
        """
        Main Entry Point.
        Evaluates a list of conditions (AND/OR logic) against the provided market data.
        
        Args:
            market_data: Wrapper containing Symbol and DataFrame.
            strategy_input: JSON defining the logic (list of conditions or dict with logic operator).
            
        Returns:
            bool: True if the strategy passes, False otherwise.
        """
        if market_data.df is None or market_data.df.empty:
            return False

        conditions = []
        logic = "AND"

        # Handle Format Polymorphism (Legacy List vs New Dict)
        if isinstance(strategy_input, list):
            conditions = strategy_input 
        elif isinstance(strategy_input, dict):
            conditions = strategy_input.get("conditions", [])
            logic = strategy_input.get("logic", "AND")
        else:
            return True 

        if not conditions:
            return True

        # Evaluate each condition independently
        results = []
        for cond in conditions:
            results.append(self.evaluate_condition(market_data.df, cond))
            
        # Combine results based on logic gate
        if logic == "AND":
            return all(results)
        elif logic == "OR":
            return any(results)
        return False

    def evaluate_condition(self, base_df: pd.DataFrame, cond: ConditionJSON) -> bool:
        """
        Evaluates a SINGLE condition.
        Structure: [Left Side] [Operator] [Right Side]
        Example:   SMA(20)      >         Close
        """
        try:
            # 1. Parse Left Side
            # Check for specific timeframe (e.g. check Monthly RSI on Daily Data)
            tf_left = cond.get("timeframe", "1d")
            df_left = resample_data(base_df, tf_left)
            
            target_series = self._resolve_indicator(df_left, cond.get("indicator"), cond)
            # Support 'Offset': Check value 'n' candles ago
            left_val = self._get_value_at_offset(target_series, cond.get("offset", 0))

            # 2. Parse Right Side (Value or Indicator)
            
            # CRITICAL FIX: Numeric Value vs Indicator Name
            # The frontend sends right_indicator="number" when the user inputs a static value.
            # We must ignore the indicator lookup in this case and uses 'value' directly.
            r_ind = cond.get("right_indicator")
            
            if r_ind and r_ind != "number":
                # Right side is Dynamic (e.g. SMA(50))
                tf_right = cond.get("right_timeframe", "1d")
                df_right = resample_data(base_df, tf_right) 
                
                # Resolve the indicator series (note prefix 'right_' for params)
                right_series = self._resolve_indicator(df_right, r_ind, cond, prefix="right_")
                right_val = self._get_value_at_offset(right_series, cond.get("right_offset", 0))
            else:
                # Right side is Static (e.g. 100)
                right_val = float(cond.get("value", 0))

            # 3. Compare [Left] vs [Right]
            op = cond.get("operator")
            return self._compare(left_val, op, right_val)
        except Exception as e:
            # Any error during evaluation (e.g. missing data for SMA 200) results in Fail
            return False
    
    def _resolve_indicator(self, df: pd.DataFrame, name: str, params: Dict, prefix: str = "") -> pd.Series:
        """Resolves an indicator name string (e.g. 'rsi') to a pandas Series of values."""
        if not name: return pd.Series([0]*len(df))
        name = name.lower()
        
        # Raw Data
        if name in ['close', 'open', 'high', 'low', 'volume']:
            return df[name]
            
        # Indicators
        length = int(params.get(f"{prefix}length", 14))
        
        if name == 'sma': return Indicators.sma(df['close'], length)
        elif name == 'ema': return Indicators.ema(df['close'], length)
        elif name == 'rsi': return Indicators.rsi(df['close'], length)
        elif name == 'macd': return Indicators.macd(df['close'])['MACD'] 
        elif name == 'macd_signal': return Indicators.macd(df['close'])['MACD_signal']
        
        raise ValueError(f"Unknown indicator: {name}")

    def _get_value_at_offset(self, series: pd.Series, offset: int) -> float:
        """Helper to safely get value at index -1-offset."""
        idx = -1 - int(offset)
        if abs(idx) > len(series): return 0.0
        return float(series.iloc[idx])

    def _compare(self, left: float, op: str, right: float) -> bool:
        """Simple arithmetic comparison."""
        if op == ">": return left > right
        if op == "<": return left < right
        if op == "==": return left == right
        if op == ">=": return left >= right
        if op == "<=": return left <= right
        return False

# --- 4. ENGINE EXECUTION ---

def execute_scan_logic(logic: dict, limit_results: int = 50) -> Dict[str, Any]:
    """
    Preview Mode / Dry-Run.
    Executes logic but does not save to DB. Returns first 'limit_results' matches.
    """
    print(f"Executing Dry Run Logic: {json.dumps(logic)[:100]}...")
    engine = ConditionEngine()
    
    # Parse Logic used in both Dry-Run and Persisted Run
    if isinstance(logic, list): # Legacy
        universe_def = "Nifty 50" 
        universe_filters = None
        primary_filter = logic
        refiner = []
    else:
        universe_def = logic.get("universe", ["Nifty 50"])
        universe_filters = logic.get("universe_filters", []) # Layer 1 Filters
        primary_filter = logic.get("primary_filter", [])     # Layer 2
        refiner = logic.get("refiner", [])                   # Layer 3

    # Layer 1: Universe Selection
    universe_symbols, _ = fetch_universe_symbols(universe_def, universe_filters)
    stats = { "universe": len(universe_symbols), "primary": 0, "refiner": 0 }
    
    matches = []
    
    for sym in universe_symbols:
        df = fetch_data_for_symbol(sym)
        if df is None or len(df) < 50: continue
        
        market_data = MarketData(sym, df)

        # Layer 2: Primary Filter
        if not engine.apply_strategy(market_data, primary_filter):
            continue
        stats["primary"] += 1
            
        # Layer 3: Refiner
        # Note: If no refiner is set, it passes by default.
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
    """
    Main Entry Point for Scheduled Runs.
    Fetches scanner config from DB, runs logic, and persists results to 'trading.scanner_results'.
    Updates 'sys.scanners' with run statistics.
    """
    print(f"Starting Scanner Engine for ID: {scanner_id}")
    
    conn = get_db_connection()
    if not conn: return False
    engine = ConditionEngine()
    
    try:
        with conn.cursor() as cur:
            # Fetch Scanner Config
            cur.execute("SELECT name, logic_config FROM sys.scanners WHERE id = %s", (scanner_id,))
            res = cur.fetchone()
            if not res: return False
            scanner_name, logic = res
            if isinstance(logic, str): logic = json.loads(logic)
            
            # Parse Logic
            if isinstance(logic, list):
                universe_def = "Nifty 50" 
                universe_filters = None
                primary_filter = logic
                refiner = []
            else:
                universe_def = logic.get("universe", ["Nifty 50"])
                universe_filters = logic.get("universe_filters", [])
                primary_filter = logic.get("primary_filter", [])
                refiner = logic.get("refiner", [])

            # Layer 1
            universe_symbols, _ = fetch_universe_symbols(universe_def, universe_filters)
            stats = { "universe": len(universe_symbols), "primary": 0, "refiner": 0 }
            print(f"[{scanner_name}] Universe: {len(universe_symbols)}")
            
            matches = []
            for sym in universe_symbols:
                df = fetch_data_for_symbol(sym)
                if df is None or len(df) < 50: continue
                
                market_data = MarketData(sym, df)
                
                # Layer 2
                if not engine.apply_strategy(market_data, primary_filter): continue
                stats["primary"] += 1
                
                final_match = False
                # Layer 3
                if refiner:
                    if engine.apply_strategy(market_data, refiner): 
                        final_match = True
                        stats["refiner"] += 1
                else:
                    final_match = True
                    stats["refiner"] += 1
                    
                if final_match:
                    # Capture Data for Result
                    last_row = df.iloc[-1].to_dict()
                    last_row = {k: str(v) for k, v in last_row.items()}
                    matches.append((sym, last_row))
            
            # Save Results (Batch Insert)
            run_time = datetime.now()
            batch_values = [(scanner_id, run_time, sym, json.dumps(data)) for sym, data in matches]
            if batch_values:
                query = "INSERT INTO trading.scanner_results (scanner_id, run_date, symbol, match_data) VALUES %s"
                from psycopg2.extras import execute_values
                execute_values(cur, query, batch_values)
            
            # Update Scanner Metadata
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
