import os
import json
import datetime
import socket
import glob
from flask import Flask, render_template, request, redirect, url_for
from kiteconnect import KiteConnect
from dotenv import load_dotenv
from db_logger import EnterpriseLogger

# --- Config ---
load_dotenv()
API_KEY = os.getenv("KITE_API_KEY")
API_SECRET = os.getenv("KITE_API_SECRET")

# Path to Logs: logs/SetuV3/Python/
LOG_BASE_DIR = os.path.join("logs", "SetuV3", "Python")

logger = EnterpriseLogger("admin_dashboard")
app = Flask(__name__)
kite = KiteConnect(api_key=API_KEY)

TOKEN_FILE = "tokens.json"

def get_token_status():
    """Checks if tokens.json is fresh (from today)."""
    if not os.path.exists(TOKEN_FILE):
        return False, "Never"
    
    timestamp = os.path.getmtime(TOKEN_FILE)
    file_date = datetime.datetime.fromtimestamp(timestamp).date()
    today = datetime.datetime.now().date()
    
    display_time = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')
    return (file_date == today), display_time

def get_recent_logs():
    """
    Reads today's log files from ALL scripts and merges them.
    """
    logs = []
    today_str = datetime.datetime.now().strftime("%Y-%m-%d")
    
    # Target: logs/SetuV3/Python/2023-XX-XX/*.json
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
                        # Normalize fields
                        entry['script'] = script_name
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
    return logs[:100], today_log_dir # Return top 100

@app.route('/')
def dashboard():
    is_valid, token_date = get_token_status()
    login_url = kite.login_url()
    
    # Get Local IP
    hostname = socket.gethostname()
    try:
        host_ip = socket.gethostbyname(hostname)
    except:
        host_ip = "127.0.0.1"
    
    # Fetch Logs
    recent_logs, log_path = get_recent_logs()

    return render_template('dashboard.html', 
                           token_is_valid=is_valid, 
                           token_date=token_date, 
                           login_url=login_url,
                           host_ip=host_ip,
                           logs=recent_logs,
                           log_path=log_path)

@app.route('/callback')
def callback():
    request_token = request.args.get('request_token')
    if not request_token:
        return "❌ Error: No token received."

    try:
        data = kite.generate_session(request_token, api_secret=API_SECRET)
        with open(TOKEN_FILE, 'w') as f:
            json.dump(data, f, indent=4, default=str)
            f.flush()
            os.fsync(f.fileno())

        logger.log("info", "Token Generated via Admin Dashboard")
        return redirect(url_for('dashboard'))

    except Exception as e:
        logger.log("error", "Admin Login Failed", error=str(e))
        return f"<h3>❌ Login Failed</h3><p>{str(e)}</p>"

if __name__ == '__main__':
    print(f"🚀 Admin Dashboard running on https://0.0.0.0:5000")
    # 'adhoc' provides immediate HTTPS (Warning will appear in browser, simpler than self-signed)
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')