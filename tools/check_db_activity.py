import os
import sys
import psycopg2
from dotenv import load_dotenv

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def check_activity():
    print("🔎 Checking Database Activity for Today...")
    load_dotenv()
    
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS")
        )
        
        with conn.cursor() as cur:
            # Check 1D Candles updated today
            cur.execute("""
                SELECT COUNT(*), MAX(created_at) 
                FROM ohlc.candles_1d 
                WHERE created_at > CURRENT_DATE
                -- Note: 'created_at' might be the timestamp of insertion
                -- depending on schema. If it's the candle time, we should filter by candle_start
            """)
            res = cur.fetchone()
            count_1d = res[0]
            last_1d = res[1]
            
            # Check last 5 inserted symbols
            cur.execute("""
                SELECT symbol, MAX(created_at) as last_upd 
                FROM ohlc.candles_1d 
                WHERE created_at > CURRENT_DATE 
                GROUP BY symbol 
                ORDER BY last_upd DESC 
                LIMIT 5
            """)
            recent = cur.fetchall()
            
            print(f"📊 Rows Updated Today (1D): {count_1d}")
            print(f"🕒 Last Update: {last_1d}")
            if recent:
                print("🔹 Recently Processed Symbols:")
                for r in recent:
                    print(f"   - {r[0]} at {r[1]}")
            else:
                print("⚠️ No updates found for today yet.")

    except Exception as e:
        print(f"❌ Error checking DB: {e}")
        
if __name__ == "__main__":
    check_activity()
