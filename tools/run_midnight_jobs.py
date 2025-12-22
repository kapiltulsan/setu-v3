import os
import sys
import time
import subprocess
from dotenv import load_dotenv

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

load_dotenv()

def run_step(script_name, args=[]):
    """Runs a script as a subprocess and logs output."""
    full_job_name = f"{script_name} {' '.join(args)}".strip()
    print(f"\n--- Starting Step: {full_job_name} ---")
    
    start_ts = time.time()
    
    try:
        # Construct command: python tools/script.py or python script.py
        if os.path.exists(os.path.join("tools", script_name)):
            cmd = [sys.executable, os.path.join("tools", script_name)] + args
        elif os.path.exists(script_name):
            cmd = [sys.executable, script_name] + args
        else:
            print(f"❌ Script {script_name} not found")
            return False

        # Run process - Inherit stdout/stderr so they go to the Scheduler's log file
        result = subprocess.run(
            cmd, 
            check=False 
        )
        
        duration = time.time() - start_ts
        if result.returncode == 0:
            print(f"✅ Finished: {full_job_name} ({duration:.2f}s)")
            return True
        else:
            print(f"❌ Failed: {full_job_name} (Exit Code: {result.returncode})")
            return False

    except Exception as e:
        print(f"❌ Critical Error in step {full_job_name}: {e}")
        return False

def main():
    print("🚀 Midnight Jobs Batch Started")
    start_time = time.time()
    
    steps = [
        ("sync_master.py", []),                  # 1. Update Symbols (Master Data)
        ("sync_constituents.py", []),            # 2. Update Index Mappings
        ("data_collector.py", ["day"]),          # 3. Daily OHLC
        # Note: 60minute is usually handled by hourly scheduler, but we run it once at midnight too to be sure?
        # User config: data_collector.py ["60minute"]
        ("data_collector.py", ["60minute"])      
    ]
    
    all_success = True
    
    for script, args in steps:
        success = run_step(script, args)
        if not success:
            all_success = False
            print(f"⚠️ Warning: Step {script} failed. Continuing...")

    total_duration = time.time() - start_time
    if all_success:
        print(f"\n✅ All Midnight Jobs Finished Successfully ({total_duration:.2f}s)")
        sys.exit(0)
    else:
        print(f"\n❌ Midnight Jobs Finished with Errors ({total_duration:.2f}s)")
        sys.exit(1)

if __name__ == "__main__":
    main()
