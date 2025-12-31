
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "setu")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS")

def check_db():
    try:
        if not DB_PASS:
            print("❌ DB_PASS not found in .env")
            return

        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()

        with open("db_report.txt", "w", encoding="utf-8") as f:
            f.write(f"✅ Connected to {DB_NAME} on {DB_HOST}\n")
            
            # 1. Check Schemas
            f.write("\n--- Schemas ---\n")
            cur.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('sys', 'trading', 'ohlc', 'ref');")
            schemas = [row[0] for row in cur.fetchall()]
            f.write(f"Found schemas: {schemas}\n")

            # 2. Check Tables
            f.write("\n--- Tables ---\n")
            tables_to_check = [
                ('trading', 'trades'),
                ('trading', 'portfolio'),
                ('trading', 'orders'),
                ('trading', 'positions'),
                ('sys', 'job_history'),
                ('sys', 'scheduled_jobs'),
                ('ohlc', 'candles_60m')
            ]
            
            for schema, table in tables_to_check:
                cur.execute("SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = %s AND table_name = %s);", (schema, table))
                result = cur.fetchone()
                exists = result[0] if result else False
                status = "✅" if exists else "❌"
                f.write(f"{status} {schema}.{table}\n")

            # 3. Deep Dive into sys.job_history
            f.write("\n--- Checking sys.job_history Structure ---\n")
            cur.execute("SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'sys' AND table_name = 'job_history');")
            if cur.fetchone()[0]:
                cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema = 'sys' AND table_name = 'job_history';")
                cols = cur.fetchall()
                col_names = [c[0] for c in cols]
                f.write(f"Columns: {col_names}\n")
                
                if 'job_name' in col_names:
                    f.write("   ⚠️  Matches 002 (Old style)\n")
                if 'job_id' in col_names:
                    f.write("   ✅ Matches 005 (New style)\n")
                if 'pid' in col_names:
                    f.write("   ✅ Matches 011 (Has PID tracking)\n")
            else:
                f.write("❌ sys.job_history does not exist.\n")

        cur.close()
        conn.close()

    except Exception as e:
        print(f"❌ Connection Failed: {e}")

if __name__ == "__main__":
    check_db()
