import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_constraints():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT conname, pg_get_constraintdef(oid)
            FROM pg_constraint
            WHERE conrelid = 'trading.trades'::regclass
        """)
        for row in cur.fetchall():
            print(f"NAME: {row[0]}")
            print(f"DEF: {row[1]}")
            print("-" * 20)
    finally:
        conn.close()

if __name__ == "__main__":
    check_constraints()
