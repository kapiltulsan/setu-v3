import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def inspect():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_schema = 'trading' 
              AND table_name = 'trades'
            ORDER BY ordinal_position
        """)
        for row in cur.fetchall():
            print(row[0])
    finally:
        conn.close()

if __name__ == "__main__":
    inspect()
