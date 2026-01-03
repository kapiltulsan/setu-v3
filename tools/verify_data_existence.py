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
    cur.execute('SELECT count(*) FROM "trading"."trades"')
    count = cur.fetchone()[0]
    
    with open("data_status.txt", "w") as f:
        if count > 0:
            f.write(f"EXISTS: {count}")
        else:
            f.write("EMPTY")
            
except Exception as e:
    with open("data_status.txt", "w") as f:
        f.write(f"ERROR: {e}")
finally:
    if 'conn' in locals() and conn:
        conn.close()
