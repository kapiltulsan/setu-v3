import requests
import json

url = "https://margincalculator.angelbroking.com/OpenAPI_File/files/OpenAPIScripMaster.json"
print("Downloading Angel Master...")
r = requests.get(url)
data = r.json()

indices = ["Nifty 50", "Nifty Bank", "Nifty IT", "Nifty 100", "Nifty 500", "BANKNIFTY", "NIFTY", "CNX Nifty"]
results = []

for item in data:
    if any(idx.lower() == item['symbol'].lower() or idx.lower() == item['name'].lower() for idx in indices):
        results.append(item)

# Print unique exch_seg for these
segs = set(item['exch_seg'] for item in results)
print(f"Segments found: {segs}")

# Print results
for item in results:
    print(f"Symbol: {item['symbol']}, Token: {item['token']}, Seg: {item['exch_seg']}, Name: {item['name']}, Expiry: {item.get('expiry')}")
