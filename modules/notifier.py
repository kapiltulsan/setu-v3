import os
import time
import queue
import socket
import threading
import requests
import datetime
import logging
import uuid
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# --- Configuration ---
NOTIFIER_TYPE = os.getenv("NOTIFIER_TYPE", "telegram")
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
TELEGRAM_CHAT_IDS = [x.strip() for x in os.getenv("TELEGRAM_CHAT_ID", "").split(",") if x.strip()]
DASHBOARD_URL = os.getenv("DASHBOARD_URL")
HOSTNAME = socket.gethostname()
ENV = "PROD" if "prod" in HOSTNAME.lower() else "DEV"

# --- Globals ---
# Priority Queue: (priority_int, timestamp, payload)
# Priority: Lower is higher priority. 10=CRITICAL, 30=HIGH, 50=DEFAULT, 80=LOW
_notification_queue = queue.PriorityQueue()
_worker_thread = None

# Configure module logging
logger = logging.getLogger("notifier")
logger.setLevel(logging.INFO)
if not logger.handlers:
    ch = logging.StreamHandler()
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    logger.addHandler(ch)

def start_notifier_worker():
    """
    Starts the background worker thread if not already running.
    """
    global _worker_thread
    if _worker_thread is None or not _worker_thread.is_alive():
        _worker_thread = threading.Thread(target=_notification_worker, daemon=True, name="NotifierWorker")
        _worker_thread.start()
        logger.info("Notifier worker thread started.")

def _notification_worker():
    """
    Consumer loop that processes notifications from the queue.
    """
    while True:
        try:
            # Block until an item is available
            priority, _, payload = _notification_queue.get()
            
            try:
                _dispatch_telegram(payload)
            except Exception as e:
                logger.error(f"Failed to dispatch notification: {e}")
            finally:
                _notification_queue.task_done()
            
            # Governor: 1-second delay between messages to avoid rate limits
            time.sleep(1)
            
        except Exception as e:
            logger.error(f"Critical error in notification worker: {e}")
            time.sleep(5)  # Backoff on crash

def _format_html_message(payload):
    """
    Formats the notification payload into the strict HTML hierarchy.
    """
    subject = payload.get("subject", "Notification")
    details = payload.get("details", []) # List of strings
    technicals = payload.get("technicals", {}) # Dict of key-value pairs
    actionable = payload.get("actionable", []) # List of strings
    severity = payload.get("severity", "INFO").upper()
    exec_id = payload.get("exec_id", "N/A")

    # [Header: Severity | Env]
    icon = "🔴" if severity in ["CRITICAL", "ERROR"] else "🟡" if severity == "WARNING" else "🟢"
    header = f"<b>{icon} {severity} | {ENV} | {HOSTNAME}</b>"
    
    # [Subject: Bold Summary]
    body = f"\n\n<b>{subject}</b>"
    
    # [Details: Bulleted]
    if details:
        if isinstance(details, str):
            details = [details]
        body += "\n\n📋 <b>Details:</b>"
        for item in details:
            body += f"\n• {item}"
            
    # [Technicals: Monospaced Job/ExecID]
    tech_lines = []
    if exec_id and exec_id != "N/A":
        tech_lines.append(f"ExecID: {exec_id}")
    for k, v in technicals.items():
        tech_lines.append(f"{k}: {v}")
        
    if tech_lines:
        body += "\n\n🛠 <b>Technicals:</b>\n<pre>" + "\n".join(tech_lines) + "</pre>"

    # [Closing: Actionable Steps]
    if actionable:
        if isinstance(actionable, str):
            actionable = [actionable]
        body += "\n\n🚀 <b>Action Required:</b>"
        for step in actionable:
            body += f"\n👉 {step}"

    # [Deep Links: HTML Hyperlinks]
    links = []
    if DASHBOARD_URL:
        links.append(f"<a href='{DASHBOARD_URL}'>Dashboard</a>")
    # Add more relevant links if provided in payload?
    
    if links:
        body += "\n\n🔗 " + " | ".join(links)
        
    # Timestamp footer
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    body += f"\n\n<i>{timestamp}</i>"

    return body

def _dispatch_telegram(payload):
    """
    Sends the formatted message to Telegram with retry logic.
    """
    if NOTIFIER_TYPE != "telegram":
        logger.warning(f"Skipping dispatch: NOTIFIER_TYPE is {NOTIFIER_TYPE}")
        return

    if not TELEGRAM_BOT_TOKEN:
        logger.error("TELEGRAM_BOT_TOKEN is missing")
        return

    message_html = _format_html_message(payload)
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"

    for chat_id in TELEGRAM_CHAT_IDS:
        data = {
            "chat_id": chat_id,
            "text": message_html,
            "parse_mode": "HTML",
            "disable_web_page_preview": True
        }

        # 3-tier exponential backoff
        for attempt in range(1, 4):
            try:
                response = requests.post(url, json=data, timeout=10)
                if response.status_code == 200:
                    logger.info(f"Message sent to {chat_id}")
                    break
                else:
                    logger.warning(f"Telegram failed (Attempt {attempt}): {response.text}")
            except Exception as e:
                logger.warning(f"Telegram connection error (Attempt {attempt}): {e}")
            
            if attempt < 3:
                time.sleep(2 ** attempt) # 2s, 4s

def send_notification(subject, details=None, technicals=None, actionable=None, severity="INFO", priority="default", exec_id=None):
    """
    Public API to enqueue a notification.
    
    Args:
        subject (str): Bold summary of the event.
        details (list/str): Detailed bullet points.
        technicals (dict): Key-value pairs for monospaced technical info.
        actionable (list/str): Actionable steps for the user.
        severity (str): INFO, WARNING, ERROR, CRITICAL.
        priority (str): 'critical', 'high', 'default', 'low'.
        exec_id (str): UUID for tracing.
    """
    # Start worker on first call if needed
    start_notifier_worker()

    priority_map = {
        "critical": 10,
        "high": 30,
        "default": 50,
        "low": 80
    }
    prio_int = priority_map.get(priority.lower(), 50)
    
    # Support legacy simple calls where details might constitute the message
    if details is None:
        details = []
    if technicals is None:
        technicals = {}
    if actionable is None:
        actionable = []

    payload = {
        "subject": subject,
        "details": details,
        "technicals": technicals,
        "actionable": actionable,
        "severity": severity,
        "exec_id": exec_id or str(uuid.uuid4())
    }
    
    # Push to queue: (priority, timestamp, payload)
    # Timestamp ensures FIFO for same priority
    _notification_queue.put((prio_int, time.time(), payload))
    logger.debug(f"Queued notification: {subject}")

if __name__ == "__main__":
    # Test execution
    print("🔔 Queuing test notifications...")
    
    # Start the worker explicitly for script execution
    start_notifier_worker()
    
    send_notification(
        subject="Test Alert System",
        details=["Testing the new asynchronous notifier.", "Verifying HTML formatting.", "Checking priority queue."],
        technicals={"Module": "notifier.py", "QueueSize": "1"},
        actionable=["Check Telegram", "Verify format"],
        severity="INFO",
        priority="high"
    )
    
    send_notification(
        subject="Critical Failure Simulation",
        details="Simulating a critical error to test priority.",
        severity="CRITICAL",
        priority="critical" 
    )

    print("⏳ Waiting for worker to flush queue...")
    # Wait for queue to be empty
    _notification_queue.join()
    print("✅ All notifications sent.")
