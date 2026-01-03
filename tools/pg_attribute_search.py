import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def pg_attribute_search():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT n.nspname, c.relname, a.attname
            FROM pg_attribute a
            JOIN pg_class c ON a.attrelid = c.oid
            JOIN pg_namespace n ON c.relnamespace = n.oid
            WHERE a.attname = 'transaction_type'
              AND a.attnum > 0
              AND NOT a.attisdropped
        """)
        for row in cur.fetchall():
            print(f"Found in {row[0]}.{row[1]}")
    finally:
        conn.close()

if __name__ == "__main__":
    pg_attribute_search()
