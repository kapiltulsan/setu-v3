import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_inheritance():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        print("--- INHERITANCE CHECK ---")
        cur.execute("""
            SELECT nmsp_parent.nspname AS parent_schema,
                   parent.relname AS parent_table
            FROM pg_inherits
            JOIN pg_class AS child ON child.oid = pg_inherits.inhrelid
            JOIN pg_class AS parent ON parent.oid = pg_inherits.inhparent
            JOIN pg_namespace AS nmsp_child ON nmsp_child.oid = child.relnamespace
            JOIN pg_namespace AS nmsp_parent ON nmsp_parent.oid = parent.relnamespace
            WHERE child.relname = 'trades' AND nmsp_child.nspname = 'trading'
        """)
        res = cur.fetchall()
        if res:
            for r in res:
                print(f"Inherits from: {r[0]}.{r[1]}")
        else:
            print("No inheritance found.")
    finally:
        conn.close()

if __name__ == "__main__":
    check_inheritance()
