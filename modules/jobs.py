import os
import datetime
import psycopg2
from flask import Blueprint, jsonify
from psycopg2.extras import RealDictCursor
from db_logger import EnterpriseLogger

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
    """Fetch the latest status of key jobs."""
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "DB Connection failed"}), 500

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Query to get the latest entry for each distinct job_name
            query = """
                SELECT DISTINCT ON (job_name) 
                    id, job_name, start_time, end_time, status, details
                FROM sys.job_history
                ORDER BY job_name, start_time DESC;
            """
            cur.execute(query)
            rows = cur.fetchall()
            
            # Format times
            results = []
            for row in rows:
                results.append({
                    "name": row['job_name'],
                    "status": row['status'],
                    "start": row['start_time'].strftime('%Y-%m-%d %H:%M:%S') if row['start_time'] else None,
                    "end": row['end_time'].strftime('%Y-%m-%d %H:%M:%S') if row['end_time'] else None,
                    "duration": str(row['end_time'] - row['start_time']) if row['end_time'] and row['start_time'] else "Running",
                    "details": row['details']
                })
                
            return jsonify(results)

    except Exception as e:
        logger.log("error", "Job History Query Failed", error=str(e))
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()
