import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def search():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT table_schema, table_name, column_name, is_nullable
            FROM information_schema.columns 
            WHERE column_name = 'transaction_type'
        """)
        for row in cur.fetchall():
            print(row)
    finally:
        conn.close()

if __name__ == "__main__":
    search()
