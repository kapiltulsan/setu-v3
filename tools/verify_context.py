import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def verify_context():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("SELECT current_database(), current_schema(), current_user")
        res = cur.fetchone()
        print(f"Database: {res[0]}")
        print(f"Schema: {res[1]}")
        print(f"User: {res[2]}")
        
        cur.execute("SHOW search_path")
        print(f"Search Path: {cur.fetchone()[0]}")
    finally:
        conn.close()

if __name__ == "__main__":
    verify_context()
