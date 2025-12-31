
import os
import sys
import psycopg2
import json
import traceback
from flask import Blueprint, jsonify, request
from psycopg2.extras import RealDictCursor
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

# --- CRUD Endpoints ---

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
