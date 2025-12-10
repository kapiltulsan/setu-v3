# modules/auth.py
import os
import json
import datetime
import socket
from flask import Blueprint, request, redirect, url_for
from kiteconnect import KiteConnect
from dotenv import load_dotenv
from db_logger import EnterpriseLogger

load_dotenv()
API_KEY = os.getenv("KITE_API_KEY")
API_SECRET = os.getenv("KITE_API_SECRET")
TOKEN_FILE = "tokens.json"

logger = EnterpriseLogger("mod_auth")
auth_bp = Blueprint('auth', __name__)
kite = KiteConnect(api_key=API_KEY)

def get_kite_url():
    return kite.login_url()

def get_token_status():
    """Returns (is_valid: bool, display_time: str)"""
    if not os.path.exists(TOKEN_FILE):
        return False, "Never"
    
    timestamp = os.path.getmtime(TOKEN_FILE)
    file_date = datetime.datetime.fromtimestamp(timestamp).date()
    today = datetime.datetime.now().date()
    display_time = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')
    
    return (file_date == today), display_time

@auth_bp.route('/callback')
def callback():
    """Handles the return trip from Zerodha"""
    request_token = request.args.get('request_token')
    if not request_token:
        return "❌ Error: No token received."

    try:
        data = kite.generate_session(request_token, api_secret=API_SECRET)
        with open(TOKEN_FILE, 'w') as f:
            json.dump(data, f, indent=4, default=str)
            f.flush()
            os.fsync(f.fileno())

        logger.log("info", "Token Generated via Admin Tile")
        return redirect(url_for('dashboard')) # Redirects back to main page

    except Exception as e:
        logger.log("error", "Admin Login Failed", error=str(e))
        return f"<h3>❌ Login Failed</h3><p>{str(e)}</p>"