
import pandas as pd
import numpy as np
import logging
from typing import List, Dict, Any, Union, Optional
from dataclasses import dataclass
from abc import ABC, abstractmethod
import random
from datetime import datetime, timedelta

# --- Logging Setup ---
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("FunnelEngine")

# --- Type Definitions ---
ConditionJSON = Dict[str, Any]
StrategyJSON = Dict[str, Any]

@dataclass
class MarketData:
    symbol: str
    df: pd.DataFrame

# --- 1. Custom Indicator Library (Mocking pandas_ta behavior) ---
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

# --- 2. Condition Engine ---
class ConditionEngine:
    """Interprets JSON strategies and applies them to DataFrames."""
    
    def apply_strategy(self, market_data: MarketData, strategy: StrategyJSON) -> bool:
        """
        Evaluates a full strategy (list of conditions) against a symbol's data.
        Returns True if ALL conditions match (assuming 'AND' logic).
        """
        logic = strategy.get("logic", "AND")
        conditions = strategy.get("conditions", [])
        
        results = []
        for cond in conditions:
            results.append(self.evaluate_condition(market_data.df, cond))
            
        if logic == "AND":
            return all(results)
        elif logic == "OR":
            return any(results)
        return False

    def evaluate_condition(self, df: pd.DataFrame, cond: ConditionJSON) -> bool:
        """Evaluates a single condition."""
        # Ensure we have enough data
        if df.empty: return False

        # 1. Parse Left Side
        left_series = self._resolve_indicator(df, cond.get("indicator"), cond)
        left_val = self._get_value_at_offset(left_series, cond.get("offset", 0))

        # 2. Parse Right Side (Value or Indicator)
        if "right_indicator" in cond:
            right_series = self._resolve_indicator(df, cond.get("right_indicator"), cond, prefix="right_")
            right_val = self._get_value_at_offset(right_series, cond.get("right_offset", 0))
        else:
            right_val = cond.get("value")

        # 3. Compare
        op = cond.get("operator")
        return self._compare(left_val, op, right_val)

    def _resolve_indicator(self, df: pd.DataFrame, name: str, params: Dict, prefix: str = "") -> pd.Series:
        """Calculates or retrieves the indicator series."""
        # Basic Columns
        if name in ['close', 'open', 'high', 'low', 'volume']:
            return df[name]
        
        # Technical Indicators
        length = params.get(f"{prefix}length", 14)
        
        if name == 'sma':
            return Indicators.sma(df['close'], length)
        elif name == 'ema':
            return Indicators.ema(df['close'], length)
        elif name == 'rsi':
            return Indicators.rsi(df['close'], length)
        elif name == 'macd':
            # Special case: MACD returns df, we might need specific line
            macd_df = Indicators.macd(df['close'])
            return macd_df['MACD'] 
        elif name == 'macd_signal':
            macd_df = Indicators.macd(df['close'])
            return macd_df['MACD_signal']
            
        raise ValueError(f"Unknown indicator: {name}")

    def _get_value_at_offset(self, series: pd.Series, offset: int) -> float:
        """Gets the value at the specified offset (0 = latest)."""
        idx = -1 - offset
        if abs(idx) > len(series):
            return 0.0
        return float(series.iloc[idx])

    def _compare(self, left: float, op: str, right: float) -> bool:
        if op == ">": return left > right
        if op == "<": return left < right
        if op == "==": return left == right
        if op == ">=": return left >= right
        if op == "<=": return left <= right
        # CrossAbove/Below would ideally need history access, simplifying for scalar comparison
        # Logic: Current > Right AND Prev < Right (would need architectural tweak for Prev)
        # For this prototype, treating CrossAbove same as > for scalar context, 
        # but in real engine we pass the full series to _compare logic.
        return False

