import os
import requests
import datetime
import datetime
import socket
import time
from dotenv import load_dotenv

load_dotenv()

# Configuration
NOTIFIER_TYPE = os.getenv("NOTIFIER_TYPE", "telegram")
NTFY_TOPIC = os.getenv("NTFY_TOPIC", "setu_alerts")
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
TELEGRAM_CHAT_IDS = os.getenv("TELEGRAM_CHAT_ID", "").split(",")
DASHBOARD_URL = os.getenv("DASHBOARD_URL")

HOSTNAME = socket.gethostname()

def send_notification(title, message, priority='default'):
    """
    Sends a notification via the configured channel (Telegram or NTFY).
    """
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # 1. Telegram Logic (Default)
    if NOTIFIER_TYPE == "telegram":
        if not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHAT_IDS:
            print("❌ Telegram Check Failed: Missing Token or Chat ID")
            return

        # Build richer HTML message
        # Format:
        # Title (Bold)
        # Message
        # [Link to Dashboard]
        # Hostname | Time
        
        html_text = f"<b>{title}</b>\n{message}\n\n"
        
        if DASHBOARD_URL:
            html_text += f"<a href='{DASHBOARD_URL}'>Login to Dashboard</a>\n"
            
        html_text += f"<i>{HOSTNAME} | {timestamp}</i>"

        url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"

        for chat_id in TELEGRAM_CHAT_IDS:
            chat_id = chat_id.strip()
            if not chat_id: continue
                
            payload = {
                "chat_id": chat_id,
                "text": html_text,
                "parse_mode": "HTML",
                "disable_web_page_preview": True
            }
            
            # Retry Logic (3 Attempts)
            max_retries = 3
            for attempt in range(1, max_retries + 1):
                try:
                    response = requests.post(url, json=payload, timeout=10) # increased timeout
                    if response.status_code == 200:
                        break # Success
                    else:
                        print(f"⚠️ Telegram Error (Attempt {attempt}): {response.text}")
                except Exception as e:
                    print(f"⚠️ Telegram Connection Failed (Attempt {attempt}): {e}")
                
                if attempt < max_retries:
                    time.sleep(2 * attempt) # Exponential backoff: 2s, 4s...
            else:
                print(f"❌ Failed to send Telegram alert to {chat_id} after {max_retries} attempts.")

    # 2. NTFY Logic (Fallback/Alternative)
    elif NOTIFIER_TYPE == "ntfy":
        headers = {
            "Title": f"[{HOSTNAME}] {title}",
            "Priority": "high" if priority == 'high' else "default",
            "Tags": "warning,zerodha"
        }
        
        full_message = f"{message}\n({timestamp})"
        if DASHBOARD_URL:
             # Ntfy supports 'Click' header for actions
             headers["Click"] = DASHBOARD_URL
             
        try:
            requests.post(f"https://ntfy.sh/{NTFY_TOPIC}", 
                          data=full_message.lower().encode('utf-8'), # ntfy likes utf-8 bytes
                          headers=headers, timeout=5)
        except Exception as e:
            print(f"❌ Failed to send NTFY alert: {e}")

if __name__ == "__main__":
    # Test Block
    print("🔔 Sending Test Notification...")
    send_notification(
        "Test Alert 🚀", 
        "This is a test notification from the Setu V3 system.",
        priority="high"
    )
    print("✅ Done.")
