import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    database=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASS")
)
cur = conn.cursor()

print("--- Trading Trades Account IDs ---")
cur.execute("SELECT account_id, COUNT(*) FROM trading.trades GROUP BY account_id")
rows = cur.fetchall()
for r in rows:
    print(r)

print("\n--- Trading Portfolio Account IDs ---")
cur.execute("SELECT account_id, COUNT(*) FROM trading.portfolio GROUP BY account_id")
rows = cur.fetchall()
for r in rows:
    print(r)

conn.close()
