import os
import sys
import time
import json
import logging
import signal
import datetime
import traceback
import subprocess
import threading
from pytz import timezone
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.executors.pool import ThreadPoolExecutor
from apscheduler.triggers.cron import CronTrigger
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

# --- Configuration ---
load_dotenv()
IST = timezone("Asia/Kolkata")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

LOG_DIR = os.path.join(os.getcwd(), "logs", "scheduler")
os.makedirs(LOG_DIR, exist_ok=True)

# Setup basic logging for the scheduler service
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler(os.path.join(LOG_DIR, "service.log"))
    ]
)
logger = logging.getLogger("setu_scheduler")

def get_db_connection():
    return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)

def log_job_start(job_name):
    """Log job start to DB."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO sys.job_history (job_name, start_time, status, details)
                VALUES (%s, NOW(), 'RUNNING', 'Job Started')
                RETURNING id
            """, (job_name,))
            history_id = cur.fetchone()[0]
        conn.commit()
        return history_id
    except Exception as e:
        logger.error(f"Failed to log start for {job_name}: {e}")
        return None
    finally:
        if conn: conn.close()

def log_job_end(history_id, status, details, log_path=None, duration_seconds=0):
    """Log job end to DB."""
    if not history_id:
        return
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE sys.job_history 
                SET end_time = NOW(),
                    status = %s, 
                    details = %s,
                    log_path = %s,
                    duration_seconds = %s
                WHERE id = %s
            """, (status, details, log_path, duration_seconds, history_id))
        conn.commit()
    except Exception as e:
        logger.error(f"Failed to log end for history_id {history_id}: {e}")
    finally:
        if conn: conn.close()

def run_job_wrapper(job_row):
    """
    Wrapper to execute the actual command.
    Can be called by Scheduler OR API (for Run Now).
    """
    job_name = job_row['name']
    logger.info(f"🚀 Starting Job: {job_name}")
    
    # 1. Log Start to DB
    history_id = log_job_start(job_name)
    if not history_id:
        logger.error(f"Could not create history entry for {job_name}. Aborting job.")
        return
    
    # 2. Setup Log File
    timestamp = datetime.datetime.now(IST).strftime('%Y%m%d_%H%M%S')
    log_filename = f"{job_name}_{timestamp}.log"
    log_path = os.path.join(LOG_DIR, log_filename)
    
    start_time = time.time()
    exit_code = -1
    status = "FAILURE"
    error_msg = ""
    process = None
    
    try:
        cmd = job_row['command']
        
        with open(log_path, 'w') as log_file:
            log_file.write(f"--- Execution Started at {datetime.datetime.now(IST)} ---\n")
            log_file.write(f"Command: {cmd}\n")
            log_file.flush()
            
            # Run process
            process = subprocess.Popen(
                cmd, 
                shell=True, 
                stdout=log_file, 
                stderr=subprocess.STDOUT, # Merge stderr to stdout
                cwd=os.getcwd() # Run from project root
            )
            
            exit_code = process.wait(timeout=job_row.get('timeout_sec', 3600))
            
            log_file.write(f"\n--- Execution Finished at {datetime.datetime.now(IST)} ---\n")
            log_file.write(f"Exit Code: {exit_code}\n")
        
        if exit_code == 0:
            status = "SUCCESS"
            error_msg = "Completed successfully"
        else:
            status = "FAILURE"
            error_msg = f"Exited with code {exit_code}"

    except subprocess.TimeoutExpired:
        status = "TIMEOUT"
        error_msg = "Terminated due to timeout"
        if process:
            process.kill()
        with open(log_path, 'a') as f:
            f.write("\n\n!!! JOB TIMED OUT !!!\n")
            
    except Exception as e:
        status = "FAILURE"
        error_msg = f"Exception: {str(e)}"
        with open(log_path, 'a') as f:
            f.write(f"\n\nCRITICAL EXCEPTION: {traceback.format_exc()}\n")
    
    duration = time.time() - start_time
    
    # 4. Log End to DB
    log_job_end(history_id, status, error_msg, log_path, duration)

    logger.info(f"🏁 Finished Job: {job_name} | Status: {status} | Duration: {duration:.2f}s")
    
    # 5. Alerting (if failure)
    if status != "SUCCESS":
        try:
            from modules import notifier
            notifier.send_notification(
                f"Job Failed: {job_name}", 
                f"Status: {status}\nExit: {error_msg}\nLog: {log_filename}", 
                priority="high"
            )
        except ImportError:
            logger.error("Could not import notifier for alert.")

class SchedulerService:
    def __init__(self):
        self.scheduler = BackgroundScheduler(executors={'default': ThreadPoolExecutor(5)})
        self.running = False
        
    def heartbeat(self):
        """Update service status every minute."""
        while self.running:
            try:
                conn = get_db_connection()
                with conn.cursor() as cur:
                    cur.execute("""
                        INSERT INTO sys.service_status (service_name, last_heartbeat, status, info)
                        VALUES ('setu-scheduler', NOW(), 'RUNNING', %s)
                        ON CONFLICT (service_name) DO UPDATE 
                        SET last_heartbeat = EXCLUDED.last_heartbeat, status = 'RUNNING';
                    """, (json.dumps({"jobs_running": len(self.scheduler.get_jobs())}),))
                conn.commit()
                conn.close()
            except Exception as e:
                logger.error(f"Heartbeat failed: {e}")
            time.sleep(60)

    def load_jobs(self):
        """Fetch jobs from DB and schedule them."""
        logger.info("♻️ Loading jobs from database...")
        conn = get_db_connection()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT * FROM sys.scheduled_jobs WHERE is_enabled = TRUE")
                jobs = cur.fetchall()
            
            # Clear existing jobs to support reload
            self.scheduler.remove_all_jobs()
            
            for job in jobs:
                try:
                    trigger = CronTrigger.from_crontab(job['schedule_cron'])
                    self.scheduler.add_job(
                        run_job_wrapper, # Use the standalone function
                        trigger,
                        id=job['name'],
                        name=job['name'],
                        args=[job],
                        coalesce=True,
                        max_instances=1,
                        replace_existing=True
                    )
                    logger.info(f"✅ Scheduled: {job['name']} [{job['schedule_cron']}]")
                except Exception as e:
                    logger.error(f"❌ Failed to schedule {job['name']}: {e}")
                    
        finally:
            conn.close()

    def run(self):
        self.running = True
        
        # Start Heartbeat Thread
        t = threading.Thread(target=self.heartbeat, daemon=True)
        t.start()
        
        # Initial Load
        self.load_jobs()
        
        # Start Scheduler
        self.scheduler.start()
        logger.info("🚀 Scheduler Service Started")
        
        try:
            while self.running:
                # Reload every 5 mins
                time.sleep(300)
                # self.load_jobs() # Uncomment if desired
        except (KeyboardInterrupt, SystemExit):
            self.stop()
            
    def stop(self):
        logger.info("🛑 Stopping Scheduler Service...")
        self.running = False
        self.scheduler.shutdown()

if __name__ == "__main__":
    service = SchedulerService()
    
    def signal_handler(sig, frame):
        service.stop()
        sys.exit(0)
    
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    service.run()
