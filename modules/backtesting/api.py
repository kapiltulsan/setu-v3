import traceback
from flask import Blueprint, jsonify, request
from modules.backtesting.volatility_squeeze import VolatilitySqueezeBacktester
from modules.scanner_engine import fetch_data_for_symbol, resample_data
import pandas as pd

backtesting_bp = Blueprint('backtesting', __name__)

@backtesting_bp.route('/api/backtest/volatility-squeeze', methods=['POST'])
def run_volatility_squeeze_backtest():
    """
    Triggers the Volatility Squeeze Backtest for a symbol or a universe.
    """
    try:
        data = request.json
        symbol = data.get('symbol')
        universe = data.get('universe')  # List of index names
        all_indices = data.get('all_indices', False)
        
        symbols = []
        if symbol:
            from modules.scanner_engine import fetch_universe_symbols
            symbols, _ = fetch_universe_symbols(symbol)
        elif all_indices:
            from modules.scanners import get_indices_list
            indices = get_indices_list()
            from modules.scanner_engine import fetch_universe_symbols
            symbols, _ = fetch_universe_symbols(indices)
        elif universe:
            from modules.scanner_engine import fetch_universe_symbols
            symbols, _ = fetch_universe_symbols(universe)
        
        if not symbols:
            return jsonify({"error": "No symbols resolved for backtest"}), 400
        
        all_trades = []
        all_symbol_metrics = []
        
        for sym in symbols:
            # 1. Fetch Data (Daily)
            df_daily = fetch_data_for_symbol(sym, limit=2000)
            if df_daily is None or df_daily.empty:
                continue
            
            # 2. Resample to Weekly
            df_weekly = resample_data(df_daily, timeframe='week')
            if df_weekly.empty:
                continue
            
            df_weekly = df_weekly.rename(columns={
                'open': 'Open', 'high': 'High', 'low': 'Low', 'close': 'Close', 'volume': 'Volume'
            })
            df_weekly['Date'] = df_weekly.index
            df_weekly = df_weekly.reset_index(drop=True)
            
            # 3. Run Backtest
            engine = VolatilitySqueezeBacktester(df_weekly)
            trade_log = engine.run_backtest()
            metrics = engine.get_metrics()
            
            if not trade_log.empty:
                trade_log['Symbol'] = sym
                all_trades.append(trade_log)
                all_symbol_metrics.append({**metrics, 'Symbol': sym})
        
        if not all_trades:
            return jsonify({
                "status": "success",
                "metrics": {"Total_Trades": 0, "Win_Rate": 0, "Average_PnL": 0, "Max_Drawdown": 0},
                "trade_log": []
            })
        
        # 4. Aggregate Metrics
        combined_trade_log = pd.concat(all_trades).sort_values('Entry_Date').reset_index(drop=True)
        
        capital_total = 100000.0
        capital_per_trade = 10000.0
        
        total_trades = len(combined_trade_log)
        wins = combined_trade_log[combined_trade_log['PnL_Percent'] > 0]
        win_rate = (len(wins) / total_trades) * 100 if total_trades > 0 else 0
        avg_pnl_pct = combined_trade_log['PnL_Percent'].mean()
        
        # Absolute PnL per trade and Total
        combined_trade_log['PnL_Value'] = (combined_trade_log['PnL_Percent'] / 100) * capital_per_trade
        total_pnl_value = combined_trade_log['PnL_Value'].sum()
        
        # Portfolio Max Drawdown calculation (Sequence of trades)
        combined_trade_log['Equity'] = capital_total + combined_trade_log['PnL_Value'].cumsum()
        running_max = combined_trade_log['Equity'].cummax()
        drawdown = (combined_trade_log['Equity'] - running_max) / running_max
        max_drawdown = drawdown.min() * 100
        
        # CAGR Calculation
        # For multi-symbol, we use the date range of all symbols processed
        all_dates = pd.to_datetime(combined_trade_log['Entry_Date'].tolist() + combined_trade_log['Exit_Date'].tolist())
        start_date = all_dates.min()
        end_date = all_dates.max()
        years = (end_date - start_date).days / 365.25
        
        final_value = capital_total + total_pnl_value
        cagr = ((final_value / capital_total) ** (1 / years) - 1) * 100 if years > 0 else 0
        
        return jsonify({
            "status": "success",
            "metrics": {
                "Total_Trades": total_trades,
                "Win_Rate": win_rate,
                "Average_PnL": avg_pnl_pct,
                "Max_Drawdown": max_drawdown,
                "Total_PnL_Value": total_pnl_value,
                "CAGR": cagr,
                "Final_Value": final_value
            },
            "trade_log": combined_trade_log.to_dict(orient='records')
        })
        
    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500
        
    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500

@backtesting_bp.route('/api/backtest/volatility-squeeze/plot', methods=['POST'])
def get_volatility_squeeze_plot_data():
    """
    Returns data for plotting a specific trade.
    """
    try:
        data = request.json
        symbol = data.get('symbol')
        entry_date = data.get('entry_date')
        
        if not symbol or not entry_date:
            return jsonify({"error": "Symbol and entry_date are required"}), 400
            
        # 1. Fetch Data
        df_daily = fetch_data_for_symbol(symbol, limit=2000)
        if df_daily is None:
            return jsonify({"error": "Data not found"}), 404
            
        df_weekly = resample_data(df_daily, timeframe='week')
        df_weekly = df_weekly.rename(columns={
            'open': 'Open', 'high': 'High', 'low': 'Low', 'close': 'Close', 'volume': 'Volume'
        })
        df_weekly['Date'] = df_weekly.index
        df_weekly = df_weekly.reset_index(drop=True)
        
        # 2. Run Backtest to get signals and state
        engine = VolatilitySqueezeBacktester(df_weekly)
        engine.run_backtest()
        
        # 3. Get Plot Data
        plot_data = engine.plot_trade_data(pd.to_datetime(entry_date))
        
        return jsonify({
            "status": "success",
            "plot_data": plot_data
        })
        
    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500
