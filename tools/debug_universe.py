import os
import sys
import psycopg2
from dotenv import load_dotenv

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def analyze_universe():
    with open("debug_report.txt", "w", encoding="utf-8") as f:
        def log(msg):
            print(msg)
            f.write(msg + "\n")

        log("Analyzing Symbol Universe...\n")
        load_dotenv()
        
        try:
            conn = psycopg2.connect(
                host=os.getenv("DB_HOST", "localhost"),
                database=os.getenv("DB_NAME"),
                user=os.getenv("DB_USER"),
                password=os.getenv("DB_PASS")
            )
            
            with conn.cursor() as cur:
                # 1. Total Universe Count (The number data_collector sees)
                cur.execute("""
                    SELECT COUNT(DISTINCT s.trading_symbol)
                    FROM ref.symbol s
                    WHERE s.is_active = TRUE
                    AND (
                        EXISTS (SELECT 1 FROM ref.index_mapping ic WHERE ic.stock_symbol = s.trading_symbol)
                        OR EXISTS (SELECT 1 FROM trading.portfolio p WHERE p.symbol = s.trading_symbol)
                        OR EXISTS (SELECT 1 FROM trading.positions pos WHERE pos.symbol = s.trading_symbol)
                    )
                """)
                total_filtered = cur.fetchone()[0]
                log(f"Total Symbols in Data Collection Queue: {total_filtered}")
                
                log("\n--- Breakdown by Index ---")
                cur.execute("""
                    SELECT index_name, COUNT(*) 
                    FROM ref.index_mapping 
                    GROUP BY index_name 
                    ORDER BY count(*), index_name DESC
                """)
                indices = cur.fetchall()
                for idx, count in indices:
                    log(f"   - {idx}: {count} symbols")
                    
                # Overlap check
                cur.execute("SELECT COUNT(DISTINCT stock_symbol) FROM ref.index_mapping")
                unique_index_symbols = cur.fetchone()[0]
                log(f"\nUnique Index Constituents: {unique_index_symbols}")
                
                # Portfolio check
                cur.execute("SELECT COUNT(DISTINCT symbol) FROM trading.portfolio")
                port_count = cur.fetchone()[0]
                log(f"Portfolio Holdings: {port_count}")

                log(f"\nNOTE: Indices like Nifty 500 or Microcap 250 add significant volume.")

        except Exception as e:
            log(f"Error: {e}")
        
if __name__ == "__main__":
    analyze_universe()
