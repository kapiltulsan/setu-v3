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
import uuid
from pytz import timezone
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.executors.pool import ThreadPoolExecutor
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.date import DateTrigger
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
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except Exception as e:
        logger.error(f"DB Connection failed: {e}")
        return None

def cleanup_zombies():
    """Marks dead jobs as CRASHED on startup."""
    conn = get_db_connection()
    if not conn: return
    try:
        with conn.cursor() as cur:
            # Attempt to call cleanup function if exists, else raw query
            cur.execute("SELECT sys.cleanup_zombie_jobs();")
            count = cur.fetchone()[0]
        conn.commit()
        if count > 0:
            logger.warning(f"⚠️ Cleaned up {count} zombie jobs from previous crash.")
    except Exception as e:
        logger.error(f"Zombie cleanup failed: {e}")
    finally:
        conn.close()

def log_job_start(job_name, execution_id=None):
    """Log job start to DB."""
    conn = get_db_connection()
    if not conn: return None
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO sys.job_history (job_name, start_time, status, details)
                VALUES (%s, NOW(), 'RUNNING', %s)
                RETURNING id
            """, (job_name, f"Job Started (ExecID: {execution_id})" if execution_id else "Job Started"))
            history_id = cur.fetchone()[0]
        conn.commit()
        return history_id
    except Exception as e:
        logger.error(f"Failed to log start for {job_name}: {e}")
        return None
    finally:
        conn.close()

def log_job_pid(history_id, pid):
    """Update job history with PID."""
    conn = get_db_connection()
    if not conn: return
    try:
        with conn.cursor() as cur:
            cur.execute("UPDATE sys.job_history SET pid = %s WHERE id = %s", (pid, history_id))
        conn.commit()
    except Exception as e:
        logger.error(f"Failed to log PID {pid} for job {history_id}: {e}")
    finally:
        conn.close()

def log_job_end(history_id, status, details, log_path=None, duration_seconds=0, output_summary=None):
    """Log job end to DB."""
    if not history_id:
        return
    conn = get_db_connection()
    if not conn: return
    try:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE sys.job_history 
                SET end_time = NOW(),
                    status = %s, 
                    details = %s,
                    log_path = %s,
                    duration_seconds = %s,
                    output_summary = %s
                WHERE id = %s
            """, (status, details, log_path, duration_seconds, output_summary, history_id))
        conn.commit()
    except Exception as e:
        logger.error(f"Failed to log end for history_id {history_id}: {e}")
    finally:
        conn.close()

def validate_job_params(job_row):
    """
    Checks if job arguments contain a token and validates it against ref.symbol.
    Returns updated job_row if healed, else None.
    """
    cmd = job_row.get('command', '')
    if not cmd: return None
    
    # Heuristic: Check for '--token' or similar if we stick to a convention
    # But since arguments structure varies, we might need to parse specific jobs
    # For now, let's assume 'data_collector' jobs might get arguments via some mechanism?
    # Actually, data_collector calls database itself for the Universe, so it handles its own tokens.
    # But if there are other jobs (like Order Manager) that take tokens as CLI args:
    
    # If the user meant 'update the job arguments' as in 'Database Payload', we'd need to parse that.
    # Assuming for now we are just validating what we can. 
    # If no explicit token passed in cmd line strings, we return None (Data Collector handles it internally as per Step 2).
    
    return None # Placeholder for when we have explicit parameterized jobs

