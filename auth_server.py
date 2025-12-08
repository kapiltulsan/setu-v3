import os
import json
from flask import Flask, request, redirect
from kiteconnect import KiteConnect
from dotenv import load_dotenv

# 1. Load Secrets
load_dotenv()
API_KEY = os.getenv("KITE_API_KEY")
API_SECRET = os.getenv("KITE_API_SECRET")

if not API_KEY or not API_SECRET:
    print("❌ ERROR: KITE_API_KEY or KITE_API_SECRET not found in .env")
    exit(1)

# 2. Initialize App & Kite
app = Flask(__name__)
kite = KiteConnect(api_key=API_KEY)

# 3. Route: The Landing Page
@app.route('/')
def index():
    login_url = kite.login_url()
    return f'''
        <h1>Project Setu V3 - Auth Server</h1>
        <p>Click below to generate today's Access Token.</p>
        <a href="{login_url}">
            <button style="padding: 10px 20px; font-size: 16px; cursor: pointer;">Login with Zerodha Kite</button>
        </a>
    '''

# 4. Route: The Callback (Where Kite sends you back)
@app.route('/callback')
def callback():
    # Get the "request_token" from the URL
    request_token = request.args.get('request_token')
    
    if not request_token:
        return "❌ Error: No request_token received."

    try:
        # Exchange Request Token for Access Token
        data = kite.generate_session(request_token, api_secret=API_SECRET)
        
        # Save the token to a file (Project Setu will read this file)
        with open('tokens.json', 'w') as f:
            json.dump(data, f, indent=4, default=str)
            
        return f'''
            <h2 style="color: green;">✅ Success!</h2>
            <p>Access Token generated and saved to <b>tokens.json</b>.</p>
            <p>You can close this tab and start your trading bot.</p>
            <pre>{json.dumps(data, indent=4, default=str)}</pre>
        '''
    except Exception as e:
        return f"<h2 style='color: red;'>❌ Failed: {str(e)}</h2>"

if __name__ == '__main__':
    print("🚀 Auth Server running on http://localhost:5000")
    # host='0.0.0.0' allows connections from outside this computer
    # ssl_context='adhoc' creates a temporary secure HTTPS connection
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')