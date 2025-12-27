import os
import json
import socket
import logging
import traceback
import psycopg2
from datetime import datetime
from pytz import timezone

# Define the IST timezone
IST = timezone("Asia/Kolkata")

import config

class EnterpriseLogger:
    def __init__(self, name, log_dir=config.LOG_DIR):
        self.name = name
        self.host = socket.gethostname()
        self.history_id = os.getenv("SETU_JOB_HISTORY_ID") # Context Passing
        
        # Ensure the log directory exists
        log_path = os.path.join(log_dir, "SetuV3", "Python", datetime.now(IST).strftime('%Y-%m-%d'))
        os.makedirs(log_path, exist_ok=True)
        
        self.log_file = os.path.join(log_path, f"{name}.json")
        
        # DB Connection params (lazy loaded)
        self.db_dsn = f"host={os.getenv('DB_HOST', 'localhost')} dbname={os.getenv('DB_NAME')} user={os.getenv('DB_USER')} password={os.getenv('DB_PASS')}"

    def _write_to_db(self, level, message, metadata=None):
        """Writes high priority logs to DB if history_id is present."""
        if not self.history_id:
            return

        try:
            with psycopg2.connect(self.db_dsn) as conn:
                with conn.cursor() as cur:
                    cur.execute("""
                        INSERT INTO sys.app_logs (history_id, level, message, module, metadata)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (self.history_id, level, message, self.name, json.dumps(metadata) if metadata else None))
        except Exception as e:
            # Fallback to file/console if DB fails, don't crash app
            print(f"DB Logging failed: {e}")

    def log(self, level, message, **kwargs):
        """
        Custom log method to write structured JSON logs.
        """
        # 1. Structure the log
        log_entry = {
            "timestamp": datetime.now(IST).isoformat(),
            "level": level,
            "name": self.name,
            "message": message,
            "host": self.host,
            "history_id": self.history_id
        }

        # Add optional details to the log entry
        log_entry.update(kwargs)

        # If an exception is passed, format it
        if 'exc_info' in kwargs and kwargs['exc_info']:
            log_entry['exc_info'] = traceback.format_exc()

        # 2. Write to File (Always)
        try:
            with open(self.log_file, 'a') as f:
                f.write(json.dumps(log_entry) + '\n')
        except Exception as e:
            print(f"Failed to write to log file: {e}")
            print(json.dumps(log_entry))
            
        # 3. Write to DB (If Critical or Error)
        if level in ['ERROR', 'CRITICAL', 'WARNING']:
            self._write_to_db(level, message, metadata=log_entry)

    def info(self, msg, **kwargs): self.log('INFO', msg, **kwargs)
    def error(self, msg, **kwargs): self.log('ERROR', msg, **kwargs)
    def warning(self, msg, **kwargs): self.log('WARNING', msg, **kwargs)
    def debug(self, msg, **kwargs): self.log('DEBUG', msg, **kwargs)