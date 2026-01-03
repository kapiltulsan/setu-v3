import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

try:
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS")
    )
    cur = conn.cursor()
    cur.execute("SELECT provider, csv_column, db_column FROM sys.csv_mappings ORDER BY provider, db_column")
    print(f"{'PROVIDER':<10} | {'CSV_COL':<15} | {'DB_COL':<15}")
    print("-" * 45)
    for row in cur.fetchall():
        print(f"{row[0]:<10} | {row[1]:<15} | {row[2]:<15}")
        
except Exception as e:
    print(f"ERROR: {e}")
finally:
    if 'conn' in locals() and conn:
        conn.close()
