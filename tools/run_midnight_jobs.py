import os
import sys
import time
import datetime
import subprocess
import psycopg2
from dotenv import load_dotenv

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from db_logger import EnterpriseLogger

load_dotenv()
logger = EnterpriseLogger("midnight_runner")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def get_db_connection():
    return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)

def log_job_start(job_name):
    """Inserts a RUNNING record and returns the ID."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO sys.job_history (job_name, status, start_time)
                VALUES (%s, 'RUNNING', NOW())
                RETURNING id;
            """, (job_name,))
            job_id = cur.fetchone()[0]
        conn.commit()
        return job_id
    except Exception as e:
        logger.log("error", f"Failed to log start for {job_name}", error=str(e))
        return None
    finally:
        conn.close()

def log_job_end(job_id, status, details=None):
    """Updates the record with final status and end time."""
    if not job_id:
        return
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE sys.job_history 
                SET status = %s, end_time = NOW(), details = %s
                WHERE id = %s;
            """, (status, details, job_id))
        conn.commit()
    except Exception as e:
        logger.log("error", f"Failed to log end for job {job_id}", error=str(e))
    finally:
        conn.close()

def run_step(script_name, args=[]):
    """Runs a script as a subprocess and logs output."""
    full_job_name = f"{script_name} {' '.join(args)}".strip()
    print(f"🔄 Starting: {full_job_name}")
    
    job_id = log_job_start(full_job_name)
    start_ts = time.time()
    
    try:
        # Construct command: python tools/script.py or python script.py
        # Check if script is in tools/ or root
        if os.path.exists(os.path.join("tools", script_name)):
            cmd = [sys.executable, os.path.join("tools", script_name)] + args
        elif os.path.exists(script_name):
            cmd = [sys.executable, script_name] + args
        else:
            raise FileNotFoundError(f"Script {script_name} not found")

        # Run process
        result = subprocess.run(
            cmd, 
            capture_output=True, 
            text=True, 
            check=True
        )
        
        duration = time.time() - start_ts
        print(f"✅ Finished: {full_job_name} ({duration:.2f}s)")
        log_job_end(job_id, "SUCCESS", f"Output: {result.stdout[:200]}...") # truncate log
        return True

    except subprocess.CalledProcessError as e:
        duration = time.time() - start_ts
        print(f"❌ Failed: {full_job_name} ({duration:.2f}s)")
        print(f"Error Output: {e.stderr}")
        log_job_end(job_id, "FAILURE", f"Error: {e.stderr[:500]}")
        return False
    except Exception as e:
        print(f"🔥 Critical Error: {e}")
        log_job_end(job_id, "FAILURE", str(e))
        return False

def main():
    print("🌙 Midnight Jobs Wrapper Started")
    master_job_id = log_job_start("Midnight Batch")
    
    steps = [
        ("sync_master.py", []),                  # 1. Update Symbols (Master Data)
        ("sync_constituents.py", []),            # 2. Update Index Mappings
        ("data_collector.py", ["day"]),          # 3. Daily OHLC
        ("data_collector.py", ["60minute"])      # 4. Hourly OHLC
    ]
    
    all_success = True
    
    for script, args in steps:
        success = run_step(script, args)
        if not success:
            all_success = False
            # Decide if we want to stop or continue. 
            # For now, let's continue to try getting as much data as possible.
            logger.log("error", f"Step failed: {script} {args}")

    final_status = "SUCCESS" if all_success else "WARNING"
    log_job_end(master_job_id, final_status, "Batch completed")
    print(f"👋 All Jobs Finished. Batch Status: {final_status}")

if __name__ == "__main__":
    main()