# --- 3. Mock Data Provider ---
class MockDataProvider:
    def __init__(self):
        self.indices = ['NIFTY 50', 'NIFTY BANK', 'NIFTY METAL', 'NIFTY IT']
        self.stocks_map = {
            'NIFTY 50': [f'NIFTY50_STOCK_{i}' for i in range(1, 11)], # 10 stocks
            'NIFTY BANK': [f'BANK_STOCK_{i}' for i in range(1, 6)],   # 5 stocks
            'NIFTY METAL': [f'METAL_STOCK_{i}' for i in range(1, 6)],
            'NIFTY IT': [f'IT_STOCK_{i}' for i in range(1, 6)]
        }

    def get_indices(self) -> List[str]:
        return self.indices

    def get_index_constituents(self, index_symbol: str) -> List[str]:
        return self.stocks_map.get(index_symbol, [])

    def _generate_ohlc(self, length=200, trend=0) -> pd.DataFrame:
        """Generates random OHLC data with optional trend."""
        dates = pd.date_range(end=datetime.today(), periods=length)
        close = 100 + np.cumsum(np.random.randn(length) + trend)
        df = pd.DataFrame({
            'open': close + np.random.randn(length),
            'high': close + abs(np.random.randn(length)),
            'low': close - abs(np.random.randn(length)),
            'close': close,
            'volume': np.random.randint(1000, 100000, length)
        }, index=dates)
        return df

    def get_index_ohlc(self, symbol: str) -> MarketData:
        # Simulate Nifty Metal is downtrending, others random
        trend = -0.5 if symbol == 'NIFTY METAL' else 0.1
        return MarketData(symbol, self._generate_ohlc(trend=trend))

    def get_stock_ohlc(self, symbol: str) -> MarketData:
        # Random bullish/bearish
        trend = random.choice([-0.2, 0.2, 0.5])
        return MarketData(symbol, self._generate_ohlc(trend=trend))

# --- 4. The Funnel Logic (Main Workflow) ---
def run_funnel():
    engine = ConditionEngine()
    provider = MockDataProvider()

    # --- INPUTS ---
    selected_indices = ['NIFTY 50', 'NIFTY BANK', 'NIFTY METAL']
    
    # Strategy Definition
    strategy_a_index_trend = {
        "layer_name": "Layer 1.5: Index Trend Check",
        "conditions": [
            # Index Price > EMA 50
            { "indicator": "close", "operator": ">", "right_indicator": "ema", "right_length": 50 }
        ]
    }

    strategy_b_stock_broad = {
        "layer_name": "Layer 2: Stock RSI Filter",
        "conditions": [
             # Stock RSI > 50
            { "indicator": "rsi", "length": 14, "operator": ">", "value": 50 }
        ]
    }
    
    strategy_c_stock_refine = {
        "layer_name": "Layer 3: Stock Momentum Refiner",
        "conditions": [
             # Close > SMA 20 (Strong Short Term)
            { "indicator": "close", "operator": ">", "right_indicator": "sma", "right_length": 20 }
        ]
    }

    print("\n" + "="*50)
    print("🚀 STARTING MULTI-LAYER FUNNEL SCAN")
    print("="*50)

    # --- LAYER 1: SELECTION ---
    logger.info(f"Layer 1 (Selection): User selected {len(selected_indices)} Indices: {selected_indices}")
    
    # --- LAYER 1.5: INDEX FILTER ---
    passing_indices = []
    failed_indices = []
    
    for idx_sym in selected_indices:
        data = provider.get_index_ohlc(idx_sym)
        is_passed = engine.apply_strategy(data, strategy_a_index_trend)
        
        if is_passed:
            passing_indices.append(idx_sym)
        else:
            failed_indices.append(idx_sym)
            
    logger.info(f"Layer 1.5 (Index Trend): {len(passing_indices)} Passed, {len(failed_indices)} Failed.")
    logger.info(f"  -> Passed: {passing_indices}")
    logger.info(f"  -> Failed: {failed_indices} (Data fetching for these will be skipped)")

    # --- INTERMEDIARY: EXPANSION ---
    candidate_stocks = []
    for idx_sym in passing_indices:
        constituents = provider.get_index_constituents(idx_sym)
        candidate_stocks.extend(constituents)
    
    candidate_stocks = list(set(candidate_stocks)) # Unique
    logger.info(f"Intermediary: Expanded into {len(candidate_stocks)} Unique Stocks.")

    # --- LAYER 2: STOCK BROAD FILTER ---
    layer2_survivors = []
    for stock_sym in candidate_stocks:
        data = provider.get_stock_ohlc(stock_sym)
        if engine.apply_strategy(data, strategy_b_stock_broad):
            layer2_survivors.append(stock_sym)
            
    logger.info(f"Layer 2 (Broad Filter): Reduced to {len(layer2_survivors)} Stocks.")

    # --- LAYER 3: REFINEMENT ---
    final_list = []
    for stock_sym in layer2_survivors:
        data = provider.get_stock_ohlc(stock_sym)
        if engine.apply_strategy(data, strategy_c_stock_refine):
            final_list.append(stock_sym)

    logger.info(f"Layer 3 (Refinement): 🎯 Found {len(final_list)} Trade-Ready Stocks.")
    
    print("\n🏆 FINAL RESULTS:")
    print(final_list)

if __name__ == "__main__":
    run_funnel()
