
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def apply_migration():
    print(f"Connecting to {DB_NAME} at {DB_HOST} as {DB_USER}...")
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        with open('migrations/012_create_scanner_tables.sql', 'r') as f:
            sql = f.read()
            print("Applying migration...")
            cur.execute(sql)
            conn.commit()
            print("Migration applied successfully.")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    apply_migration()
