import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()

def find_db():
    # Try to connect to postgres to list all dbs
    try:
        conn = psycopg2.connect(host="localhost", user="postgres", password="P@ss2025", dbname="postgres")
        cur = conn.cursor()
        cur.execute("SELECT datname FROM pg_database WHERE datistemplate = false")
        dbs = [r[0] for r in cur.fetchall()]
        print("--- DISCOVERED DATABASES ---")
        for db in dbs:
            print(f"DB: {db}")
        
        for db in dbs:
            try:
                # print(f"\nChecking DB: {db}")
                db_conn = psycopg2.connect(host="localhost", user="postgres", password="P@ss2025", dbname=db)
                db_cur = db_conn.cursor()
                db_cur.execute("""
                    SELECT table_schema, table_name, column_name 
                    FROM information_schema.columns 
                    WHERE column_name = 'transaction_type' AND table_name = 'trades'
                """)
                res = db_cur.fetchall()
                if res:
                    print(f"FOUND 'transaction_type' in trades table in DATABASE: {db}")
                    for r in res:
                        print(f" - Schema: {r[0]}")
                db_conn.close()
            except:
                pass
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    find_db()
