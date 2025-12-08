import os
import logging
import socket
import datetime
from pythonjsonlogger import jsonlogger
import psycopg2
from dotenv import load_dotenv

# Load config
load_dotenv()
LOG_BASE_PATH = os.getenv("LOG_BASE_PATH", "logs") # Default to 'logs' folder if missing
APP_NAME = os.getenv("APP_NAME", "SetuV3")
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

class EnterpriseLogger:
    def __init__(self, job_name="default_job"):
        self.job_name = job_name
        self.hostname = socket.gethostname()
        self.job_run_id = None # Will be set when start_job() is called
        
        # 1. Setup File Logging (JSON)
        self.logger = logging.getLogger(job_name)
        self.logger.setLevel(logging.DEBUG)
        self.logger.handlers = [] # Clear existing handlers

        # Dynamic Path: Logs/SetuV3/Python/YYYY-MM-DD/
        today_str = datetime.datetime.now().strftime("%Y-%m-%d")
        log_dir = os.path.join(LOG_BASE_PATH, APP_NAME, "Python", today_str)
        os.makedirs(log_dir, exist_ok=True)
        
        log_file = os.path.join(log_dir, f"{job_name}.json")
        
        # File Handler
        fh = logging.FileHandler(log_file)
        formatter = jsonlogger.JsonFormatter(
            '%(timestamp)s %(level)s %(name)s %(message)s %(funcName)s %(lineno)d',
            timestamp=True
        )
        fh.setFormatter(formatter)
        self.logger.addHandler(fh)
        
        # Console Handler (Optional: so you see errors in VS Code)
        ch = logging.StreamHandler()
        ch.setFormatter(formatter)
        self.logger.addHandler(ch)

    def log(self, level, message, **kwargs):
        """
        Wrapper to log with extra context (Host, JobID, etc.)
        Usage: logger.log("info", "Connected to DB", rows=50)
        """
        extra = {
            'host': self.hostname,
            'job_id': self.job_run_id
        }
        extra.update(kwargs) # Add any custom fields passed by the user
        
        if level.lower() == 'info':
            self.logger.info(message, extra=extra)
        elif level.lower() == 'error':
            self.logger.error(message, extra=extra, exc_info=True) # exc_info captures stack trace automatically
        elif level.lower() == 'warning':
            self.logger.warning(message, extra=extra)

    def start_job(self):
        """Inserts 'RUNNING' status into DB audit table"""
        try:
            conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
            cur = conn.cursor()
            query = """
                INSERT INTO audit.job_run (env_name, job_name, status)
                VALUES ('dev', %s, 'RUNNING') RETURNING job_run_id;
            """
            cur.execute(query, (self.job_name,))
            self.job_run_id = cur.fetchone()[0]
            conn.commit()
            cur.close()
            conn.close()
            self.log("info", "Job Started - Audit Row Created")
            return self.job_run_id
        except Exception as e:
            self.log("error", "Failed to write to Audit DB", error=str(e))
            return None

    def end_job(self, status="SUCCESS", rows_written=0, error_msg=None):
        """Updates DB with final status"""
        if not self.job_run_id:
            return
            
        try:
            conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
            cur = conn.cursor()
            query = """
                UPDATE audit.job_run 
                SET status = %s, rows_written = %s, error_message = %s, finished_at = NOW()
                WHERE job_run_id = %s;
            """
            cur.execute(query, (status, rows_written, error_msg, self.job_run_id))
            conn.commit()
            cur.close()
            conn.close()
            self.log("info", f"Job Ended: {status}", rows=rows_written)
        except Exception as e:
            self.log("error", "Failed to update Audit DB", error=str(e))