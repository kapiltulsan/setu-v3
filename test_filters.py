
import json
import os
import sys
from dotenv import load_dotenv

load_dotenv()

# Add project root to path
sys.path.append(os.getcwd())

from modules.scanner_engine import execute_scan_logic

# Define Test Case: 
# Filter: Close > 10000 (Should match NIFTY 50 ~26k)
logic_good = {
    "universe": ["NIFTY 50"],
    "universe_filters": [
        {"indicator": "close", "operator": ">", "value": 10000, "timeframe": "1d"}
    ],
    "primary_filter": [],
    "refiner": []
}

# Filter: Close > 30000 (Should NOT match NIFTY 50 ~26k)
logic_bad = {
    "universe": ["NIFTY 50"],
    "universe_filters": [
        {"indicator": "close", "operator": ">", "value": 30000, "timeframe": "1d"}
    ],
    "primary_filter": [],
    "refiner": []
}

print("\n--- TEST 1: Good Filter (Expect ~50 results) ---")
res_good = execute_scan_logic(logic_good, limit_results=5)
print(f"Stats: {res_good['stats']}")
print(f"Sample Matches: {[x['symbol'] for x in res_good['matches']]}")

print("\n--- TEST 2: Bad Filter (Expect 0 results) ---")
res_bad = execute_scan_logic(logic_bad, limit_results=5)
print(f"Stats: {res_bad['stats']}")

if res_good['stats']['universe'] > 0 and res_bad['stats']['universe'] == 0:
    print("\n✅ VERIFICATION SUCCESS: Filters are working on the Index Layer.")
else:
    print("\n❌ VERIFICATION FAILED: Results do not match expectations.")
    print("Note: If Test 1 Universe is 0, it means 'NIFTY 50' data is missing in trading.ohlc_daily.")
