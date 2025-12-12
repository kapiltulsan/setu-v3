import os
import socket
from flask import Flask, render_template
from dotenv import load_dotenv

# Import Modules
from modules.auth import auth_bp
from modules.charts import charts_bp
from modules.logs import logs_bp 
# Note: assuming logs_bp exists in modules/logs.py based on file list.
# If not, I will catch this in verification.
from modules.jobs import jobs_bp

load_dotenv()

app = Flask(__name__)

# Register Blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(charts_bp)
app.register_blueprint(jobs_bp)

# Check if logs_bp is valid (imports might fail if file doesn't have it)
try:
    from modules.logs import logs_bp
    app.register_blueprint(logs_bp)
except ImportError:
    print("Warning: Logs module not found or blueprint missing.")

@app.route('/')
def dashboard():
    host_ip = socket.gethostbyname(socket.gethostname())
    return render_template('dashboard.html', host_ip=host_ip)

if __name__ == '__main__':
    # Local Dev Run
    print("🚀 Starting Setu V3 Admin Dashboard...")
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')
