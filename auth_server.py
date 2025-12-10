import os
import json
import signal
import socket
import threading
import time
from flask import Flask, request
from kiteconnect import KiteConnect
from dotenv import load_dotenv
from db_logger import EnterpriseLogger

# 1. Load Secrets
load_dotenv()
API_KEY = os.getenv("KITE_API_KEY")
API_SECRET = os.getenv("KITE_API_SECRET")

# 2. Initialize Logger
logger = EnterpriseLogger("auth_server")

if not API_KEY or not API_SECRET:
    logger.log("error", "Missing Credentials", msg="KITE_API_KEY or KITE_API_SECRET not found in .env")
    exit(1)

app = Flask(__name__)
kite = KiteConnect(api_key=API_KEY)

# Helper function to kill server safely
def delayed_shutdown():
    logger.log("info", "Shutdown Timer Started", wait_time="2 seconds")
    time.sleep(2)
    logger.log("info", "Shutting down Auth Server now...")
    os.kill(os.getpid(), signal.SIGINT)

# 3. Route: Landing Page
@app.route('/')
def index():
    client_ip = request.remote_addr
    logger.log("info", "Login Page Accessed", client_ip=client_ip)
    
    login_url = kite.login_url()
    return f'''
        <h1>Project Setu V3 - Auth Server ({socket.gethostname()})</h1>
        <p>Click below to generate today's Access Token.</p>
        <a href="{login_url}">
            <button style="padding: 10px 20px; font-size: 16px; cursor: pointer;">Login with Zerodha Kite</button>
        </a>
    '''

# 4. Route: Callback
@app.route('/callback')
def callback():
    request_token = request.args.get('request_token')
    client_ip = request.remote_addr
    
    if not request_token:
        logger.log("warning", "Missing Request Token", client_ip=client_ip)
        return "❌ Error: No request_token received."

    try:
        data = kite.generate_session(request_token, api_secret=API_SECRET)
        
        # Absolute path ensures we write where we expect
        script_dir = os.path.dirname(os.path.abspath(__file__))
        token_file_path = os.path.join(script_dir, 'tokens.json')
        
        # Write File
        with open(token_file_path, 'w') as f:
            json.dump(data, f, indent=4, default=str)
            f.flush() # Force write to disk
            os.fsync(f.fileno()) # Double force to OS disk

        # Verify
        if not os.path.exists(token_file_path):
            raise IOError("File write verification failed.")
            
        logger.log("info", "Authentication Success", path=token_file_path)

        # --- THE FIX: Run shutdown in a separate thread ---
        # This allows the 'return' statement below to execute immediately,
        # showing the Success page to the user BEFORE the server dies.
        thread = threading.Thread(target=delayed_shutdown)
        thread.start()

        return f'''
            <h2 style="color: green;">✅ Success!</h2>
            <p>Token saved to: {token_file_path}</p>
            <p>Server will shut down in 2 seconds...</p>
            <pre>{json.dumps(data, indent=4, default=str)}</pre>
        '''
    except Exception as e:
        logger.log("error", "Authentication Failed", error=str(e), client_ip=client_ip)
        return f"<h2 style='color: red;'>❌ Failed: {str(e)}</h2>"

if __name__ == '__main__':
    try:
        logger.log("info", f"Auth Server Starting on Port 5000", protocol="HTTPS")
        app.run(host='0.0.0.0', port=5000, debug=False, ssl_context='adhoc')
        
    except KeyboardInterrupt:
        logger.log("info", "Auth Server Stopped Manually")
    except Exception as e:
        logger.log("error", "Auth Server Crashed", error=str(e))