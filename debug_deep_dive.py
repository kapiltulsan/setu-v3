
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def check_counts():
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        
        # 1. Distinct Universe Count
        universe_query = """
            SELECT DISTINCT s.trading_symbol
            FROM ref.symbol s
            LEFT JOIN ref.index_mapping m_stock ON s.trading_symbol = m_stock.stock_symbol
            LEFT JOIN ref.index_mapping m_index ON s.trading_symbol = m_index.index_name
            LEFT JOIN trading.portfolio_view p ON s.trading_symbol = p.symbol
            WHERE s.is_active = TRUE
              AND (
                  (s.segment = 'INDICES' AND m_index.index_name IS NOT NULL)
                  OR 
                  (s.segment <> 'INDICES' AND m_stock.stock_symbol IS NOT NULL)
                  OR 
                  (p.net_quantity > 0)
              )
        """
        cur.execute(universe_query)
        universe = [r[0] for r in cur.fetchall()]
        print(f"Total Unique Universe Size: {len(universe)}")
        print(f"Sample Symbols: {universe[:10]}")
        
        # 2. Breakdown
        print("\n--- Breakdown ---")
        
        cur.execute("SELECT COUNT(*) FROM ref.symbol WHERE is_active = TRUE")
        print(f"Active Symbols: {cur.fetchone()[0]}")
        
        cur.execute("SELECT COUNT(DISTINCT stock_symbol) FROM ref.index_mapping")
        print(f"Unique Stocks in Index Mapping: {cur.fetchone()[0]}")
        
        cur.execute("""
            SELECT COUNT(*) 
            FROM ref.symbol s 
            WHERE s.is_active = TRUE 
            AND s.trading_symbol IN (SELECT stock_symbol FROM ref.index_mapping)
        """)
        print(f"Active Symbols that are in Index Mapping: {cur.fetchone()[0]}")
        
        cur.execute("""
            SELECT COUNT(*) 
            FROM ref.symbol s 
            WHERE s.is_active = TRUE 
            AND s.segment = 'INDICES'
        """)
        print(f"Active Indices: {cur.fetchone()[0]}")

        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_counts()
