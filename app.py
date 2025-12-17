import os
import socket
import psutil
from flask import Flask, render_template, jsonify
from werkzeug.middleware.proxy_fix import ProxyFix
from dotenv import load_dotenv

# Import Modules
from modules.auth import auth_bp, get_token_status, get_kite_url
from modules.charts import charts_bp
from modules.logs import logs_bp, get_recent_logs
from modules.jobs import jobs_bp

load_dotenv()

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_port=1)

# Register Blueprints

# Register Blueprints
# Register Blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(charts_bp)
app.register_blueprint(jobs_bp)
app.register_blueprint(logs_bp)
from modules.portfolio import portfolio_bp
app.register_blueprint(portfolio_bp)

def get_system_stats():
    """Helper to get system stats using psutil"""
    try:
        cpu = psutil.cpu_percent(interval=None)
        
        mem = psutil.virtual_memory()
        ram_percent = mem.percent
        ram_used = round(mem.used / (1024**3), 2)
        ram_total = round(mem.total / (1024**3), 2)
        
        disk = psutil.disk_usage('/')
        disk_percent = disk.percent
        disk_free = round(disk.free / (1024**3), 2)
        
        # Temp (Linux/Pi only usually)
        temp = 0
        try:
            temps = psutil.sensors_temperatures()
            if 'cpu_thermal' in temps:
                temp = temps['cpu_thermal'][0].current
            elif 'coretemp' in temps:
                temp = temps['coretemp'][0].current
        except:
            temp = 0
            
        return {
            "cpu": cpu,
            "ram_percent": ram_percent,
            "ram_used": ram_used,
            "ram_total": ram_total,
            "disk_percent": disk_percent,
            "disk_free": disk_free,
            "db_size": "N/A", # Placeholder
            "db_conns": 0,    # Placeholder
            "temp": temp
        }
    except Exception as e:
        print(f"Error fetching stats: {e}")
        return {
            "cpu": 0, "ram_percent": 0, "ram_used": 0, "ram_total": 0,
            "disk_percent": 0, "disk_free": 0, "db_size": "Err", "db_conns": 0, "temp": 0
        }

@app.route('/api/system_stats')
def api_system_stats():
    return jsonify(get_system_stats())

@app.route('/')
def dashboard():
    host_ip = socket.gethostbyname(socket.gethostname())
    
    # Get Data for Initial Render
    logs, log_dir = get_recent_logs()
    sys_health = get_system_stats()
    
    return render_template('dashboard.html', 
                         host_ip=host_ip,
                         logs={'data': logs, 'path': log_dir},
                         sys_health=sys_health,
                         auth={
                             'valid': get_token_status()[0],
                             'date': get_token_status()[1],
                             'login_url': get_kite_url()
                         })

if __name__ == '__main__':
    # Local Dev Run
    print("🚀 Starting Setu V3 Admin Dashboard...")
    #app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')
    app.run(host='0.0.0.0', port=5000, debug=True)
#
