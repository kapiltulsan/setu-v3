
import os
import sys
import psycopg2
import json
import traceback
from flask import Blueprint, jsonify, request
from psycopg2.extras import RealDictCursor
import pandas as pd
import numpy as np
from datetime import datetime

scanners_bp = Blueprint('scanners', __name__)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")
def get_db_connection():
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except Exception as e:
        print(f"DB Connection Failed: {e}", file=sys.stderr)
        return None

def get_indices_list():
    """Returns a simple list of active index names."""
    conn = get_db_connection()
    if not conn: return []
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT index_name FROM ref.index_source WHERE is_active = TRUE ORDER BY index_name")
            return [row[0] for row in cur.fetchall()]
    except:
        return []
    finally:
        conn.close()

# --- CRUD Endpoints ---

@scanners_bp.route('/api/indices', methods=['GET'])
def get_indices():
    """List available indices for Universe selection."""
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "DB Connection Failed"}), 500
    
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT index_name FROM ref.index_source WHERE is_active = TRUE ORDER BY index_name")
            # Return simple list of strings
            indices = [row[0] for row in cur.fetchall()]
            return jsonify(indices)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/universe/count', methods=['POST'])
def get_universe_count():
    """Calculate unique symbols for a given universe config."""
    from modules.scanner_engine import fetch_universe_symbols
    try:
        data = request.json
        universe_config = data.get('universe', [])
        universe_filters = data.get('universe_filters', [])
        symbols, index_count = fetch_universe_symbols(universe_config, universe_filters)
        return jsonify({
            "count": len(symbols),
            "index_count": index_count
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@scanners_bp.route('/api/scanners', methods=['GET'])
def get_scanners():
    """List all scanners."""
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "DB Connection Failed"}), 500
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get scanners with last run info
            query = """
                SELECT 
                    s.id, s.name, s.description, s.source_universe, s.schedule_cron, s.is_active, s.last_run_at, 
                    (SELECT COUNT(*) FROM trading.scanner_results r WHERE r.scanner_id = s.id AND r.run_date = s.last_run_at) as last_match_count
                FROM sys.scanners s
                ORDER BY s.id;
            """
            cur.execute(query)
            scanners = cur.fetchall()
            return jsonify(scanners)
    except Exception as e:
        print(f"Error listing scanners: {e}", file=sys.stderr)
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/scanners', methods=['POST'])
def create_scanner():
    """Create a new scanner."""
    data = request.json
    name = data.get('name')
    source = data.get('source_universe')
    logic = data.get('logic_config')
    schedule = data.get('schedule_cron')
    
    if not name or not source or not logic:
        return jsonify({"error": "Missing required fields (name, source_universe, logic_config)"}), 400
        
    conn = get_db_connection()
    if not conn: return jsonify({"error": "DB Failed"}), 500
    
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO sys.scanners (name, description, source_universe, logic_config, schedule_cron)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING id;
            """, (name, data.get('description', ''), source, json.dumps(logic), schedule))
            new_id = cur.fetchone()[0]
            conn.commit()
            return jsonify({"status": "success", "id": new_id, "message": "Scanner created"}), 201
            
    except psycopg2.IntegrityError:
        conn.rollback()
        return jsonify({"error": "Scanner with this name already exists"}), 409
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/scanners/<int:scanner_id>', methods=['GET'])
def get_scanner_details(scanner_id):
    """Get scanner details and history."""
    conn = get_db_connection()
    if not conn: return jsonify({"error": "DB Failed"}), 500
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # 1. Config
            cur.execute("SELECT * FROM sys.scanners WHERE id = %s", (scanner_id,))
            scanner = cur.fetchone()
            if not scanner:
                return jsonify({"error": "Scanner not found"}), 404
            
            # 2. Results History (Summary of last 10 runs)
            cur.execute("""
                SELECT run_date, COUNT(*) as matches 
                FROM trading.scanner_results 
                WHERE scanner_id = %s 
                GROUP BY run_date 
                ORDER BY run_date DESC 
                LIMIT 10
            """, (scanner_id,))
            history = cur.fetchall()
            
            # 3. Latest Result Details
            latest_results = []
            if scanner['last_run_at']:
                cur.execute("""
                    SELECT symbol, match_data 
                    FROM trading.scanner_results 
                    WHERE scanner_id = %s AND run_date = %s
                """, (scanner_id, scanner['last_run_at']))
                latest_results = cur.fetchall()
                
            return jsonify({
                "config": scanner,
                "history": history,
                "latest_results": latest_results
            })
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/scanners/<int:scanner_id>', methods=['PUT'])
def update_scanner(scanner_id):
    """Update an existing scanner."""
    data = request.json
    name = data.get('name')
    source = data.get('source_universe')
    logic = data.get('logic_config')
    schedule = data.get('schedule_cron')
    
    if not name or not source or not logic:
        return jsonify({"error": "Missing required fields"}), 400
        
    conn = get_db_connection()
    if not conn: return jsonify({"error": "DB Failed"}), 500
    
    try:
        with conn.cursor() as cur:
            # Check if exists
            cur.execute("SELECT id FROM sys.scanners WHERE id = %s", (scanner_id,))
            if not cur.fetchone():
                return jsonify({"error": "Scanner not found"}), 404

            cur.execute("""
                UPDATE sys.scanners 
                SET name = %s, description = %s, source_universe = %s, logic_config = %s, schedule_cron = %s, updated_at = NOW()
                WHERE id = %s
            """, (name, data.get('description', ''), source, json.dumps(logic), schedule, scanner_id))
            
            conn.commit()
            return jsonify({"status": "success", "message": "Scanner updated successfully"}), 200
            
    except psycopg2.IntegrityError:
        conn.rollback()
        return jsonify({"error": "Scanner with this name already exists"}), 409
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/scanners/<int:scanner_id>', methods=['DELETE'])
def delete_scanner(scanner_id):
    """Delete a scanner."""
    conn = get_db_connection()
    if not conn: return jsonify({"error": "DB Failed"}), 500
    
    try:
        with conn.cursor() as cur:
            # Check if exists
            cur.execute("SELECT id FROM sys.scanners WHERE id = %s", (scanner_id,))
            if not cur.fetchone():
                return jsonify({"error": "Scanner not found"}), 404
            
            # Delete results first
            cur.execute("DELETE FROM trading.scanner_results WHERE scanner_id = %s", (scanner_id,))
            
            # Delete scanner
            cur.execute("DELETE FROM sys.scanners WHERE id = %s", (scanner_id,))
            conn.commit()
            
            return jsonify({"status": "success", "message": "Scanner deleted successfully"}), 200
            
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/scanners/preview', methods=['POST'])
def preview_scanner():
    """Run a dry run of the scanner logic and return matches."""
    from modules.scanner_engine import execute_scan_logic
    try:
        data = request.json
        logic_config = data.get('logic_config', {})
        
        # Run logic (limit to 50 for performance)
        result = execute_scan_logic(logic_config, limit_results=50)
        matches = result.get("matches", [])
        stats = result.get("stats", {})
        
        return jsonify({
            "count": len(matches),
            "matches": matches,
            "stats": stats
        })
    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500

@scanners_bp.route('/api/scanners/<int:scanner_id>/run', methods=['POST'])
def run_scanner(scanner_id):
    """Manual Trigger to Run Scanner."""
    from modules.scanner_engine import run_scanner_engine
    
    # We run this synchronously for now for immediate feedback, 
    # but in production this should be a background job (Celery/RQ)
    try:
        success = run_scanner_engine(scanner_id)
        
        if success:
            return jsonify({"status": "success", "message": "Scanner executed successfully. Check results."})
        else:
            return jsonify({"status": "error", "message": "Scanner execution failed or no matches found."}), 500

    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500

@scanners_bp.route('/api/sectors/status', methods=['GET'])
def get_sectors_status():
    """
    Calculates real-time metrics for all indices to power the Sector Radar.
    Returns: List of sector status cards with squeeze, momentum, and trend data.
    """
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "DB Connection Failed"}), 500
    
    try:
        with conn.cursor() as cur:
            # 1. Fetch active indices
            cur.execute("SELECT index_name FROM ref.index_source WHERE is_active = TRUE ORDER BY index_name")
            indices = [row[0] for row in cur.fetchall()]
            
        results = []
        for index_name in indices:
            try:
                # 2. Fetch daily OHLC (last 50 days to have enough for SMA 20 + BB 20)
                query = """
                    SELECT candle_start as date, open, high, low, close, volume 
                    FROM ohlc.candles_1d 
                    WHERE symbol = %s 
                    ORDER BY candle_start DESC 
                    LIMIT 50
                """
                df = pd.read_sql(query, conn, params=(index_name,), parse_dates=['date'])
                if df.empty or len(df) < 21:
                    continue
                
                # Sort ascending for calculation
                df = df.sort_values('date').reset_index(drop=True)
                
                # 3. Calculate Indicators
                # SMA 20
                df['SMA_20'] = df['close'].rolling(window=20).mean()
                
                # Bollinger Bands (20, 2)
                std = df['close'].rolling(window=20).std()
                df['UBB'] = df['SMA_20'] + (2 * std)
                df['LBB'] = df['SMA_20'] - (2 * std)
                df['BB_Width'] = (df['UBB'] - df['LBB']) / df['SMA_20']
                
                # Squeeze Logic
                # Current BBW is the lowest of the last 20 periods AND < 0.12
                df['Min_BBW_20'] = df['BB_Width'].rolling(window=20).min()
                last_bbw = df['BB_Width'].iloc[-1]
                min_bbw = df['Min_BBW_20'].iloc[-1]
                is_squeezing = bool((last_bbw == min_bbw) and (last_bbw < 0.12))
                
                # 4. Momentum & Trend
                last_close = float(df['close'].iloc[-1])
                prev_close = float(df['close'].iloc[-2])
                sma_20 = float(df['SMA_20'].iloc[-1])
                
                change_pct = ((last_close - prev_close) / prev_close) * 100
                momentum = "BULLISH" if last_close > sma_20 else "BEARISH"
                
                # Sparkline (last 20 periods)
                sparkline = df['close'].tail(20).tolist()
                
                results.append({
                    "name": index_name,
                    "price": last_close,
                    "change": change_pct,
                    "isSqueezing": is_squeezing,
                    "momentum": momentum,
                    "trend": "UP" if change_pct > 0 else "DOWN",
                    "sparkline": sparkline
                })
            except Exception as e:
                print(f"Error processing index {index_name}: {e}")
                continue
                
        return jsonify(results)
        
    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@scanners_bp.route('/api/sectors/visualize', methods=['POST'])
def get_sector_visualize_data():
    """
    Returns full historical technical data for an index to power the Sector Visualizer.
    """
    try:
        data = request.json
        symbol = data.get('symbol')
        years = int(data.get('years', 2))
        data_limit = years * 252 + 100
        
        if not symbol:
            return jsonify({"error": "Symbol is required"}), 400
            
        from modules.scanner_engine import fetch_data_for_symbol, resample_data
        
        # 1. Fetch Daily Data
        df_daily = fetch_data_for_symbol(symbol, limit=data_limit)
        if df_daily is None or df_daily.empty:
            return jsonify({"error": "Data not found"}), 404
            
        # 2. Resample to Weekly (The visualizer uses weekly by default for this strategy)
        df_weekly = resample_data(df_daily, timeframe='week')
        df_weekly = df_weekly.rename(columns={
            'open': 'Open', 'high': 'High', 'low': 'Low', 'close': 'Close', 'volume': 'Volume'
        })
        df_weekly['Date'] = df_weekly.index.strftime('%Y-%m-%d')
        df_weekly = df_weekly.reset_index(drop=True)
        
        # 3. Calculate Indicators (Reusing VolatilitySqueezeBacktester logic)
        from modules.backtesting.volatility_squeeze import VolatilitySqueezeBacktester
        
        # We need to ensure 'Date' is datetime for the backtester
        df_calc = df_weekly.copy()
        df_calc['Date'] = pd.to_datetime(df_calc['Date'])
        
        engine = VolatilitySqueezeBacktester(df_calc)
        # We don't necessarily need to run_backtest() if we just want indicators, 
        # but the indicators are calculated in __init__
        
        # Return the entire dataframe with indicators
        # FinancialChart expects keys like UBB, LBB, etc.
        result_df = engine.df.replace({np.nan: None})
        
        # Convert Timestamp to string for JSON
        result_df['Date'] = result_df['Date'].dt.strftime('%Y-%m-%d')
        
        return jsonify({
            "status": "success",
            "plot_data": result_df.to_dict(orient='records')
        })
        
    except Exception as e:
        print(traceback.format_exc())
        return jsonify({"error": str(e)}), 500
