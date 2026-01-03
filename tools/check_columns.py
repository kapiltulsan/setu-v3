import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

try:
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS")
    )
    cur = conn.cursor()
    
    print("--- 1. COLUMNS IN trading.trades ---")
    cur.execute("""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_schema = 'trading' AND table_name = 'trades'
    """)
    for r in cur.fetchall():
        print(r)
        
except Exception as e:
    print(f"ERROR: {e}")
finally:
    if 'conn' in locals() and conn:
        conn.close()
