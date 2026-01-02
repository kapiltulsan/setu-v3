import psycopg2
import os
import sys
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

try:
    conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    cur = conn.cursor()
    
    print("Checking for Indices in OHLC Daily...")
    # Check for common indices
    indices = ["NIFTY 50", "NIFTY BANK", "NIFTY IT"]
    found = []
    
    for idx in indices:
        cur.execute("SELECT COUNT(*) FROM trading.ohlc_daily WHERE symbol = %s", (idx,))
        count = cur.fetchone()[0]
        if count > 0:
            found.append(f"{idx} ({count} rows)")
            
    print(f"Found Indices in OHLC: {found}")
    
    if not found:
        print("No indices found directly in ohLc_daily. Checking sample symbols...")
        cur.execute("SELECT DISTINCT symbol FROM trading.ohlc_daily LIMIT 10")
        print(cur.fetchall())
        
    conn.close()
except Exception as e:
    print(f"Error: {e}")