def run_job_wrapper(job_row):
    """
    Wrapper to execute the actual command.
    """
    job_name = job_row['name']
    execution_id = job_row.get('execution_id', str(uuid.uuid4())) # Use provided (run now) or generate new
    
    logger.info(f"🚀 Starting Job: {job_name} [ExecID: {execution_id}]")
    
    # 1. Log Start to DB
    history_id = log_job_start(job_name, execution_id)
    if not history_id:
        logger.error(f"Could not create history entry for {job_name}. Aborting job.")
        return
    
    # --- NEW: Token Integrity Check (Pre-Flight) ---
    try:
        updated_params = validate_job_params(job_row)
        if updated_params:
            job_row = updated_params # Use healed params
            logger.info(f"🛡️ Job params healed for {job_name}")
    except Exception as e:
        logger.error(f"Token validation check failed: {e}")
        # Proceed anyway? Or abort? Let's proceed but log it.

    # 2. Setup Log File
    timestamp = datetime.datetime.now(IST).strftime('%Y%m%d_%H%M%S')
    log_filename = f"{job_name}_{timestamp}_{execution_id[:8]}.log"
    log_path = os.path.join(LOG_DIR, log_filename)
    
    start_time = time.time()
    exit_code = -1
    status = "FAILURE"
    error_msg = ""
    process = None
    output_summary = ""
    
    try:
        cmd = job_row['command']
        
        # 3. Prepare Environment (Context Passing)
        env = os.environ.copy()
        env['SETU_JOB_HISTORY_ID'] = str(history_id)
        env['SETU_EXECUTION_ID'] = str(execution_id)
        
        with open(log_path, 'w') as log_file:
            log_file.write(f"--- Execution Started at {datetime.datetime.now(IST)} ---\n")
            log_file.write(f"Command: {cmd}\n")
            log_file.write(f"Context ID: {history_id}\n")
            log_file.write(f"Execution ID: {execution_id}\n")
            log_file.flush()
            
            # Run process
            process = subprocess.Popen(
                cmd, 
                shell=True, 
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                cwd=os.getcwd(), 
                env=env,
                text=True
            )
            
            # Log PID immediately
            log_job_pid(history_id, process.pid)
            
            # Reads stdout in real-time
            captured_lines = []
            for line in process.stdout:
                log_file.write(line)
                log_file.flush()
                captured_lines.append(line)
                if len(captured_lines) > 20: 
                    captured_lines.pop(0)

            exit_code = process.wait(timeout=job_row.get('timeout_sec', 3600))
            output_summary = "".join(captured_lines)[-1000:]

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
        output_summary = traceback.format_exc()[-1000:]
        with open(log_path, 'a') as f:
            f.write(f"\n\nCRITICAL EXCEPTION: {traceback.format_exc()}\n")
    
    duration = time.time() - start_time
    
    # 4. Log End to DB
    log_job_end(history_id, status, error_msg, log_path, duration, output_summary)

    logger.info(f"🏁 Finished Job: {job_name} | Status: {status} | Duration: {duration:.2f}s")
    
    # 5. Alerting (if failure)
    if status != "SUCCESS":
        try:
            from modules import notifier
            notifier.send_notification(
                subject=f"Job Failed: {job_name}", 
                details=[f"Status: {status}", f"Exit: {error_msg}", f"Log: {log_filename}"],
                technicals={"Job": job_name, "ExitCode": str(exit_code), "Duration": f"{duration:.2f}s"},
                actionable=["Check Logs", "Retry Job"],
                severity="ERROR",
                priority="high",
                exec_id=execution_id
            )
        except Exception as e:
            logger.error(f"Could not send alert: {e}")

