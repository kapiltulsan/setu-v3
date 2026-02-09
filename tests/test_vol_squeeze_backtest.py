import os
import sys
import pandas as pd
import json

# Add project root to sys.path
sys.path.append('/home/pi50001_admin/SetuV3')

# Set environment variables for DB (assume they are in .env)
from dotenv import load_dotenv
load_dotenv()

from modules.backtesting.volatility_squeeze import VolatilitySqueezeBacktester
from modules.scanner_engine import fetch_data_for_symbol, resample_data

class LooseBacktester(VolatilitySqueezeBacktester):
    def _generate_signals(self):
        # Relaxed BB Width to 0.20 and removed volume surge for verification
        cond1 = (self.df['Close'] < 5000) & (self.df['Close'] > self.df['SMA_30'])
        cond2 = (self.df['Close'].shift(1) <= self.df['UBB'].shift(1)) & (self.df['Close'] > self.df['UBB'])
        cond4_5 = (self.df['BB_Width'].shift(1) < 0.20) # Relaxed
        self.df['Buy_Signal'] = cond1 & cond2 & cond4_5

def test_backtest_on_symbol(symbol: str):
    print(f"--- Verifying Backtest for {symbol} ---")
    
    # 1. Fetch Data
    print(f"Fetching data for {symbol}...")
    df_daily = fetch_data_for_symbol(symbol, limit=2000)
    if df_daily is None or df_daily.empty:
        print(f"Error: No data found for {symbol}")
        return
    
    print(f"Daily data rows: {len(df_daily)}")
    
    # 2. Resample to Weekly
    print("Resampling to weekly...")
    df_weekly = resample_data(df_daily, timeframe='week')
    if df_weekly.empty:
        print("Error: Resampling failed")
        return
    
    df_weekly = df_weekly.rename(columns={
        'open': 'Open', 'high': 'High', 'low': 'Low', 'close': 'Close', 'volume': 'Volume'
    })
    df_weekly['Date'] = df_weekly.index
    df_weekly = df_weekly.reset_index(drop=True)
    
    print(f"Weekly data rows: {len(df_weekly)}")
    
    # 3. Run Backtest
    print("Initializing Backtester...")
    engine = VolatilitySqueezeBacktester(df_weekly)
    
    print("Running Backtest...")
    trade_log = engine.run_backtest()
    metrics = engine.get_metrics()
    
    print("\n--- RESULTS ---")
    print(f"Total Trades: {metrics['Total_Trades']}")
    print(f"Win Rate: {metrics['Win_Rate']:.2f}%")
    print(f"Average PnL: {metrics['Average_PnL']:.2f}%")
    print(f"Max Drawdown: {metrics['Max_Drawdown']:.2f}%")
    
    if not trade_log.empty:
        print("\n--- SAMPLE TRADES (Last 5) ---")
        print(trade_log.tail(5).to_string())
    else:
        print("\nNo trades generated for this strategy on the selected data.")

def test_loose_backtest(symbol: str):
    print(f"--- Verifying Loose Backtest for {symbol} (Mechanics Check) ---")
    df_daily = fetch_data_for_symbol(symbol, limit=2000)
    df_weekly = resample_data(df_daily, timeframe='week')
    df_weekly = df_weekly.rename(columns={'open': 'Open', 'high': 'High', 'low': 'Low', 'close': 'Close', 'volume': 'Volume'})
    df_weekly['Date'] = df_weekly.index
    df_weekly = df_weekly.reset_index(drop=True)
    
    engine = LooseBacktester(df_weekly)
    trade_log = engine.run_backtest()
    metrics = engine.get_metrics()
    
    print(f"Trades with relaxed conditions: {len(trade_log)}")
    if not trade_log.empty:
        print(trade_log.head(5).to_string())

if __name__ == "__main__":
    test_backtest_on_symbol("RELIANCE")
    test_loose_backtest("RELIANCE")
