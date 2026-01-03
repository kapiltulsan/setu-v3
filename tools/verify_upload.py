import os
from io import BytesIO
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import process_tradebook_file, get_db_connection

def verify_upload():
    file_path = "ZerodhaTradeBookSample.csv"
    if not os.path.exists(file_path):
        print(f"Error: {file_path} not found.")
        return

    print(f"Processing {file_path}...")
    with open(file_path, "rb") as f:
        # Mock file object for process_tradebook_file
        success, message = process_tradebook_file(f, "kapil_trading", "ZERODHA")
        
    print(f"Success: {success}")
    print(f"Message: {message}")
    
    if success:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM trading.trades")
        count = cur.fetchone()[0]
        print(f"Total rows in trading.trades: {count}")
        conn.close()

if __name__ == "__main__":
    verify_upload()
