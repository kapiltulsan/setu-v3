import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT conname, pg_get_constraintdef(oid)
            FROM pg_constraint
            WHERE conrelid = 'trading.trades'::regclass
              AND pg_get_constraintdef(oid) LIKE '%transaction_type%'
        """)
        for row in cur.fetchall():
            print(f"CONSTRAINT: {row[0]}")
            print(f"DEF: {row[1]}")
    finally:
        conn.close()

if __name__ == "__main__":
    check()
