# app.py
import socket
from flask import Flask, render_template
from modules.auth import auth_bp, get_token_status, get_kite_url
from modules.logs import get_recent_logs
import psutil

def get_system_metrics():
    cpu = psutil.cpu_percent(interval=None)
    memory = psutil.virtual_memory()
    disk = psutil.disk_usage('/')
    
    # Try to get temp (Linux/Pi specific)
    temp = 0
    try:
        temps = psutil.sensors_temperatures()
        if 'cpu_thermal' in temps:
            temp = temps['cpu_thermal'][0].current
    except:
        pass

    return {
        "cpu": cpu,
        "ram_percent": memory.percent,
        "ram_used": round(memory.used / (1024**3), 2),
        "ram_total": round(memory.total / (1024**3), 2),
        "disk_percent": disk.percent,
        "disk_free": round(disk.free / (1024**3), 2),
        "temp": temp
    }

app = Flask(__name__)

# Register Blueprints (Routes from modules)
app.register_blueprint(auth_bp)

@app.route('/')
def dashboard():
    # 1. Collect Data from AUTH Module
    is_valid, token_date = get_token_status()
    auth_data = {
        "valid": is_valid,
        "date": token_date,
        "login_url": get_kite_url()
    }

    # 2. Collect Data from LOGS Module
    logs_list, logs_path = get_recent_logs()
    logs_data = {
        "data": logs_list,
        "path": logs_path
    }

    # 3. Get System Info
    hostname = socket.gethostname()
    try:
        host_ip = socket.gethostbyname(hostname)
    except:
        host_ip = "127.0.0.1"

    # 4. Collect System Metrics (Pi5)
    sys_health = get_system_metrics()

    # 5. Render the Master Grid
    return render_template('dashboard.html', 
                           auth=auth_data, 
                           logs=logs_data,
                           host_ip=host_ip,
                           sys_health=sys_health)

if __name__ == '__main__':
    print(f"🚀 Setu V3 Admin running on https://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')