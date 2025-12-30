import psycopg2
import os
import sys
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def apply_migration():
    conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    try:
        with conn.cursor() as cur:
            print("Applying indices to ref.symbol...")
            
            cur.execute("""
                CREATE INDEX IF NOT EXISTS idx_ref_symbol_trading_symbol 
                ON ref.symbol (trading_symbol);
            """)
            
            cur.execute("""
                CREATE INDEX IF NOT EXISTS idx_ref_symbol_instrument_token 
                ON ref.symbol (instrument_token);
            """)
            
            print("Indices created successfully.")
        conn.commit()
    except Exception as e:
        print(f"Migration Failed: {e}")
        conn.rollback()
        sys.exit(1)
    finally:
        conn.close()

if __name__ == "__main__":
    apply_migration()
