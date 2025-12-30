import os
import json
import socket
import logging
import traceback
import sys
import time
import psycopg2
from datetime import datetime
from pytz import timezone
from psycopg2.extras import RealDictCursor
from flask import Blueprint, jsonify, request, send_file, Response, stream_with_context

# --- Configuration ---
IST = timezone("Asia/Kolkata")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

logs_bp = Blueprint('scheduler_logs', __name__)

def get_db_connection():
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except:
        return None

# --- EnterpriseLogger Class ---
class EnterpriseLogger:
    def __init__(self, name):
        self.name = name
        self.host = socket.gethostname()
        self.exec_id = os.getenv("SETU_EXECUTION_ID") # Injected by Scheduler
        
        # Configure Internal Logger to write to STDOUT (captured by Scheduler)
        self._logger = logging.getLogger(name)
        self._logger.setLevel(logging.INFO)
        if not self._logger.handlers:
            handler = logging.StreamHandler(sys.stdout)
            self._logger.addHandler(handler)

    def _format_message(self, level, msg, **kwargs):
        """Formats the log message as structured JSON."""
        entry = {
            "ts": datetime.now(IST).isoformat(),
            "lvl": level,
            "exec_id": self.exec_id,
            "mod": self.name,
            "msg": msg
        }
        if kwargs:
            entry.update(kwargs)
        return json.dumps(entry)

    def log(self, level, msg, **kwargs):
        json_msg = self._format_message(level, msg, **kwargs)
        print(json_msg, flush=True) 

    def info(self, msg, **kwargs):
        self.log("INFO", msg, **kwargs)

    def error(self, msg, **kwargs):
        self.log("ERROR", msg, **kwargs)
        
    def warning(self, msg, **kwargs):
        self.log("WARNING", msg, **kwargs)

# --- API Endpoints ---

@logs_bp.route('/api/scheduler/history')
def get_job_history():
    """Returns recent job execution history."""
    limit = request.args.get('limit', 50)
    status = request.args.get('status', None)
    job_name = request.args.get('job_name', None)
    
    query = "SELECT id, job_name, start_time, end_time, status, duration_seconds, output_summary FROM sys.job_history"
    params = []
    conditions = []
    
    if status:
        conditions.append("status = %s")
        params.append(status)
        
    if job_name:
        conditions.append("job_name = %s")
        params.append(job_name)
    
    if conditions:
        query += " WHERE " + " AND ".join(conditions)
        
    query += " ORDER BY start_time DESC LIMIT %s"
    params.append(limit)
    
    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(query, tuple(params))
            history = cur.fetchall()
        conn.close()

        # Explicitly format dates to ISO strings
        for row in history:
            if row.get('start_time'):
                row['start_time'] = row['start_time'].isoformat()
            if row.get('end_time'):
                row['end_time'] = row['end_time'].isoformat()
                
        return jsonify(history)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@logs_bp.route('/api/scheduler/logs/<int:history_id>/tail')
def tail_log_content(history_id):
    """
    Efficiently tails the log file using file.seek().
    Reads the last 50KB.
    """
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
             return jsonify({
                "content": f"[Log file missing]. Summary:\n{row.get('output_summary', 'N/A')}",
                "is_partial": True
            })

        # Efficient Seek
        file_size = os.path.getsize(log_path)
        read_size = 50 * 1024 # 50KB
        
        with open(log_path, 'r', encoding='utf-8', errors='replace') as f:
            if file_size > read_size:
                f.seek(file_size - read_size)
                content = f.read()
                # Determine if we cut a line in half
                first_newline = content.find('\n')
                if first_newline != -1:
                    content = content[first_newline+1:]
                content = f"[...Tailing last 50KB of {file_size/1024:.1f}KB...]\n" + content
            else:
                content = f.read()
            
        return jsonify({"content": content, "size": file_size})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@logs_bp.route('/api/scheduler/logs/<int:history_id>/stream')
def stream_log(history_id):
    """
    SSE Stream for real-time logs.
    """
    def generate():
        conn = get_db_connection()
        log_path = None
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT log_path FROM sys.job_history WHERE id = %s", (history_id,))
                res = cur.fetchone()
                if res: log_path = res[0]
        finally:
            conn.close()

        if not log_path or not os.path.exists(log_path):
             yield "data: [Log file not found or waiting to start...]\n\n"
             return

        # Tailing logic
        with open(log_path, 'r') as f:
            while True:
                line = f.readline()
                if line:
                    yield f"data: {line.strip()}\n\n"
                else:
                    time.sleep(0.5)

    return Response(stream_with_context(generate()), mimetype='text/event-stream')

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

# --- Legacy Helper for Dashboard ---
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
        # print(f"Error fetching logs: {e}")
        data.append({
            "timestamp": "",
            "script": "SYSTEM",
            "level": "ERROR",
            "event": f"Failed to fetch logs: {str(e)}"
        })
        
    return data, log_source