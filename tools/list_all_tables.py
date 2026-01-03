import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def list_all_tables():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT n.nspname, c.relname
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind = 'r'
              AND n.nspname NOT IN ('information_schema', 'pg_catalog')
            ORDER BY n.nspname, c.relname
        """)
        for row in cur.fetchall():
            print(f"{row[0]}.{row[1]}")
    finally:
        conn.close()

if __name__ == "__main__":
    list_all_tables()
