# modules/logs.py
import os
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Blueprint, jsonify, request, send_file, Response

logs_bp = Blueprint('scheduler_logs', __name__)

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"), 
        database=os.getenv("DB_NAME"), 
        user=os.getenv("DB_USER"), 
        password=os.getenv("DB_PASS")
    )

@logs_bp.route('/api/scheduler/history')
def get_job_history():
    """Returns recent job execution history."""
    limit = request.args.get('limit', 50)
    status = request.args.get('status', None)
    
    query = "SELECT id, job_name, start_time, end_time, status, duration_seconds, output_summary FROM sys.job_history"
    params = []
    
    if status:
        query += " WHERE status = %s"
        params.append(status)
        
    query += " ORDER BY start_time DESC LIMIT %s"
    params.append(limit)
    
    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(query, tuple(params))
            history = cur.fetchall()
        conn.close()
        return jsonify(history)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@logs_bp.route('/api/scheduler/logs/<int:history_id>/view')
def view_log_content(history_id):
    """Reads the log file associated with a history entry."""
    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT log_path, output_summary FROM sys.job_history WHERE id = %s", (history_id,))
            row = cur.fetchone()
        conn.close()
        
        if not row:
            return jsonify({"error": "History ID not found"}), 404
            
        log_path = row['log_path']
        if not log_path or not os.path.exists(log_path):
            # Fallback to output summary if file missing
            return jsonify({
                "content": f"Log file not found on disk.\n\nCaptured Summary:\n{row.get('output_summary', 'No summary available.')}",
                "is_partial": True
            })
            
        with open(log_path, 'r') as f:
            content = f.read()
            
        return jsonify({"content": content, "is_partial": False})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@logs_bp.route('/api/scheduler/logs/<int:history_id>/download')
def download_log(history_id):
    """Downloads the raw log file."""
    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT log_path, job_name FROM sys.job_history WHERE id = %s", (history_id,))
            row = cur.fetchone()
        conn.close()

        if row and row[0] and os.path.exists(row[0]):
             return send_file(row[0], as_attachment=True, download_name=f"{row[1]}_{history_id}.log")
        else:
            return "File not found", 404
            
    except Exception as e:
        return str(e), 500

def get_recent_logs():
    data = []
    log_source = "sys.job_history"
    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT start_time, job_name, status, output_summary 
                FROM sys.job_history 
                ORDER BY start_time DESC 
                LIMIT 50
            """)
            rows = cur.fetchall()
        
        conn.close()
        
        for row in rows:
            # Map level
            level = 'INFO'
            status = row.get('status', 'UNKNOWN')
            
            if status == 'FAILURE':
                level = 'ERROR'
            elif status == 'WARNING':
                level = 'WARNING'
            elif status == 'SUCCESS':
                level = 'INFO'
            
            # Timestamp to string
            ts = row['start_time'].isoformat() if row['start_time'] else ""
            
            data.append({
                "timestamp": ts,
                "script": row['job_name'],
                "level": level,
                "event": row['output_summary'] or f"Job {status}"
            })
            
    except Exception as e:
        print(f"Error fetching logs: {e}")
        data.append({
            "timestamp": "",
            "script": "SYSTEM",
            "level": "ERROR",
            "event": f"Failed to fetch logs: {str(e)}"
        })
        
    return data, log_source