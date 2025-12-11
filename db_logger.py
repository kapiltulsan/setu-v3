import os
import json
import socket
import logging
import traceback
from datetime import datetime
from pytz import timezone

# Define the IST timezone
IST = timezone("Asia/Kolkata")

import config

class EnterpriseLogger:
    def __init__(self, name, log_dir=config.LOG_DIR):
        self.name = name
        self.host = socket.gethostname()
        
        # Ensure the log directory exists
        log_path = os.path.join(log_dir, "SetuV3", "Python", datetime.now(IST).strftime('%Y-%m-%d'))
        os.makedirs(log_path, exist_ok=True)
        
        self.log_file = os.path.join(log_path, f"{name}.json")

    def log(self, level, message, **kwargs):
        """
        Custom log method to write structured JSON logs.
        """
        # --- FIX: Generate timestamp with IST timezone ---
        log_entry = {
            "timestamp": datetime.now(IST).isoformat(),
            "level": level,
            "name": self.name,
            "message": message,
            "host": self.host,
        }

        # Add optional details to the log entry
        log_entry.update(kwargs)

        # If an exception is passed, format it
        if 'exc_info' in kwargs and kwargs['exc_info']:
            log_entry['exc_info'] = traceback.format_exc()

        try:
            with open(self.log_file, 'a') as f:
                f.write(json.dumps(log_entry) + '\n')
        except Exception as e:
            # Fallback to console if file logging fails
            print(f"Failed to write to log file: {e}")
            print(json.dumps(log_entry))