
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

try:
    conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    print("--- Scheduled Jobs in DB ---")
    cur.execute("SELECT id, name, schedule_cron, is_enabled, command FROM sys.scheduled_jobs")
    jobs = cur.fetchall()
    
    for job in jobs:
        status = "ENABLED" if job['is_enabled'] else "DISABLED"
        print(f"[{status}] {job['name']} ({job['schedule_cron']}) -> {job['command']}")
        
    conn.close()
except Exception as e:
    print(f"Error: {e}")
