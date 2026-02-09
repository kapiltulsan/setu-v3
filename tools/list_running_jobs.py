import sys
import os
import datetime

# Add root dir to path
sys.path.append(os.getcwd())

from modules.scheduler.service import get_db_connection
from psycopg2.extras import RealDictCursor

def list_jobs_info():
    conn = get_db_connection()
    if not conn:
        print("Failed to connect to DB")
        return

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            print("\n--- Scheduled Jobs ---")
            cur.execute("SELECT name, schedule_cron, is_enabled FROM sys.scheduled_jobs")
            rows = cur.fetchall()
            for row in rows:
                print(f"{row['name']:<30} | {row['schedule_cron']:<15} | Enabled: {row['is_enabled']}")

            print("\n--- Recent Job History (Last 10) ---")
            cur.execute("""
                SELECT id, job_name, pid, start_time, end_time, status 
                FROM sys.job_history 
                ORDER BY id DESC LIMIT 10
            """)
            rows = cur.fetchall()
            
            print(f"{'ID':<5} | {'Job Name':<30} | {'PID':<10} | {'Status':<10} | {'Start Time'}")
            print("-" * 80)
            for row in rows:
                print(f"{row['id']:<5} | {row['job_name']:<30} | {row['pid']:<10} | {row['status']:<10} | {row['start_time']}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    list_jobs_info()
