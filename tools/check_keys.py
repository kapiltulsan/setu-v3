import os
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_keys():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM trading.trades LIMIT 1")
        row = cur.fetchone()
        if row:
            print("--- KEYS IN TRADES ROW ---")
            for k in row.keys():
                print(k)
        else:
            print("No rows found in trading.trades")
    finally:
        conn.close()

if __name__ == "__main__":
    check_keys()
