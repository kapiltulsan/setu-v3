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
            SELECT column_name, is_nullable, column_default 
            FROM information_schema.columns 
            WHERE table_schema = 'trading' AND table_name = 'trades' AND is_nullable = 'NO'
        """)
        for row in cur.fetchall():
            print(f"{row[0]}: {row[1]}, Default: {row[2]}")
    finally:
        conn.close()

if __name__ == "__main__":
    check()
