import os
import json

# Path to the tokens file (used by auth and data collector)
TOKENS_FILE = "tokens.json"

# Directory for logs
LOG_DIR = "logs"

# Load Portfolio Rules
RULES_FILE = "portfolio_rules.json"

def load_rules():
    if os.path.exists(RULES_FILE):
        with open(RULES_FILE, "r") as f:
            return json.load(f)
    return {}

PORTFOLIO_RULES = load_rules()

def get_operational_accounts():
    """
    Returns a list of operational account configs.
    Yields: (user, account_type, account_id, details)
    """
    accounts = PORTFOLIO_RULES.get("accounts", {})
    for user, user_accounts in accounts.items():
        for acc_type, details in user_accounts.items():
            if details.get("is_operational", False):
                # Account ID convention: user_type (e.g., kapil_trading)
                account_id = f"{user}_{acc_type}"
                yield user, acc_type, account_id, details
