import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def raw_attribute_check():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT attname, attnum, attnotnull
            FROM pg_attribute 
            WHERE attrelid = 'trading.trades'::regclass
              AND attnum > 0
              AND NOT attisdropped
            ORDER BY attnum
            LIMIT 10
        """)
        rows = cur.fetchall()
        print("Columns: " + ", ".join([f"{r[1]}.{r[0]}({r[2]})" for r in rows]))
    finally:
        conn.close()

if __name__ == "__main__":
    raw_attribute_check()
