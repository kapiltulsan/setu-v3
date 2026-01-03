import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_partitions():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        print("--- PARTITION CHECK ---")
        cur.execute("""
            SELECT nmsp_parent.nspname AS parent_schema,
                   parent.relname AS parent_table,
                   nmsp_child.nspname AS child_schema,
                   child.relname AS child_table
            FROM pg_inherits
            JOIN pg_class AS child ON child.oid = pg_inherits.inhrelid
            JOIN pg_class AS parent ON parent.oid = pg_inherits.inhparent
            JOIN pg_namespace AS nmsp_child ON nmsp_child.oid = child.relnamespace
            JOIN pg_namespace AS nmsp_parent ON nmsp_parent.oid = parent.relnamespace
            WHERE parent.relname = 'trades' AND nmsp_parent.nspname = 'trading'
        """)
        res = cur.fetchall()
        if res:
            for r in res:
                print(f"Has partition: {r[2]}.{r[3]}")
                # Inspect child columns
                cur.execute(f"SELECT column_name FROM information_schema.columns WHERE table_schema='{r[2]}' AND table_name='{r[3]}'")
                cols = [c[0] for c in cur.fetchall()]
                print(f"  Columns: {cols}")
        else:
            print("No partitions found.")
    finally:
        conn.close()

if __name__ == "__main__":
    check_partitions()
