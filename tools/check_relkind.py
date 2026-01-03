import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_relkind():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT c.relname, c.relkind, n.nspname
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE n.nspname IN ('trading', 'public', 'sys')
              AND c.relname = 'trades'
        """)
        for row in cur.fetchall():
            # r = table, v = view, m = materialized view, f = foreign table
            print(f"Object: {row[2]}.{row[0]}, Kind: {row[1]}")
    finally:
        conn.close()

if __name__ == "__main__":
    check_relkind()
