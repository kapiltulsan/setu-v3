import os
import sys
import psycopg2
from datetime import datetime
from dotenv import load_dotenv

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

load_dotenv()

def get_db_connection():
    try:
        return psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS")
        )
    except Exception as e:
        print(f"DB Connection Failed: {e}")
        return None

def check_history():
    conn = get_db_connection()
    if not conn:
        return

    try:
        cur = conn.cursor()
        query = """
            SELECT id, job_name, start_time, end_time, status, output_summary 
            FROM sys.job_history 
            ORDER BY start_time DESC 
            LIMIT 20
        """
        cur.execute(query)
        rows = cur.fetchall()
        
        print(f"{'ID':<5} | {'Job Name':<25} | {'Start Time':<25} | {'End Time':<25} | {'Status':<10} | {'Summary'}")
        print("-" * 130)
        
        for row in rows:
            id, job_name, start, end, status, summary = row
            summary_short = (summary[:50] + '...') if summary and len(summary) > 50 else summary
            
            # calculate duration if possible
            duration = ""
            if start and end:
                try:
                    delta = end - start
                    duration = f" ({delta.total_seconds():.1f}s)"
                except: pass

            print(f"{id:<5} | {job_name:<25} | {str(start):<25} | {str(end):<25} | {str(status):<10} | {summary_short}{duration}")
            
    except Exception as e:
        print(f"Query Failed: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    check_history()
