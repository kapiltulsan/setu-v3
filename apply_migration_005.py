import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def apply_migration():
    conn = None
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        with open('migrations/005_scheduler_tables.sql', 'r') as f:
            sql = f.read()
            
        print("Executing Migration 005 (Scheduler Tables)...")
        cur.execute(sql)
        conn.commit()
        print("✅ Migration Applied Successfully.")
        
    except Exception as e:
        print(f"❌ Migration Failed: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    apply_migration()
