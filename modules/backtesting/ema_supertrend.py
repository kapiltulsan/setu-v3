import pandas as pd
import numpy as np
from typing import List, Dict, Any, Optional

class EMASupertrendBacktester:
    """
    Backtesting engine for the EMA 200 + Supertrend Strategy.
    
    Strategy Rules:
    - EMA 200: 200-period EMA of Close.
    - Supertrend: (10, 3.0) ATR-based indicator.
    
    Entry Logic:
    - Long Entry: Close > EMA 200 AND Supertrend just turned Green (Bullish).
    - Short Entry: Close < EMA 200 AND Supertrend just turned Red (Bearish).
    
    Exit Logic:
    - Long Exit: Supertrend turns Red.
    - Short Exit: Supertrend turns Green.
    """
    
    def __init__(self, df: pd.DataFrame, ema_length: int = 200, atr_period: int = 10, atr_multiplier: float = 3.0):
        self.df = df.copy()
        self.ema_length = ema_length
        self.atr_period = atr_period
        self.atr_multiplier = atr_multiplier
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
        # EMA
        self.df['EMA_200'] = self.df['Close'].ewm(span=self.ema_length, adjust=False).mean()
        
        # ATR calculation
        high_low = self.df['High'] - self.df['Low']
        high_close = (self.df['High'] - self.df['Close'].shift()).abs()
        low_close = (self.df['Low'] - self.df['Close'].shift()).abs()
        ranges = pd.concat([high_low, high_close, low_close], axis=1)
        true_range = ranges.max(axis=1)
        self.df['ATR'] = true_range.rolling(window=self.atr_period).mean()
        
        # Supertrend calculation
        hl2 = (self.df['High'] + self.df['Low']) / 2
        self.df['upper_band'] = hl2 + (self.atr_multiplier * self.df['ATR'])
        self.df['lower_band'] = hl2 - (self.atr_multiplier * self.df['ATR'])
        
        # Initialize columns
        self.df['in_trend'] = np.nan
        self.df['supertrend'] = np.nan
        self.df['direction'] = 0 # 1 for Bullish (Green), -1 for Bearish (Red)
        
        upper_band = self.df['upper_band'].values
        lower_band = self.df['lower_band'].values
        close = self.df['Close'].values
        
        final_upper_band = np.copy(upper_band)
        final_lower_band = np.copy(lower_band)
        supertrend = np.zeros(len(self.df))
        direction = np.zeros(len(self.df))
        
        # We need at least atr_period bars to start
        for i in range(self.atr_period, len(self.df)):
            # Final Upper Band
            if upper_band[i] < final_upper_band[i-1] or close[i-1] > final_upper_band[i-1]:
                final_upper_band[i] = upper_band[i]
            else:
                final_upper_band[i] = final_upper_band[i-1]
                
            # Final Lower Band
            if lower_band[i] > final_lower_band[i-1] or close[i-1] < final_lower_band[i-1]:
                final_lower_band[i] = lower_band[i]
            else:
                final_lower_band[i] = final_lower_band[i-1]
            
            # Direction and Supertrend
            if i == self.atr_period:
                # Initialize first direction
                if close[i] > final_upper_band[i]:
                    direction[i] = 1 # Bullish
                else:
                    direction[i] = -1 # Bearish
            else:
                if direction[i-1] == 1: # Bullish
                    if close[i] < final_lower_band[i]:
                        direction[i] = -1 # Turn Bearish
                    else:
                        direction[i] = 1 # Stay Bullish
                else: # Bearish
                    if close[i] > final_upper_band[i]:
                        direction[i] = 1 # Turn Bullish
                    else:
                        direction[i] = -1 # Stay Bearish
            
            if direction[i] == 1:
                supertrend[i] = final_lower_band[i]
            else:
                supertrend[i] = final_upper_band[i]
                
        self.df['supertrend'] = supertrend
        self.df['direction'] = direction
        
    def _generate_signals(self):
        # 1 for Bullish (Green), -1 for Bearish (Red) in self.df['direction']
        # Pine Script: direction < 0 is Bullish, direction > 0 is Bearish
        # My Python mapping: direction == 1 is Bullish (Green), direction == -1 is Bearish (Red)
        
        st_bullish = self.df['direction'] == 1
        st_bearish = self.df['direction'] == -1
        
        st_bullish_prev = self.df['direction'].shift(1) == 1
        st_bearish_prev = self.df['direction'].shift(1) == -1
        
        # stTurnedGreen = stBullish and stBearishPrev
        st_turned_green = st_bullish & st_bearish_prev
        # stTurnedRed = stBearish and stBullishPrev
        st_turned_red = st_bearish & st_bullish_prev
        
        # aboveEMA = close > ema200
        above_ema = self.df['Close'] > self.df['EMA_200']
        # belowEMA = close < ema200
        below_ema = self.df['Close'] < self.df['EMA_200']
        
        # longCondition = aboveEMA and stTurnedGreen
        self.df['Long_Entry'] = above_ema & st_turned_green
        # shortCondition = belowEMA and stTurnedRed
        self.df['Short_Entry'] = below_ema & st_turned_red
        
        # longExit = stTurnedRed
        self.df['Long_Exit'] = st_turned_red
        # shortExit = stTurnedGreen
        self.df['Short_Exit'] = st_turned_green
        
    def run_backtest(self, initial_capital: float = 10000.0) -> pd.DataFrame:
        trade_log = []
        is_in_long = False
        is_in_short = False
        entry_date = None
        entry_price = 0.0
        
        for i in range(len(self.df)):
            row = self.df.iloc[i]
            
            # Entry conditions
            if not is_in_long and not is_in_short:
                if row['Long_Entry']:
                    is_in_long = True
                    entry_date = row['Date']
                    entry_price = row['Close']
                elif row['Short_Entry']:
                    is_in_short = True
                    entry_date = row['Date']
                    entry_price = row['Close']
            
            # Exit conditions
            elif is_in_long:
                if row['Long_Exit']:
                    exit_date = row['Date']
                    exit_price = row['Close']
                    pnl_pct = ((exit_price - entry_price) / entry_price) * 100
                    holding_period_days = (exit_date - entry_date).days
                    
                    # CAGR per trade
                    trade_years = holding_period_days / 365.25
                    trade_factor = (exit_price / entry_price)
                    trade_cagr = (trade_factor ** (1 / trade_years) - 1) * 100 if trade_years > 0 and trade_factor > 0 else 0
                    
                    trade_log.append({
                        'Symbol': 'TBD',
                        'Type': 'Long',
                        'Entry_Date': entry_date,
                        'Entry_Price': entry_price,
                        'Exit_Date': exit_date,
                        'Exit_Price': exit_price,
                        'PnL_Percent': pnl_pct,
                        'PnL_Value': (pnl_pct / 100) * initial_capital,
                        'Holding_Period_Days': holding_period_days,
                        'CAGR': trade_cagr
                    })
                    is_in_long = False
                    # Check if we should immediately enter short
                    if row['Short_Entry']:
                        is_in_short = True
                        entry_date = row['Date']
                        entry_price = row['Close']
                        
            elif is_in_short:
                if row['Short_Exit']:
                    exit_date = row['Date']
                    exit_price = row['Close']
                    # Short PnL: ((entry - exit) / entry) * 100
                    pnl_pct = ((entry_price - exit_price) / entry_price) * 100
                    holding_period_days = (exit_date - entry_date).days
                    
                    # CAGR per trade (Short)
                    # For short, we use the return multiplier: 1 + (entry-exit)/entry = (2*entry - exit) / entry
                    trade_years = holding_period_days / 365.25
                    trade_factor = (2 * entry_price - exit_price) / entry_price
                    trade_cagr = (trade_factor ** (1 / trade_years) - 1) * 100 if trade_years > 0 and trade_factor > 0 else 0
                    
                    trade_log.append({
                        'Symbol': 'TBD',
                        'Type': 'Short',
                        'Entry_Date': entry_date,
                        'Entry_Price': entry_price,
                        'Exit_Date': exit_date,
                        'Exit_Price': exit_price,
                        'PnL_Percent': pnl_pct,
                        'PnL_Value': (pnl_pct / 100) * initial_capital,
                        'Holding_Period_Days': holding_period_days,
                        'CAGR': trade_cagr
                    })
                    is_in_short = False
                    # Check if we should immediately enter long
                    if row['Long_Entry']:
                        is_in_long = True
                        entry_date = row['Date']
                        entry_price = row['Close']
                        
        self.trade_log = pd.DataFrame(trade_log)
        return self.trade_log

    def get_metrics(self, initial_capital: float = 10000.0) -> Dict[str, Any]:
        if self.trade_log.empty:
            return {
                'Total_Trades': 0,
                'Win_Rate': 0.0,
                'Average_PnL': 0.0,
                'Max_Drawdown': 0.0,
                'Total_PnL_Value': 0.0,
                'CAGR': 0.0
            }
        
        total_trades = len(self.trade_log)
        wins = self.trade_log[self.trade_log['PnL_Percent'] > 0]
        win_rate = (len(wins) / total_trades) * 100
        avg_pnl_pct = self.trade_log['PnL_Percent'].mean()
        
        # Simple PnL calculation assuming full equity per trade
        total_pnl_value = self.trade_log['PnL_Value'].sum()
        
        # Max Drawdown
        equity = initial_capital + self.trade_log['PnL_Value'].cumsum()
        running_max = equity.cummax()
        drawdown = (equity - running_max) / running_max
        max_drawdown = drawdown.min() * 100
        
        # CAGR
        start_date = self.df['Date'].min()
        end_date = self.df['Date'].max()
        years = (end_date - start_date).days / 365.25
        
        final_value = initial_capital + total_pnl_value
        cagr = ((final_value / initial_capital) ** (1 / years) - 1) * 100 if years > 0 and final_value > 0 else 0
        
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
        search_date = pd.to_datetime(entry_date).replace(tzinfo=None)
        matching_rows = self.df[self.df['Date'].dt.tz_localize(None) == search_date]
        if matching_rows.empty:
            return []
            
        idx = matching_rows.index[0]
        start_idx = max(0, idx - 50)
        
        trade_info = self.trade_log[self.trade_log['Entry_Date'].dt.tz_localize(None) == search_date]
        if trade_info.empty:
            return []
            
        exit_date = trade_info['Exit_Date'].iloc[0]
        exit_idx = self.df[self.df['Date'].dt.tz_localize(None) == exit_date.replace(tzinfo=None)].index[0]
        end_idx = min(len(self.df) - 1, exit_idx + 20)
        
        plot_df = self.df.iloc[start_idx : end_idx + 1].copy()
        
        return plot_df.replace({np.nan: None}).to_dict(orient='records')
