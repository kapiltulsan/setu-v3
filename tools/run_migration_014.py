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
    
    with open("migrations/014_fix_trades_schema.sql", "r") as f:
        sql = f.read()
        cur.execute(sql)
        conn.commit()
        print("Migration 014 applied successfully.")
        
except Exception as e:
    print(f"ERROR: {e}")
finally:
    if 'conn' in locals() and conn:
        conn.close()
