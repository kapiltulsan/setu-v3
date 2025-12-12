import os
import sys
# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import psycopg2
from modules.charts import get_db_connection

def migrate():
    conn = get_db_connection()
    if not conn:
        print("Failed to connect to DB")
        return

    conn.autocommit = True
    cur = conn.cursor()

    try:
        print("1. Enabling TimescaleDB extension...")
        cur.execute("CREATE EXTENSION IF NOT EXISTS timescaledb;")
        print("   Extension enabled.")
    except Exception as e:
        print(f"   Error enabling extension: {e}")
        # Continue? If extension fails, hypertables will fail.
        return

    tables = ['ohlc.candles_1d', 'ohlc.candles_60m']
    
    for table in tables:
        try:
            print(f"2. Converting {table} to hypertable...")
            # migrate_data=True is default for create_hypertable but good to be explicit if table has data
            # if_not_exists=True allows re-running safely
            query = f"SELECT create_hypertable('{table}', 'candle_start', if_not_exists => TRUE, migrate_data => TRUE);"
            cur.execute(query)
            print(f"   {table} converted successfully.")
        except Exception as e:
            print(f"   Error converting {table}: {e}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    migrate()
