
import os
import sys
import pandas as pd
from dotenv import load_dotenv

# Add current dir to path to find modules
sys.path.append(os.getcwd())

load_dotenv()

try:
    from modules.scanner_engine import fetch_data_for_symbol
except ImportError as e:
    print(f"Import Error: {e}")
    sys.exit(1)

# Fetch data for NIFTY 50 to check columns
try:
    with open("debug_results.txt", "w") as f:
        f.write("--- Checking DataFrame Columns for 'NIFTY 50' ---\n")
        df = fetch_data_for_symbol('NIFTY 50', limit=5)
        if df is not None:
            f.write(f"Columns: {df.columns.tolist()}\n")
            # Convert decimal objects to float for printing if needed, or just print dict
            f.write(f"First Row: {df.iloc[0].to_dict()}\n")
            
            # Check types
            f.write("Types:\n")
            for col, dtype in df.dtypes.items():
                f.write(f"{col}: {dtype}\n")
        else:
            f.write("DataFrame is None!\n")
except Exception as e:
    with open("debug_results.txt", "w") as f:
        f.write(f"Error: {e}\n")
