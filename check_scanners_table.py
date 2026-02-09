
import os
import psycopg2
from dotenv import load_dotenv
import sys

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def check_table():
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        # Query columns for sys.scanners
        cur.execute("""
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_schema = 'sys' AND table_name = 'scanners';
        """)
        
        columns = cur.fetchall()
        print(f"Columns in sys.scanners ({len(columns)}):")
        for col in columns:
            print(f" - {col[0]} ({col[1]})")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_table()
