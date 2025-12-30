import os
import threading
import subprocess
import json
from flask import Blueprint, jsonify, request, render_template
from psycopg2.extras import RealDictCursor
from modules.scheduler.service import get_db_connection

scheduler_bp = Blueprint('scheduler_bp', __name__)

@scheduler_bp.route('/admin/scheduler')
@scheduler_bp.route('/admin/observability')
def observability_dashboard():
    """Serve the New Observability Dashboard."""
    return render_template('observability.html')

# --- System Health ---
@scheduler_bp.route('/api/system/status')
def get_system_status():
    """Get the heartbeat status of all services."""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM sys.service_status ORDER BY service_name")
            rows = cur.fetchall()
            
            # Add calculated status
            results = []
            for row in rows:
                last_heartbeat = row['last_heartbeat']
                status = "OFFLINE"
                if last_heartbeat:
                    # Calculate seconds ago
                    import datetime
                    # Ensure timezone awareness handling
                    now = datetime.datetime.now(last_heartbeat.tzinfo)
                    diff = (now - last_heartbeat).total_seconds()
                    
                    if diff < 70: # 60s + buffer
                        status = "ONLINE"
                    elif diff < 180:
                        status = "LAGGING"
                    else:
                        status = "OFFLINE"
                
                results.append({
                    "service": row['service_name'],
                    "status": status,
                    "last_beat": last_heartbeat.isoformat() if last_heartbeat else None,
                    "info": row['info']
                })
                
        return jsonify(results)
    except Exception as e:
         return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

# --- System Control ---
@scheduler_bp.route('/api/system/action', methods=['POST'])
def system_action():
    """Perform system actions: refresh, restart."""
    data = request.json
    action = data.get('action')
    service = data.get('service')
    
    conn = get_db_connection()
    try:
        if action == 'refresh':
            # Trigger Global Refresh (Force Sync)
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO sys.job_triggers (job_name, triggered_by, status)
                    VALUES ('SYSTEM_FORCE_SYNC', 'admin_ui', 'PENDING')
                """)
            conn.commit()
            return jsonify({"status": "success", "message": "Global Refresh Triggered"})
            
        elif action == 'restart':
            if not service:
                return jsonify({"error": "Service name required"}), 400
            
            # Restart via systemctl (Requires privileges setup)
            # Assuming 'sudo' is allowed without password for 'systemctl restart setu-*'
            # Or we utilize a specific tool script.
            # Using basic subprocess for now.
            cmd = f"sudo systemctl restart {service}"
            
            # Safety check
            allowed_services = ['setu-scheduler', 'setu-web', 'setu-notifier', 'nginx']
            if service not in allowed_services:
                 return jsonify({"error": "Service restart not allowed"}), 403

            subprocess.Popen(cmd.split())
            return jsonify({"status": "success", "message": f"Restart signal sent for {service}"})
            
        else:
            return jsonify({"error": "Invalid action"}), 400
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

# Keep jobs API for legacy or if needed, but remove conflicting Logs API
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
                    h.pid as last_pid,
                    EXTRACT(EPOCH FROM (h.end_time - h.start_time)) as last_duration
                FROM sys.scheduled_jobs j
                LEFT JOIN LATERAL (
                    SELECT status, start_time, end_time, pid
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
