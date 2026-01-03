import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def find_all_trades():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT table_schema, table_name, column_name, ordinal_position, is_nullable
            FROM information_schema.columns 
            WHERE table_name = 'trades'
            ORDER BY table_schema, ordinal_position
        """)
        for row in cur.fetchall():
            print(f"{row[0]}.{row[1]} | {row[3]}. {row[2]} (Nullable: {row[4]})")
    finally:
        conn.close()

if __name__ == "__main__":
    find_all_trades()
