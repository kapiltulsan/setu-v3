
import os
import sys
import psycopg2
from dotenv import load_dotenv

# Add root dir to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Load env
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), '.env'))

from modules.scanner_engine import fetch_universe_symbols
from modules.scanners import get_db_connection

def debug_db():
    print("Checking DB Connection and Schema...")
    conn = get_db_connection()
    if not conn:
        print("DB Connection Failed!")
        return

    try:
        with conn.cursor() as cur:
            # Check table existence
            cur.execute("SELECT to_regclass('ref.index_mapping');")
            exists = cur.fetchone()[0]
            print(f"Table 'ref.index_mapping' exists: {exists}")
            
            if exists:
                 # Check sample data
                 cur.execute("SELECT index_name, COUNT(*) FROM ref.index_mapping GROUP BY index_name LIMIT 5;")
                 rows = cur.fetchall()
                 print("Sample Index Counts:")
                 for r in rows:
                     print(f" - {r[0]}: {r[1]}")
    except Exception as e:
        print(f"Schema Check Error: {e}")
    finally:
        conn.close()

def debug_fetch():
    print("\nTesting fetch_universe_symbols(['NIFTY 50'])...")
    try:
        res = fetch_universe_symbols(['NIFTY 50'])
        print(f"Result count: {len(res)}")
        print(f"Result sample: {res[:5]}")
    except Exception as e:
        print(f"Fetch Error: {e}")

if __name__ == "__main__":
    debug_db()
    debug_fetch()
