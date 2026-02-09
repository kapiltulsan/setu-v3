"""
MODULE: ADMIN BACKEND (FLASK)
=============================
Purpose:
  The core API and Management Server for Setu V3.
  Hosted on Port 5000.

Features:
  - Serves the Admin Dashboard (Server-Side Rendered Templates).
  - Provides REST APIs for the Next.js Reporting Panel.
  - Manages Background Jobs, Authentication, and System Health monitoring.
  - Hosts the Scheduler instance.

Blueprints:
  - Auth, Charts, Jobs, Logs, Scanners, Scheduler, Portfolio
"""

import os
import socket
import psutil
from flask import Flask, render_template, jsonify
from werkzeug.middleware.proxy_fix import ProxyFix
from dotenv import load_dotenv

load_dotenv() # Load env before importing modules that might use them (like scanner_engine)

# Import Modules
from modules.logs import logs_bp, get_recent_logs
from modules.auth import auth_bp, get_token_status, get_kite_url, get_angel_url
from modules.charts import charts_bp
from modules.jobs import jobs_bp
from modules.scanners import scanners_bp # NEW
from modules.scheduler import scheduler_bp
from modules.backtesting.api import backtesting_bp
# Trigger Restart

load_dotenv()

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_port=1)

# Register Blueprints

# Register Blueprints
# Register Blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(charts_bp)
app.register_blueprint(jobs_bp)
app.register_blueprint(scanners_bp) # NEW
app.register_blueprint(scheduler_bp)
app.register_blueprint(logs_bp)
app.register_blueprint(backtesting_bp)
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

from flask import redirect, request

@app.route('/backtest')
def redirect_backtest():
    # Redirect to Next.js port 3000
    host = request.host.split(':')[0]
    return redirect(f"https://{host}:3000/backtest")

@app.route('/scanners')
def redirect_scanners():
    # Redirect to Next.js port 3000
    host = request.host.split(':')[0]
    return redirect(f"https://{host}:3000/scanners")

@app.route('/scanners/<path:path>')
def redirect_scanners_sub(path):
    host = request.host.split(':')[0]
    return redirect(f"https://{host}:3000/scanners/{path}")

@app.route('/reporting')
def redirect_reporting():
    host = request.host.split(':')[0]
    return redirect(f"https://{host}:3000/reporting")

@app.route('/')
def dashboard():
    host_ip = socket.gethostbyname(socket.gethostname())
    
    # Get Data for Initial Render
    logs, log_dir = get_recent_logs()
    sys_health = get_system_stats()
    auth_status = get_token_status()
    auth_status["ZERODHA"]["login_url"] = get_kite_url()
    auth_status["ANGEL_ONE"]["login_url"] = get_angel_url()
    
    return render_template('dashboard.html', 
                         host_ip=host_ip,
                         logs={'data': logs, 'path': log_dir},
                         sys_health=sys_health,
                         auth_status=auth_status)

if __name__ == '__main__':
    # The print verifies it's actually running
    print("Starting Setu V3 Backend on Port 5000...") 
    
    if os.path.exists("cert.pem") and os.path.exists("key.pem"):
        print("🔐 HTTPS Enabled (using cert.pem/key.pem)")
        app.run(host='0.0.0.0', port=5000, debug=True, ssl_context=('cert.pem', 'key.pem'))
    else:
        print("⚠️ HTTPS Disabled (certs not found)")
        app.run(host='0.0.0.0', port=5000, debug=True)
#
