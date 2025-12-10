# modules/logs.py
import os
import glob
import json
import datetime

# Adjust path relative to where app.py runs
LOG_BASE_DIR = os.path.join("logs", "SetuV3", "Python")

def get_recent_logs(limit=100):
    """Fetches and merges logs from all scripts for today"""
    logs = []
    today_str = datetime.datetime.now().strftime("%Y-%m-%d")
    today_log_dir = os.path.join(LOG_BASE_DIR, today_str)
    search_path = os.path.join(today_log_dir, "*.json")
    
    files = glob.glob(search_path)
    
    for file_path in files:
        script_name = os.path.basename(file_path).replace('.json', '')
        try:
            with open(file_path, 'r') as f:
                for line in f:
                    try:
                        entry = json.loads(line)
                        entry['script'] = script_name
                        # Normalize fields
                        if 'message' in entry and 'event' not in entry:
                            entry['event'] = entry['message']
                        if 'levelname' in entry and 'level' not in entry:
                            entry['level'] = entry['levelname']
                        logs.append(entry)
                    except json.JSONDecodeError:
                        continue
        except Exception:
            continue
            
    # Sort: Newest First
    logs.sort(key=lambda x: x.get('timestamp', ''), reverse=True)
    return logs[:limit], today_log_dir