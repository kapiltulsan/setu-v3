import os
import sys
import time
import datetime
import fcntl  # Note: fcntl is Linux specific. For Windows dev we might need a workaround, or just standard file existence check.
             # Since deployment is Pi (Linux), we should ideally use fcntl, but for Windows compat during dev, we can use a simpler lock.
             # Let's use a simple file-based lock with PID for cross-platform simplicity in this context.

# Add project root to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from modules import notifier
import config

# --- Configuration ---
CHECK_INTERVAL_SEC = 1800  # 30 Minutes
MAX_DURATION_HOURS = 8     # Run for 8 hours max (e.g. 8:30 AM to 4:30 PM)
LOCK_FILE = os.path.join(os.path.dirname(__file__), "token_monitor.lock")

def acquire_lock():
    """
    Simple file-based lock to prevent duplicate instances.
    Writes PID to file.
    """
    if os.path.exists(LOCK_FILE):
        # Check if process is actually running
        try:
            with open(LOCK_FILE, 'r') as f:
                old_pid = int(f.read().strip())
            
            # Check if PID exists (Cross-platform way is tricky, using psutil if avail or signal)
            # Simplest: Just trust the file for now, or use psutil if installed.
            # Given requirements.txt has psutil:
            import psutil
            if psutil.pid_exists(old_pid):
                return False
            else:
                # Stale lock
                print("⚠️ Found stale lock file. Overwriting.")
        except Exception:
            pass # Error reading file, assume safe to overwrite

    with open(LOCK_FILE, 'w') as f:
        f.write(str(os.getpid()))
    return True

def release_lock():
    if os.path.exists(LOCK_FILE):
        try:
            os.remove(LOCK_FILE)
        except:
            pass

def is_token_fresh():
    """
    Checks if tokens.json was modified TODAY.
    """
    if not os.path.exists(config.TOKENS_FILE):
        return False
        
    timestamp = os.path.getmtime(config.TOKENS_FILE)
    file_date = datetime.datetime.fromtimestamp(timestamp).date()
    today = datetime.datetime.now().date()
    
    return file_date == today

def main():
    print(f"🔒 Checking lock at {LOCK_FILE}...")
    if not acquire_lock():
        print("❌ Another instance is running. Exiting.")
        sys.exit(0)
        
    try:
        start_time = time.time()
        end_time = start_time + (MAX_DURATION_HOURS * 3600)
        
        print(f"🤖 Token Monitor Started. Max Duration: {MAX_DURATION_HOURS}h")
        
        # Initial check immediately? Or wait? 
        # Requirement: 8:30 AM job.
        
        while time.time() < end_time:
            current_time = datetime.datetime.now().strftime("%H:%M:%S")
            
            if is_token_fresh():
                print(f"[{current_time}] ✅ Token is FRESH. Sending success alert and exiting.")
                notifier.send_notification(
                    "✅ System Ready", 
                    "Zerodha Token Generated Successfully. Daily jobs will proceed."
                )
                break
            else:
                print(f"[{current_time}] ⚠️ Token EXPIRED. Sending Alert.")
                notifier.send_notification(
                    "⚠️ Zerodha Login Required", 
                    "Token is outdated. Automatic verification failed.\nPlease login to dashboard to generate new token.", 
                    priority="high"
                )
            
            # Wait for next check
            time.sleep(CHECK_INTERVAL_SEC)
            
        print("🛑 Monitor finished execution.")

    except KeyboardInterrupt:
        print("\nstopped.")
    except Exception as e:
        print(f"🔥 Crashed: {e}")
        notifier.send_notification("Token Monitor Crash", str(e))
    finally:
        release_lock()

if __name__ == "__main__":
    main()
