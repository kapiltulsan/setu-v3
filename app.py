# app.py
import socket
from flask import Flask, render_template
from modules.auth import auth_bp, get_token_status, get_kite_url
from modules.logs import get_recent_logs
import psutil
import psycopg2
import os
from flask import jsonify

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS")
        )
        return conn
    except Exception as e:
        print(f"DB Connection Failed: {e}")
        return None

def get_system_metrics():
    # 1. System Metrics
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

    # 2. Database Metrics
    db_size = "N/A"
    db_conns = 0
    
    conn = get_db_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                # DB Size
                cur.execute("SELECT pg_size_pretty(pg_database_size(current_database()));")
                db_size = cur.fetchone()[0]
                
                # Active Connections
                cur.execute("SELECT count(*) FROM pg_stat_activity WHERE datname = current_database();")
                db_conns = cur.fetchone()[0]
        except Exception as e:
            print(f"DB Query Failed: {e}")
        finally:
            conn.close()

    return {
        "cpu": cpu,
        "ram_percent": memory.percent,
        "ram_used": round(memory.used / (1024**3), 2),
        "ram_total": round(memory.total / (1024**3), 2),
        "disk_percent": disk.percent,
        "disk_free": round(disk.free / (1024**3), 2),
        "temp": temp,
        "db_size": db_size,
        "db_conns": db_conns
    }

app = Flask(__name__)

# Register Blueprints (Routes from modules)
app.register_blueprint(auth_bp)

@app.route('/api/system_stats')
def api_system_stats():
    return jsonify(get_system_metrics())

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