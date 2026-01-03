import os
import sys
import psycopg2
from dotenv import load_dotenv

load_dotenv()

# Add parent dir to path to import modules
sys.path.append(os.getcwd())
try:
    from modules.portfolio.logic import calculate_portfolio
except ImportError:
    print("Could not import logic. Ensure you run from project root.")
    sys.exit(1)

conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    database=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASS")
)
cur = conn.cursor()

print("--- FIXING ACCOUNT IDs ---")

# 1. Update Trades
cur.execute("""
    UPDATE trading.trades 
    SET account_id = 'KOM_ZERODHA_PASSIVE' 
    WHERE account_id IS NULL OR account_id = 'default' OR account_id = 'default_account'
""")
print(f"Updated {cur.rowcount} trades to 'KOM_ZERODHA_PASSIVE'.")

conn.commit()
conn.close()

# 2. Recalculate Portfolio
print("\n--- Recalculating Portfolio ---")
success, msg = calculate_portfolio()
print(f"Result: {success} - {msg}")
