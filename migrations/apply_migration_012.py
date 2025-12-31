import os
import psycopg2
from dotenv import load_dotenv

# Force load .env from project root
dotenv_path = os.path.join(os.path.dirname(__file__), '..', '.env')
load_dotenv(dotenv_path)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def read_sql_file(filepath):
    with open(filepath, 'r') as f:
        return f.read()

def apply_migration():
    try:
        if not DB_PASS:
            print("❌ DB_PASS is missing in .env")
            return

        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        
        print("🚀 Applying Migration 012: Create Scanner tables...")
        
        migration_file = os.path.join(os.path.dirname(__file__), '012_create_scanner_tables.sql')
        sql_content = read_sql_file(migration_file)
        
        cur.execute(sql_content)
            
        conn.commit()
        print("✅ Migration Successful! Tables 'sys.scanners' and 'trading.scanner_results' created.")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Migration Failed: {e}")

if __name__ == "__main__":
    apply_migration()
