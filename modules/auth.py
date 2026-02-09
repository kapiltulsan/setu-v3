# modules/auth.py
import os
import json
import datetime
from flask import Blueprint, request, redirect, url_for, make_response
from kiteconnect import KiteConnect
from SmartApi import SmartConnect
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

def get_token_status(credential_id=None):
    """
    Checks token status. If credential_id provided, returns that specific one.
    Otherwise returns a summary dict of all known tokens.
    """
    data = get_tokens_data()
    
    def evaluate_token(cred_id, v):
        # Zerodha
        if "access_token" in v:
            return {
                "valid": True,
                "broker": "ZERODHA",
                "date": v.get("timestamp") or v.get("login_time", "N/A"),
                "id": cred_id
            }
        # AngelOne
        if "jwtToken" in v:
            return {
                "valid": True,
                "broker": "ANGEL_ONE",
                "date": v.get("timestamp") or "N/A",
                "id": cred_id
            }
        return {"valid": False, "date": "Invalid", "id": cred_id}

    if credential_id:
        if credential_id in data:
            return evaluate_token(credential_id, data[credential_id])
        return {"valid": False, "date": "Never", "id": credential_id, "message": "No token found"}

    # Summary grouped by broker (backward compatibility + global view)
    summary = {
        "ZERODHA": {"valid": False, "date": "Never", "id": None},
        "ANGEL_ONE": {"valid": False, "date": "Never", "id": None},
        "all_tokens": {}
    }
    
    for k, v in data.items():
        if not isinstance(v, dict): continue
        status = evaluate_token(k, v)
        summary["all_tokens"][k] = status
        
        # Update legacy top-level status if valid
        if status["valid"]:
            summary[status["broker"]] = status
            
    return summary

def get_kite_url():
    """Returns the login URL for the default Zerodha account."""
    try:
        sys_config = config.PORTFOLIO_RULES.get("system_config", {}).get("ohlc_provider")
        if sys_config:
            user = sys_config.get("user_ref")
            acc = sys_config.get("account_ref")
            details = config.PORTFOLIO_RULES["accounts"][user][acc]
            if details.get("broker") == "ZERODHA":
                cred_id = details["credential_id"]
                return f"/login/{cred_id}"
    except:
        pass
    return "/login/KAP_ZERODHA_PASSIVE" 

def get_angel_url():
    """Returns the login URL for the default AngelOne account."""
    try:
        sys_config = config.PORTFOLIO_RULES.get("system_config", {}).get("ohlc_provider")
        if sys_config:
            user = sys_config.get("user_ref")
            acc = sys_config.get("account_ref")
            details = config.PORTFOLIO_RULES["accounts"][user][acc]
            if details.get("broker") == "ANGEL_ONE":
                cred_id = details["credential_id"]
                return f"/login_angel/{cred_id}"
    except:
        pass
    return "/login_angel/KAP_ANGEL_LONG"

@auth_bp.route('/login/<credential_id>')
def login(credential_id):
    """Initiates login for Zerodha"""
    logger.log("info", f"Initiating Zerodha login for {credential_id}")
    api_key = os.getenv(f"{credential_id}_API_KEY") or os.getenv("KITE_API_KEY")
    if not api_key:
         return f"❌ Configuration Error: No API Key found for {credential_id}"

    kite = KiteConnect(api_key=api_key)
    response = make_response(redirect(kite.login_url()))
    response.set_cookie('pending_credential', credential_id, max_age=300)
    return response

@auth_bp.route('/login_angel/<credential_id>')
def login_angel(credential_id):
    """Initiates login for AngelOne"""
    logger.log("info", f"Initiating AngelOne login for {credential_id}")
    api_key = os.getenv(f"{credential_id}_API_KEY")
    if not api_key:
         return f"❌ Configuration Error: No API Key found for {credential_id}"

    # AngelOne SmartAPI Connect URL
    login_url = f"https://smartapi.angelbroking.com/publisher-login?api_key={api_key}"
    response = make_response(redirect(login_url))
    response.set_cookie('pending_credential', credential_id, max_age=300)
    return response

@auth_bp.route('/callback')
def callback():
    """Handles Zerodha Callback (and mistakenly routed AngelOne callbacks)"""
    
    # ----------------------------------------------
    # FIX: Angel One sometimes redirects to /callback instead of /callback_angel
    # Check if this is actually an Angel One response
    # ----------------------------------------------
    if request.args.get('auth_token'):
        logger.log("warning", "Intercepted AngelOne token on Zerodha endpoint. Rerouting...")
        return callback_angel()
    
    request_token = request.args.get('request_token')
    credential_id = request.cookies.get('pending_credential')
    
    if not request_token or not credential_id:
        return "❌ Error: Missing token or session."

    api_key = os.getenv(f"{credential_id}_API_KEY") or os.getenv("KITE_API_KEY")
    api_secret = os.getenv(f"{credential_id}_API_SECRET") or os.getenv("KITE_API_SECRET")
    
    try:
        kite = KiteConnect(api_key=api_key)
        data = kite.generate_session(request_token, api_secret=api_secret)
        save_token(credential_id, data)
        return redirect("/")
    except Exception as e:
        logger.log("error", f"Zerodha Login Failed", error=str(e))
        return f"<h3>❌ Login Failed</h3><p>{str(e)}</p>"

@auth_bp.route('/callback_angel')
def callback_angel():
    """Handles AngelOne Callback"""
    # DEBUG REDIRECTION
    logger.log("info", f"Angel Callback HIT using URL: {request.url}")
    logger.log("info", f"Angel Callback Params: {request.args}")
    logger.log("info", f"Angel Callback Cookies: {request.cookies}")

    auth_token = request.args.get('auth_token')
    credential_id = request.cookies.get('pending_credential')
    
    if not auth_token or not credential_id:
        logger.log("error", f"Angel Callback Missing Info. Token: {auth_token}, Cred: {credential_id}")
        return f"❌ Error: Missing auth_token or session. <br>Params: {request.args}<br>CredCookie: {credential_id}"

    api_key = os.getenv(f"{credential_id}_API_KEY")
    api_secret = os.getenv(f"{credential_id}_API_SECRET")
    
    try:
        # In actual SmartAPI, you might need to use the auth_token to generate session
        # For now, we store the token as is, or use it to initialize a session
        smart_api = SmartConnect(api_key=api_key)
        # Note: Depending on the flow, you might need password/totp here if not using publisher login
        # But if using publisher login, the auth_token is swapped for a session
        
        # We store it for later verification in AngelOneClient.login
        save_token(credential_id, {"jwtToken": auth_token, "broker": "ANGEL_ONE"})
        
        logger.log("info", f"AngelOne Token Saved for {credential_id}")
        return redirect("/")
    except Exception as e:
        logger.log("error", f"AngelOne Login Failed", error=str(e))
        return f"<h3>❌ Angel Login Failed</h3><p>{str(e)}</p>"
