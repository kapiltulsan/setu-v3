import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")
DB_PORT = os.getenv("DB_PORT", "5432")

def apply_migration():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            port=DB_PORT
        )
        cur = conn.cursor()
        
        with open("migrations/013_add_account_id.sql", "r") as f:
            sql = f.read()
            
        print("Applying Migration 013...")
        cur.execute(sql)
        conn.commit()
        print("✅ Migration 013 (Account ID) applied successfully!")
        
    except Exception as e:
        print(f"❌ Migration Failed: {e}")
    finally:
        if 'conn' in locals() and conn:
            conn.close()

if __name__ == "__main__":
    apply_migration()