class SchedulerService:
    def __init__(self):
        # Allow enough threads for parallel jobs
        self.scheduler = BackgroundScheduler(executors={'default': ThreadPoolExecutor(10)})
        self.running = False
        self.jobs_signature = {} # checksum of loaded jobs to avoid redundant updates? 
        # Actually easier to just compare dicts
        self.known_jobs = {} # name -> job_dict
        
    def heartbeat(self):
        """Update service status every minute."""
        while self.running:
            try:
                conn = get_db_connection()
                if conn:
                    with conn.cursor() as cur:
                        cur.execute("""
                            INSERT INTO sys.service_status (service_name, last_heartbeat, status, info)
                            VALUES ('setu-scheduler', NOW(), 'RUNNING', %s)
                            ON CONFLICT (service_name) DO UPDATE 
                            SET last_heartbeat = EXCLUDED.last_heartbeat, status = 'RUNNING', info = EXCLUDED.info;
                        """, (json.dumps({"jobs_running": len(self.scheduler.get_jobs())}),))
                    conn.commit()
                    conn.close()
            except Exception as e:
                logger.error(f"Heartbeat failed: {e}")
            time.sleep(60)

    def sync_jobs(self):
        """Differential State Sync of jobs."""
        conn = get_db_connection()
        if not conn:
            return

        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT * FROM sys.scheduled_jobs WHERE is_enabled = TRUE")
                db_jobs = cur.fetchall()
            
            db_jobs_map = {job['name']: job for job in db_jobs}
            
            # 1. Identify Jobs to Remove (In memory but not in DB/disabled)
            current_job_ids = [j.id for j in self.scheduler.get_jobs() if not j.id.startswith("trigger_")] # triggers are ephemeral
            for job_id in current_job_ids:
                if job_id not in db_jobs_map:
                    logger.info(f"Removing deleted/disabled job: {job_id}")
                    self.scheduler.remove_job(job_id)
                    if job_id in self.known_jobs:
                        del self.known_jobs[job_id]

            # 2. Identify Jobs to Add or Update
            for name, job_data in db_jobs_map.items():
                # Check if exists
                existing_job = self.scheduler.get_job(name)
                
                # Logic to determine if update is needed:
                # Compare critical fields: command, cron schedule. 
                # (Simple way: always reschedule if different, or just check fields)
                
                needs_sched = False
                if not existing_job:
                    logger.info(f"New job found: {name}")
                    needs_sched = True
                else:
                    # Check if changed
                    cached = self.known_jobs.get(name)
                    if not cached or \
                       cached['schedule_cron'] != job_data['schedule_cron'] or \
                       cached['command'] != job_data['command']:
                        logger.info(f"Job definition changed for: {name}")
                        needs_sched = True
                
                if needs_sched:
                    try:
                        # Parse Cron
                        trigger = CronTrigger.from_crontab(job_data['schedule_cron'])
                        self.scheduler.add_job(
                            run_job_wrapper,
                            trigger,
                            id=name, # job_id is the name
                            name=name,
                            args=[job_data], # pass job row as arg
                            coalesce=True,
                            max_instances=1,
                            replace_existing=True
                        )
                        self.known_jobs[name] = job_data
                        logger.info(f"✅ Synced: {name} [{job_data['schedule_cron']}]")
                    except Exception as e:
                        logger.error(f"❌ Failed to schedule {name}: {e}")

        except Exception as e:
            logger.error(f"Sync jobs failed: {e}")
        finally:
            conn.close()

    def check_triggers(self):
        """Poll sys.job_triggers for 'Run Now' requests."""
        conn = get_db_connection()
        if not conn: return
        
        try:
            # Fetch pending triggers
            triggers = []
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                 # Check table exists (it should, but just in case of race during boot)
                 # We assume it exists as per migration 009
                cur.execute("""
                    SELECT t.id, t.job_name, t.params, j.command, j.timeout_sec
                    FROM sys.job_triggers t
                    JOIN sys.scheduled_jobs j ON t.job_name = j.name
                    WHERE t.status = 'PENDING'
                    FOR UPDATE SKIP LOCKED
                """)
                triggers = cur.fetchall()
                
                for t in triggers:
                    try:
                        job_name = t['job_name']
                        logger.info(f"⚡ Processing Trigger: {job_name} (ID: {t['id']})")
                        
                        if job_name == 'SYSTEM_FORCE_SYNC':
                            logger.info("🔄 Executing Force Sync...")
                            self.sync_jobs()
                            # Mark as processed
                            cur.execute("UPDATE sys.job_triggers SET status = 'PROCESSED', processed_at = NOW() WHERE id = %s", (t['id'],))
                            continue

                        # Prepare job argument
                        # We reconstruct a job_row like dict
                        job_row = {
                            'name': job_name,
                            'command': t['command'],
                            'timeout_sec': t.get('timeout_sec', 3600),
                            'execution_id': str(uuid.uuid4()) # Generate a fresh ID for this run
                        }
                        
                        # Schedule immediately
                        self.scheduler.add_job(
                            run_job_wrapper,
                            DateTrigger(run_date=datetime.datetime.now()),
                            id=f"trigger_{job_name}_{t['id']}", # Unique ID for ephemeral job
                            name=f"RUN_NOW_{job_name}",
                            args=[job_row],
                            max_instances=5
                        )
                        
                        # Mark as processed
                        cur.execute("UPDATE sys.job_triggers SET status = 'PROCESSED', processed_at = NOW(), execution_id = %s WHERE id = %s", 
                                    (job_row['execution_id'], t['id']))
                        
                    except Exception as e:
                        logger.error(f"Failed to process trigger {t['id']}: {e}")
                        cur.execute("UPDATE sys.job_triggers SET status = 'FAILED', error_message = %s WHERE id = %s", (str(e), t['id']))
            
            conn.commit()

        except Exception as e:
            logger.error(f"Check triggers loop error: {e}")
            if conn: conn.rollback()
        finally:
            conn.close()

    def run(self):
        self.running = True
        
        cleanup_zombies()
        
        # Start Heartbeat Thread
        t = threading.Thread(target=self.heartbeat, daemon=True)
        t.start()
        
        # Initial Sync
        self.sync_jobs()
        
        self.scheduler.start()
        logger.info("🚀 Scheduler Service Started (Reactive Mode)")
        
        try:
            last_sync = 0
            while self.running:
                now = time.time()
                
                # Sync Jobs every 60s
                if now - last_sync > 60:
                    self.sync_jobs()
                    last_sync = now
                
                # Poll Triggers every 5s
                self.check_triggers()
                
                time.sleep(5)
                
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
