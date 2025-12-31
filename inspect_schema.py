
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def inspect_defaults():
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        print(f"{'Table':<20} | {'Column':<20} | {'Default':<20}")
        print("-" * 60)
        
        targets = [
            ('ref', 'symbol', 'is_active'),
            ('ref', 'exchange', 'is_active'),
            ('ref', 'index_source', 'is_active')
        ]
        
        for schema, table, col in targets:
            cur.execute("""
                SELECT column_default 
                FROM information_schema.columns 
                WHERE table_schema = %s AND table_name = %s AND column_name = %s
            """, (schema, table, col))
            res = cur.fetchone()
            default_val = res[0] if res else "N/A"
            print(f"{table:<20} | {col:<20} | {str(default_val):<20}")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    inspect_defaults()
