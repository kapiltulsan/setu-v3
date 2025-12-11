import os
import datetime
import psycopg2
from flask import Blueprint, jsonify, request, render_template
from psycopg2.extras import RealDictCursor
from db_logger import EnterpriseLogger

charts_bp = Blueprint('charts', __name__)
logger = EnterpriseLogger("mod_charts")

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS")
        )
        return conn
    except Exception as e:
        logger.log("error", "DB Connection Failed", exc_info=True)
        return None

@charts_bp.route('/charts')
def index():
    return render_template('charts.html')

@charts_bp.route('/api/history')
def get_history():
    symbol = request.args.get('symbol')
    timeframe = request.args.get('timeframe', '1D') # 1D or 60M
    
    if not symbol:
        return jsonify({"error": "Symbol required"}), 400

    # TimescaleDB Interval Mapping
    bucket_map = {
        '1D': '1 day',
        '1W': '1 week',
        '1M': '1 month',
        '1Y': '1 year'
    }
    
    interval = bucket_map.get(timeframe)
    
    # 60M is handled separately via table selection vs aggregation?
    # Actually, if timeframe is 60M, we query candles_60m. 
    # If timeframe is 1D+, we query candles_1d.
    
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "DB Connection failed"}), 500

    try:
        data = []
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            
            if timeframe == '60M':
                # Direct fetch for hourly
                query = """
                    SELECT candle_start as time, open, high, low, close, volume 
                    FROM ohlc.candles_60m
                    WHERE symbol = %s 
                    ORDER BY time ASC
                """
                cur.execute(query, (symbol,))
            elif timeframe == '1D':
                # Direct fetch for daily (faster than bucket)
                query = """
                    SELECT candle_start as time, open, high, low, close, volume 
                    FROM ohlc.candles_1d
                    WHERE symbol = %s 
                    ORDER BY time ASC
                """
                cur.execute(query, (symbol,))
            else:
                 # Aggregation for W/M/Y using TimescaleDB
                if not interval:
                    # Fallback or error
                    return jsonify({"error": "Invalid timeframe"}), 400

                query = f"""
                    SELECT 
                        time_bucket('{interval}', candle_start) AS time,
                        first(open, candle_start) as open,
                        max(high) as high,
                        min(low) as low,
                        last(close, candle_start) as close,
                        sum(volume) as volume
                    FROM ohlc.candles_1d
                    WHERE symbol = %s
                    GROUP BY time
                    ORDER BY time ASC
                """
                cur.execute(query, (symbol,))
            
            rows = cur.fetchall()
            logger.log("info", "History Query", symbol=symbol, rows=len(rows), timeframe=timeframe)
            
            for row in rows:
                dt = row['time']
                
                # Format time for Lightweight Charts
                if timeframe == '60M':
                     time_val = int(dt.timestamp())
                else:
                     time_val = dt.strftime('%Y-%m-%d')

                data.append({
                    "time": time_val,
                    "open": float(row['open']),
                    "high": float(row['high']),
                    "low": float(row['low']),
                    "close": float(row['close']),
                    "value": float(row['volume'])
                })
                
        return jsonify(data)

    except Exception as e:
        logger.log("error", "History Query Failed", symbol=symbol, error=str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@charts_bp.route('/api/symbols')
def search_symbols():
    query = request.args.get('q', '').upper()
    conn = get_db_connection()
    if not conn:
        return jsonify([]), 500
        
    try:
        with conn.cursor() as cur:
            if query:
                sql = "SELECT trading_symbol FROM ref.symbol WHERE trading_symbol LIKE %s LIMIT 10"
                cur.execute(sql, (f'%{query}%',))
            else:
                sql = "SELECT trading_symbol FROM ref.symbol LIMIT 10" # Default list
                cur.execute(sql)
            
            results = [row[0] for row in cur.fetchall()]
            return jsonify(results)
    except Exception as e:
         logger.log("error", "Symbol Search Failed", error=str(e))
         return jsonify([])
    finally:
        conn.close()
