import pandas as pd
import numpy as np
from modules.backtesting.ema_supertrend import EMASupertrendBacktester

def generate_mock_data(n=500):
    dates = pd.date_range(start='2020-01-01', periods=n, freq='D')
    # Generate some random walk data with a trend
    np.random.seed(42)
    returns = np.random.normal(0.001, 0.02, n)
    price = 100 * np.exp(np.cumsum(returns))
    
    df = pd.DataFrame({
        'Date': dates,
        'Open': price * (1 + np.random.normal(0, 0.005, n)),
        'High': price * (1 + abs(np.random.normal(0, 0.01, n))),
        'Low': price * (1 - abs(np.random.normal(0, 0.01, n))),
        'Close': price,
        'Volume': np.random.randint(1000, 10000, n)
    })
    return df

def test_ema_supertrend():
    print("Generating mock data...")
    df = generate_mock_data(1000)
    
    print("Initializing Backtester...")
    engine = EMASupertrendBacktester(df)
    
    print("Indicators calculated.")
    print(f"EMA 200 last value: {engine.df['EMA_200'].iloc[-1]:.2f}")
    print(f"Supertrend last value: {engine.df['supertrend'].iloc[-1]:.2f}")
    print(f"Direction last value: {engine.df['direction'].iloc[-1]}")
    
    print("\nRunning Backtest...")
    trade_log = engine.run_backtest()
    
    if not trade_log.empty:
        print(f"Total trades: {len(trade_log)}")
        print(trade_log.head())
        metrics = engine.get_metrics()
        print("\nMetrics:")
        for k, v in metrics.items():
            print(f"{k}: {v}")
    else:
        print("No trades generated with mock data.")

if __name__ == "__main__":
    test_ema_supertrend()
