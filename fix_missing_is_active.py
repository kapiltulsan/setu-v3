
import os
import psycopg2
from dotenv import load_dotenv
import sys

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def fix_table():
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        print("Adding is_active column to sys.scanners...")
        cur.execute("""
            ALTER TABLE sys.scanners ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;
        """)
        
        conn.commit()
        print("Column added successfully.")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fix_table()
