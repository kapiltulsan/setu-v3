
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def fix_active_status():
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        print("Activating all symbols found in Index Mapping...")
        
        query = """
            UPDATE ref.symbol
            SET is_active = TRUE, updated_at = NOW()
            WHERE trading_symbol IN (SELECT DISTINCT stock_symbol FROM ref.index_mapping)
              AND is_active = FALSE;
        """
        
        cur.execute(query)
        updated_count = cur.rowcount
        conn.commit()
        
        print(f"✅ Activated {updated_count} symbols.")
        
        # Verify
        cur.execute("""
            SELECT COUNT(*) 
            FROM ref.symbol s 
            WHERE s.is_active = TRUE 
            AND s.trading_symbol IN (SELECT stock_symbol FROM ref.index_mapping)
        """)
        print(f"Active Index Constituents now: {cur.fetchone()[0]}")
        
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fix_active_status()
