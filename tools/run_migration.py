import os
import sys
import psycopg2
# Add parent directory to path to allow importing from modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from modules.charts import get_db_connection
from dotenv import load_dotenv

load_dotenv()

def run_migration(sql_file):
    if not os.path.exists(sql_file):
        print(f"Error: File {sql_file} not found.")
        return

    print(f"Running migration: {sql_file}")
    
    conn = get_db_connection()
    if not conn:
        print("Failed to connect to DB")
        return

    try:
        cur = conn.cursor()
        
        with open(sql_file, 'r') as f:
            sql_content = f.read()
            
        cur.execute(sql_content)
        conn.commit()
        
        print("Migration executed successfully.")
        
    except Exception as e:
        conn.rollback()
        print(f"Migration failed: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python tools/run_migration.py <path_to_sql_file>")
    else:
        run_migration(sys.argv[1])
