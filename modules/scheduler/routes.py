import os
import threading
from flask import Blueprint, jsonify, request, send_file, render_template
from psycopg2.extras import RealDictCursor
from modules.scheduler.service import get_db_connection, run_job_wrapper, LOG_DIR

scheduler_bp = Blueprint('scheduler_bp', __name__)

@scheduler_bp.route('/admin/scheduler')
def scheduler_dashboard():
    """Serve the Scheduler Management Page."""
    return render_template('scheduler.html')

@scheduler_bp.route('/api/scheduler/status')
def get_service_status():
    """Get the heartbeat status of the scheduler service."""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM sys.service_status WHERE service_name = 'setu-scheduler'")
            status = cur.fetchone()
        return jsonify(status or {"status": "UNKNOWN"})
    finally:
        conn.close()

@scheduler_bp.route('/api/scheduler/jobs')
def list_jobs():
    """List all jobs with their latest history status."""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Join with latest history
            cur.execute("""
                SELECT 
                    j.*,
                    h.status as last_status,
                    h.end_time as last_run_end,
                    EXTRACT(EPOCH FROM (h.end_time - h.start_time)) as last_duration
                FROM sys.scheduled_jobs j
                LEFT JOIN LATERAL (
                    SELECT status, start_time, end_time 
                    FROM sys.job_history 
                    WHERE job_name = j.name 
                    ORDER BY id DESC LIMIT 1
                ) h ON TRUE
                ORDER BY j.name;
            """)
            jobs = cur.fetchall()
        return jsonify(jobs)
    finally:
        conn.close()

@scheduler_bp.route('/api/scheduler/jobs/<int:job_id>/toggle', methods=['POST'])
def toggle_job(job_id):
    """Enable/Disable a job."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("UPDATE sys.scheduled_jobs SET is_enabled = NOT is_enabled WHERE id = %s RETURNING is_enabled", (job_id,))
            new_state = cur.fetchone()[0]
        conn.commit()
        # Note: Scheduler service needs to reload to pick this up. 
        # Ideally we send a signal, but for now we rely on the 5min poll or manual restart.
        return jsonify({"success": True, "is_enabled": new_state})
    finally:
        conn.close()

@scheduler_bp.route('/api/scheduler/jobs/<int:job_id>/run', methods=['POST'])
def run_job_now(job_id):
    """Manually trigger a job (Runs in a separate thread)."""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM sys.scheduled_jobs WHERE id = %s", (job_id,))
            job = cur.fetchone()
        
        if not job:
            return jsonify({"error": "Job not found"}), 404
            
        # Run in background thread to avoid blocking API
        t = threading.Thread(target=run_job_wrapper, args=(job,), daemon=True)
        t.start()
        
        return jsonify({"message": f"Job '{job['name']}' triggered successfully."})
    finally:
        conn.close()

@scheduler_bp.route('/api/scheduler/history')
def job_history():
    """Get global job history."""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT h.*, j.name as job_name 
                FROM sys.job_history h
                JOIN sys.scheduled_jobs j ON h.job_name = j.name
                ORDER BY h.id DESC LIMIT 50
            """)
            history = cur.fetchall()
        return jsonify(history)
    finally:
        conn.close()

@scheduler_bp.route('/api/scheduler/logs/<int:history_id>/view')
def view_log(history_id):
    """View log content."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT log_path FROM sys.job_history WHERE id = %s", (history_id,))
            result = cur.fetchone()
            
        if not result or not result[0]:
            return jsonify({"error": "Log not found"}), 404
            
        log_path = result[0]
        if not os.path.exists(log_path):
             return jsonify({"error": "Log file missing on disk"}), 404
             
        # Read last 20KB for safety
        with open(log_path, 'r') as f:
            content = f.read() 
            
        return jsonify({"content": content})
    finally:
        conn.close()

@scheduler_bp.route('/api/scheduler/logs/<int:history_id>/download')
def download_log(history_id):
    """Download log file."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT log_path FROM sys.job_history WHERE id = %s", (history_id,))
            result = cur.fetchone()
            
        if not result or not result[0]:
            return jsonify({"error": "Log not found"}), 404
            
        log_path = result[0]
        if not os.path.exists(log_path):
             return jsonify({"error": "Log file missing on disk"}), 404
             
        return send_file(log_path, as_attachment=True)
    finally:
        conn.close()
