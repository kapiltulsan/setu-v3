import os
import datetime
import psycopg2
import sys
import subprocess
import json
from flask import Blueprint, jsonify, request
from psycopg2.extras import RealDictCursor
from db_logger import EnterpriseLogger
try:
    from croniter import croniter
except ImportError:
    croniter = None

jobs_bp = Blueprint('jobs', __name__)
logger = EnterpriseLogger("mod_jobs")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def get_db_connection():
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except Exception as e:
        logger.log("error", "DB Connection Failed", error=str(e))
        return None

@jobs_bp.route('/api/jobs/latest')
def get_latest_jobs():
    """Fetch the latest status of key jobs and their schedules."""
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "DB Connection failed"}), 500

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get configured jobs
            cur.execute("SELECT * FROM sys.scheduled_jobs ORDER BY name")
            jobs_config = {row['name']: row for row in cur.fetchall()}
            
            # Get latest execution history
            query = """
                SELECT DISTINCT ON (job_name) 
                    id, job_name, start_time, end_time, status, details, pid
                FROM sys.job_history
                ORDER BY job_name, start_time DESC;
            """
            cur.execute(query)
            history_rows = cur.fetchall()
            
            results = []
            
            # Merge config and history
            for name, config in jobs_config.items():
                history = next((h for h in history_rows if h['job_name'] == name), None)
                
                job_data = {
                    "name": name,
                    "schedule": config['schedule_cron'],
                    "command": config['command'],
                    "description": config['description'],
                    "is_enabled": config['is_enabled'],
                    "status": "UNKNOWN",
                    "last_run": None,
                    "duration": None,
                    "details": "",
                    "pid": None
                }
                
                if history:
                    job_data["status"] = history['status']
                    job_data["pid"] = history['pid']
                    job_data["last_run"] = history['start_time'].strftime('%Y-%m-%d %H:%M:%S') if history['start_time'] else None
                    if history['end_time'] and history['start_time']:
                        duration = history['end_time'] - history['start_time']
                        job_data["duration"] = str(duration).split('.')[0] # Remove microseconds
                    elif history['status'] == "RUNNING":
                         job_data["duration"] = "Running..."
                    
                    job_data["details"] = history['details']
                
                results.append(job_data)
                
            return jsonify(results)

    except Exception as e:
        logger.log("error", "Job History Query Failed", error=str(e))
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@jobs_bp.route('/api/jobs/manage', methods=['POST'])
def manage_job():
    """Dynamic CRUD for Jobs."""
    data = request.json
    action = data.get('action') # add, update, delete
    name = data.get('name')
    
    if not action or not name:
        return jsonify({"status": "error", "message": "Missing action or name"}), 400
        
    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB Connection Failed"}), 500
        
    try:
        with conn.cursor() as cur:
            if action == 'delete':
                cur.execute("DELETE FROM sys.scheduled_jobs WHERE name = %s", (name,))
                if cur.rowcount == 0:
                    return jsonify({"status": "error", "message": "Job not found"}), 404
                msg = f"Job {name} deleted"
                
            elif action in ['add', 'update']:
                cron_expr = data.get('schedule_cron')
                command = data.get('command')
                desc = data.get('description', '')
                is_enabled = data.get('is_enabled', True)
                
                if not cron_expr or not command:
                    return jsonify({"status": "error", "message": "Missing cron or command"}), 400
                    
                # Validate Cron
                if croniter and not croniter.is_valid(cron_expr):
                     return jsonify({"status": "error", "message": "Invalid Cron Expression"}), 400

                if action == 'add':
                    cur.execute("""
                        INSERT INTO sys.scheduled_jobs (name, schedule_cron, command, description, is_enabled)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (name, cron_expr, command, desc, is_enabled))
                    msg = f"Job {name} added"
                else:
                    cur.execute("""
                        UPDATE sys.scheduled_jobs 
                        SET schedule_cron = %s, command = %s, description = %s, is_enabled = %s, updated_at = NOW()
                        WHERE name = %s
                    """, (cron_expr, command, desc, is_enabled, name))
                    msg = f"Job {name} updated"
            
            else:
                return jsonify({"status": "error", "message": "Invalid action"}), 400
                
            conn.commit()
            logger.log("info", f"Job Managed: {action} {name}")
            return jsonify({"status": "success", "message": msg})
            
    except psycopg2.IntegrityError:
        conn.rollback()
        return jsonify({"status": "error", "message": f"Job {name} already exists"}), 409
    except Exception as e:
        conn.rollback()
        logger.log("error", f"Job Manage Failed: {e}", error=str(e))
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        conn.close()

@jobs_bp.route('/api/jobs/trigger', methods=['POST'])
def trigger_job():
    """Trigger a job execution immediately."""
    data = request.json
    job_name = data.get('job_name')
    
    if not job_name:
        return jsonify({"status": "error", "message": "Missing job_name"}), 400
        
    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB Connection Failed"}), 500

    try:
        with conn.cursor() as cur:
            # Check if job exists
            cur.execute("SELECT 1 FROM sys.scheduled_jobs WHERE name = %s", (job_name,))
            if not cur.fetchone():
                return jsonify({"status": "error", "message": "Job not found"}), 404
            
            # Insert Trigger
            cur.execute("""
                INSERT INTO sys.job_triggers (job_name, triggered_by, status)
                VALUES (%s, 'admin_ui', 'PENDING')
                RETURNING id
            """, (job_name,))
            trigger_id = cur.fetchone()[0]
            conn.commit()
            
            logger.log("info", f"Job Triggered: {job_name} (ID: {trigger_id})")
            return jsonify({"status": "success", "message": "Job queued for execution"}), 200
            
    except Exception as e:
        logger.log("error", f"Job Trigger Failed: {e}", error=str(e))
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        conn.close()
