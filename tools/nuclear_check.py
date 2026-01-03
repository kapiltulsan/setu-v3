import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def nuclear_check():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT table_schema, table_name, column_name 
            FROM information_schema.columns 
            WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
            ORDER BY table_schema, table_name, ordinal_position
        """)
        with open("tools/nuclear_output.txt", "w") as f:
            for row in cur.fetchall():
                f.write(f"{row[0]}.{row[1]} | {row[2]}\n")
        print("Done. Saved to tools/nuclear_output.txt")
    finally:
        conn.close()

if __name__ == "__main__":
    nuclear_check()
