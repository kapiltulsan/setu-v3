import pandas as pd
import numpy as np
from typing import List, Dict, Any, Optional

class VolatilitySqueezeBacktester:
    """
    Backtesting engine for the Volatility Squeeze Breakout strategy.
    
    Strategy Rules:
    - SMA_30: 30-period SMA of Close.
    - Bollinger Bands: (20, 2).
    - BB_Width: (Upper - Lower) / Middle.
    - Volume_SMA: 20-period SMA of Volume.
    - ATR_14: 14-period ATR.
    - Highest_High_20: Rolling Max of High over 20 periods.
    
    Entry Logic (Time t):
    1. Close_t < 5000 AND Close_t > SMA_30_t
    2. Close_{t-1} <= UBB_{t-1} AND Close_t > UBB_t
    3. Volume_t > (Volume_SMA_t * 1.2)
    4. BB_Width_{t-1} == min(BB_Width for 20-period ending at t-1)
    5. BB_Width_{t-1} < 0.12
    
    Exit Logic:
    - Chandelier Stop: StopPrice = HighestHigh_20 - (3 * ATR_14).
    - StopPrice only moves up.
    - Exit if Close < StopPrice.
    """
    
    def __init__(self, df: pd.DataFrame):
        self.df = df.copy()
        self._validate_data()
        self._calculate_indicators()
        self._generate_signals()
        
    def _validate_data(self):
        required_columns = ['Date', 'Open', 'High', 'Low', 'Close', 'Volume']
        for col in required_columns:
            if col not in self.df.columns:
                raise ValueError(f"Missing required column: {col}")
        
        # Ensure date sorting
        self.df['Date'] = pd.to_datetime(self.df['Date'])
        self.df = self.df.sort_values('Date').reset_index(drop=True)
        
    def _calculate_indicators(self):
        # SMA 30
        self.df['SMA_30'] = self.df['Close'].rolling(window=30).mean()
        
        # Bollinger Bands (20, 2)
        mid = self.df['Close'].rolling(window=20).mean()
        std = self.df['Close'].rolling(window=20).std()
        self.df['UBB'] = mid + (2 * std)
        self.df['LBB'] = mid - (2 * std)
        self.df['BB_Width'] = (self.df['UBB'] - self.df['LBB']) / mid
        
        # Volume SMA 20
        self.df['Volume_SMA_20'] = self.df['Volume'].rolling(window=20).mean()
        
        # ATR 14
        high_low = self.df['High'] - self.df['Low']
        high_close = (self.df['High'] - self.df['Close'].shift()).abs()
        low_close = (self.df['Low'] - self.df['Close'].shift()).abs()
        ranges = pd.concat([high_low, high_close, low_close], axis=1)
        true_range = ranges.max(axis=1)
        self.df['ATR_14'] = true_range.rolling(window=14).mean()
        
        # Highest High 20
        self.df['Highest_High_20'] = self.df['High'].rolling(window=20).max()
        
        # Minimal Band Width in 20-period window
        self.df['Min_BBW_20'] = self.df['BB_Width'].rolling(window=20).min()
        
    def _generate_signals(self):
        # Condition 1: Price Filter
        cond1 = (self.df['Close'] < 5000) & (self.df['Close'] > self.df['SMA_30'])
        
        # Condition 2: Breakout
        cond2 = (self.df['Close'].shift(1) <= self.df['UBB'].shift(1)) & (self.df['Close'] > self.df['UBB'])
        
        # Condition 3: Volume Surge
        cond3 = self.df['Volume'] > (self.df['Volume_SMA_20'] * 1.2)
        
        # Condition 4 & 5: Squeeze
        # BB_Width at t-1 must be min in last 20 periods AND < 0.12
        cond4_5 = (self.df['BB_Width'].shift(1) == self.df['Min_BBW_20'].shift(1)) & (self.df['BB_Width'].shift(1) < 0.12)
        
        self.df['Buy_Signal'] = cond1 & cond2 & cond3 & cond4_5
        
    def run_backtest(self) -> pd.DataFrame:
        trade_log = []
        is_in_trade = False
        entry_date = None
        entry_price = 0.0
        stop_price = 0.0
        
        for i in range(len(self.df)):
            row = self.df.iloc[i]
            
            if not is_in_trade:
                if row['Buy_Signal']:
                    is_in_trade = True
                    entry_date = row['Date']
                    entry_price = row['Close']
                    # Initial stop price
                    stop_price = row['Highest_High_20'] - (3 * row['ATR_14'])
            else:
                # Update trailing stop (never moves down)
                current_stop = row['Highest_High_20'] - (3 * row['ATR_14'])
                if current_stop > stop_price:
                    stop_price = current_stop
                
                # Check for exit
                if row['Close'] < stop_price:
                    exit_date = row['Date']
                    exit_price = row['Close']
                    holding_period_days = (exit_date - entry_date).days
                    
                    # CAGR per trade: ((exit_price / entry_price) ** (365.25 / days) - 1) * 100
                    trade_years = holding_period_days / 365.25
                    trade_cagr = ((exit_price / entry_price) ** (1 / trade_years) - 1) * 100 if trade_years > 0 else 0
                    
                    trade_log.append({
                        'Entry_Date': entry_date,
                        'Entry_Price': entry_price,
                        'Exit_Date': exit_date,
                        'Exit_Price': exit_price,
                        'PnL_Percent': pnl_pct,
                        'Holding_Period_Days': holding_period_days,
                        'CAGR': trade_cagr
                    })
                    is_in_trade = False
                    
        self.trade_log = pd.DataFrame(trade_log)
        return self.trade_log

    def get_metrics(self) -> Dict[str, Any]:
        if self.trade_log.empty:
            return {
                'Total_Trades': 0,
                'Win_Rate': 0.0,
                'Average_PnL': 0.0,
                'Max_Drawdown': 0.0,
                'Total_PnL_Value': 0.0,
                'CAGR': 0.0
            }
        
        capital_total = 100000.0
        capital_per_trade = 10000.0
        
        total_trades = len(self.trade_log)
        wins = self.trade_log[self.trade_log['PnL_Percent'] > 0]
        win_rate = (len(wins) / total_trades) * 100
        avg_pnl_pct = self.trade_log['PnL_Percent'].mean()
        
        # Absolute PnL per trade and Total
        self.trade_log['PnL_Value'] = (self.trade_log['PnL_Percent'] / 100) * capital_per_trade
        total_pnl_value = self.trade_log['PnL_Value'].sum()
        
        # Max Drawdown calculation based on cumulative equity
        # We assume trades happen sequentially or at least we track the portfolio effect
        equity = capital_total + self.trade_log['PnL_Value'].cumsum()
        running_max = equity.cummax()
        drawdown = (equity - running_max) / running_max
        max_drawdown = drawdown.min() * 100
        
        # CAGR Calculation
        start_date = self.df['Date'].min()
        end_date = self.df['Date'].max()
        years = (end_date - start_date).days / 365.25
        
        final_value = capital_total + total_pnl_value
        cagr = ((final_value / capital_total) ** (1 / years) - 1) * 100 if years > 0 else 0
        
        return {
            'Total_Trades': total_trades,
            'Win_Rate': win_rate,
            'Average_PnL': avg_pnl_pct,
            'Max_Drawdown': max_drawdown,
            'Total_PnL_Value': total_pnl_value,
            'CAGR': cagr,
            'Final_Value': final_value
        }

    def plot_trade_data(self, entry_date: pd.Timestamp):
        # This will be used to provide data for frontend visualization
        # Find index for entry - Ensure TZ naive comparison
        search_date = pd.to_datetime(entry_date).replace(tzinfo=None)
        
        matching_rows = self.df[self.df['Date'].dt.tz_localize(None) == search_date]
        if matching_rows.empty:
            return []
            
        idx = matching_rows.index[0]
        start_idx = max(0, idx - 20)
        
        # Find exit date for this trade
        trade_info = self.trade_log[self.trade_log['Entry_Date'].dt.tz_localize(None) == search_date]
        if trade_info.empty:
            return []
            
        exit_date = trade_info['Exit_Date'].iloc[0]
        exit_idx = self.df[self.df['Date'].dt.tz_localize(None) == exit_date.replace(tzinfo=None)].index[0]
        end_idx = min(len(self.df) - 1, exit_idx + 5)
        
        plot_df = self.df.iloc[start_idx : end_idx + 1].copy()
        
        # Calculate dynamic stop line for this trade window
        trade_stops = []
        current_stop = 0
        in_window = False
        
        # We only care about the window [start_idx, end_idx]
        for i in range(start_idx, end_idx + 1):
            row = self.df.iloc[i]
            if row['Date'] == entry_date:
                in_window = True
                current_stop = row['Highest_High_20'] - (3 * row['ATR_14'])
            
            if in_window:
                new_stop = row['Highest_High_20'] - (3 * row['ATR_14'])
                if new_stop > current_stop:
                    current_stop = new_stop
                trade_stops.append(current_stop)
                
                if row['Date'] == exit_date:
                    in_window = False
            else:
                trade_stops.append(None) # Use None for better JSON handling
        
        plot_df['Trailing_Stop'] = trade_stops
        
        return plot_df.replace({np.nan: None}).to_dict(orient='records')
