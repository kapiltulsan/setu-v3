# modules/auth.py
import os
import json
import datetime
from flask import Blueprint, request, redirect, url_for, make_response
from kiteconnect import KiteConnect
from dotenv import load_dotenv
from db_logger import EnterpriseLogger
import config

load_dotenv()
TOKEN_FILE = config.TOKENS_FILE
logger = EnterpriseLogger("mod_auth")
auth_bp = Blueprint('auth', __name__)

def get_tokens_data():
    if os.path.exists(TOKEN_FILE):
        try:
            with open(TOKEN_FILE, 'r') as f:
                return json.load(f)
        except:
            return {}
    return {}

def save_token(credential_id, token_data):
    data = get_tokens_data()
    # Add timestamp
    token_data['timestamp'] = str(datetime.datetime.now())
    data[credential_id] = token_data
    
    with open(TOKEN_FILE, 'w') as f:
        json.dump(data, f, indent=4, default=str)
        f.flush()
        os.fsync(f.fileno())

def get_token_status():
    """
    Checks token status.
    Returns (bool_is_valid, str_last_login_time)
    """
    data = get_tokens_data()
    if not data:
        return False, "No Tokens"
        
    # Check if ANY valid token exists (Simple check)
    has_token = False
    last_time = "Never"
    
    # Iterate and find at least one valid session
    for k, v in data.items():
        if isinstance(v, dict) and "access_token" in v:
            has_token = True
            last_time = v.get("timestamp") or v.get("login_time", "N/A")
            # If we find a specific preferred one, maybe return that?
            # For now, just returning the first one's status is enough to say "System is Online"
            
    return has_token, last_time

def get_kite_url():
    """
    Returns the login URL for the default/primary account.
    """
    # Ideally this should point to a page listing all accounts to login.
    # For now, we return a link that might trigger the most critical one (Data Source).
    
    # Try to find the OHLC provider from config
    try:
        sys_config = config.PORTFOLIO_RULES.get("system_config", {}).get("ohlc_provider")
        if sys_config:
            user = sys_config.get("user_ref")
            acc = sys_config.get("account_ref")
            details = config.PORTFOLIO_RULES["accounts"][user][acc]
            cred_id = details["credential_id"]
            return f"/login/{cred_id}"
    except:
        pass
        
    # Fallback
    return "/login/KAP_ZERODHA_PASSIVE" 

@auth_bp.route('/login/<credential_id>')
def login(credential_id):
    """Initiates login for a specific credential ID"""
    logger.log("info", f"Initiating login for {credential_id}")
    
    # Look up API Key for this credential
    api_key = os.getenv(f"{credential_id}_API_KEY")
    if not api_key:
        api_key = os.getenv("KITE_API_KEY") # Fallback
        
    if not api_key:
         return f"❌ Configuration Error: No API Key found for {credential_id}"

    kite = KiteConnect(api_key=api_key)
    
    # Set cookie to track which user is logging in
    response = make_response(redirect(kite.login_url()))
    response.set_cookie('pending_credential', credential_id, max_age=300)
    return response

@auth_bp.route('/callback')
def callback():
    """Handles the return trip from Zerodha"""
    request_token = request.args.get('request_token')
    credential_id = request.cookies.get('pending_credential')
    
    if not request_token:
        return "❌ Error: No token received."

    if not credential_id:
        return "❌ Error: Session Cookie Expired. Please retry login from Dashboard."

    # Fetch Secret
    api_key = os.getenv(f"{credential_id}_API_KEY") or os.getenv("KITE_API_KEY")
    api_secret = os.getenv(f"{credential_id}_API_SECRET") or os.getenv("KITE_API_SECRET")
    
    if not api_key or not api_secret:
        return f"❌ Config Error: Missing keys for {credential_id}"

    try:
        kite = KiteConnect(api_key=api_key)
        data = kite.generate_session(request_token, api_secret=api_secret)
        
        save_token(credential_id, data)

        logger.log("info", f"Token Generated for {credential_id}")
        return redirect("/") # Redirect to home/dashboard

    except Exception as e:
        logger.log("error", f"Login Failed for {credential_id}", error=str(e))
        return f"<h3>❌ Login Failed</h3><p>{str(e)}</p>"