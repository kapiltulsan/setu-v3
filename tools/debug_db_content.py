import os
import psycopg2
from dotenv import load_dotenv
import sys

load_dotenv()

def flush():
    sys.stdout.flush()

try:
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS")
    )
    cur = conn.cursor()
    print(f"DEBUG: Connected to {os.getenv('DB_NAME')}")
    flush()

    print("--- 1. TRADES COUNT ---")
    flush()
    cur.execute('SELECT count(*) FROM "trading"."trades"')
    print(cur.fetchone())
    flush()

    print("\n--- 2. PORTFOLIO ACCOUNT SUMMARY ---")
    flush()
    cur.execute("SELECT account_id, date, count(*) FROM trading.portfolio GROUP BY account_id, date")
    rows = cur.fetchall()
    if not rows:
        print("No rows in trading.portfolio!")
        flush()
    else:
        for r in rows:
            print(r)
            flush()

    print("\n--- 3. PORTFOLIO SAMPLE ---")
    cur.execute("SELECT * FROM trading.portfolio LIMIT 5")
    for p in cur.fetchall():
        print(p)

except Exception as e:
    print(f"ERROR: {e}")
finally:
    if 'conn' in locals() and conn:
        conn.close()
