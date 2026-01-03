import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_public():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT column_name, ordinal_position, is_nullable
            FROM information_schema.columns 
            WHERE table_schema = 'public' AND table_name = 'trades'
            ORDER BY ordinal_position
        """)
        rows = cur.fetchall()
        if rows:
            print("--- COLUMNS IN public.trades ---")
            for row in rows:
                print(f"{row[1]}. {row[0]} (Nullable: {row[2]})")
        else:
            print("No table 'trades' in public schema.")
    finally:
        conn.close()

if __name__ == "__main__":
    check_public()
