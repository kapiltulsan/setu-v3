
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()
conn = psycopg2.connect(host=os.getenv('DB_HOST'), database=os.getenv('DB_NAME'), user=os.getenv('DB_USER'), password=os.getenv('DB_PASS'))
cur = conn.cursor()

def add_column_if_not_exists(table, column, type_def):
    try:
        cur.execute(f"ALTER TABLE {table} ADD COLUMN {column} {type_def}")
        conn.commit()
        print(f"Added column {column} to {table}")
    except psycopg2.errors.DuplicateColumn:
        conn.rollback()
        print(f"Column {column} already exists in {table}")
    except Exception as e:
        conn.rollback()
        print(f"Error adding {column}: {e}")

print("Fixing sys.job_history schema...")
add_column_if_not_exists("sys.job_history", "log_path", "TEXT")
add_column_if_not_exists("sys.job_history", "duration_seconds", "NUMERIC(10, 2)")
add_column_if_not_exists("sys.job_history", "exit_message", "TEXT")

conn.close()
