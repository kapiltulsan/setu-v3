import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_description():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM trading.trades LIMIT 0")
        colnames = [desc[0] for desc in cur.description]
        print("--- COLUMNS VIA CURSOR.DESCRIPTION ---")
        for i, name in enumerate(colnames):
            print(f"{i+1}. {name}")
    finally:
        conn.close()

if __name__ == "__main__":
    check_description()
