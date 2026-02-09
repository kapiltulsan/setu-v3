import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

def check_indices():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        port=os.getenv("DB_PORT", "5432")
    )
    try:
        with conn.cursor() as cur:
            print("--- Tracked Indices (ref.index_source) ---")
            cur.execute("SELECT index_name, is_active FROM ref.index_source")
            indices = cur.fetchall()
            for idx, active in indices:
                print(f"Index: {idx}, Active: {active}")
            
            print("\n--- OHLC Data Availability (ohlc.candles_1d) ---")
            index_names = [idx[0] for idx in indices]
            if index_names:
                cur.execute("""
                    SELECT symbol, COUNT(*), MAX(candle_start) 
                    FROM ohlc.candles_1d 
                    WHERE symbol IN %s 
                    GROUP BY symbol
                """, (tuple(index_names),))
                stats = cur.fetchall()
                for sym, count, last in stats:
                    print(f"Symbol: {sym}, Records: {count}, Last Candle: {last}")
            else:
                print("No indices found in ref.index_source")
                
    finally:
        conn.close()

if __name__ == "__main__":
    check_indices()
