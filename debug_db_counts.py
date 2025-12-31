
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
        
        queries = [
            ("Total Symbols", "SELECT COUNT(*) FROM ref.symbol"),
            ("Active Symbols", "SELECT COUNT(*) FROM ref.symbol WHERE is_active = TRUE"),
            ("Index Mappings", "SELECT COUNT(*) FROM ref.index_mapping"),
            ("Portfolio Items (>0)", "SELECT COUNT(*) FROM trading.portfolio_view WHERE net_quantity > 0"),
            ("Universe Query Count", """
                SELECT COUNT(*)
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
            """)
        ]
        
        print(f"{'Metric':<30} | {'Count':<10}")
        print("-" * 45)
        
        for name, query in queries:
            cur.execute(query)
            count = cur.fetchone()[0]
            print(f"{name:<30} | {count:<10}")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_counts()
