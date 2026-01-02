import os
import sys
from dotenv import load_dotenv

# Add parent dir to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import config

def verify_env_keys():
    # Redirect output to file manually
    with open("verify_report.txt", "w", encoding="utf-8") as report:
        def log(msg):
            print(msg)
            report.write(msg + "\n")

        log("📋 Verifying Environment Variables for API Keys...\n")
        load_dotenv()
        
        rules = config.PORTFOLIO_RULES
        accounts = rules.get("accounts", {})
        
        all_good = True
        
        # Iterate all accounts
        for user, user_accounts in accounts.items():
            for acc_type, details in user_accounts.items():
                cred_id = details.get("credential_id")
                is_op = details.get("is_operational", False)
                
                if not cred_id:
                    continue
                    
                # Only strictly check OPERATIONAL accounts. Optional check for others.
                prefix = "🟢" if is_op else "⚪"
                log(f"[{prefix}] Checking {cred_id} ({user}/{acc_type})...")
                
                # Check Keys
                key_var = f"{cred_id}_API_KEY"
                secret_var = f"{cred_id}_API_SECRET"
                
                key_val = os.getenv(key_var)
                secret_val = os.getenv(secret_var)
                
                status = []
                missing_critical = False
                
                if not key_val:
                    status.append(f"❌ Missing {key_var}")
                    if is_op: missing_critical = True
                else:
                     masked = key_val[:4] + "*" * 4 if len(key_val) > 4 else "****"
                     status.append(f"✅ Found {key_var}")

                if not secret_val:
                    status.append(f"❌ Missing {secret_var}")
                    if is_op: missing_critical = True
                else:
                    status.append(f"✅ Found {secret_var}")
                
                 
                log(f"   {' | '.join(status)}")
                
                if missing_critical:
                    all_good = False

        log("\n---------------------------------------------------")
        if all_good:
            log("✅ All OPERATIONAL configurations look correct!")
        else:
            log("⚠️ Some OPERATIONAL API Keys are missing!")

if __name__ == "__main__":
    verify_env_keys()
