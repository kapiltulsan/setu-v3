import codecs

try:
    with codecs.open("debug_output.txt", "r", "utf-16") as f:
        content = f.read()
        print(content)
except Exception as e:
    print(f"Error reading utf-16: {e}")
    # Try utf-8
    try:
        with open("debug_output.txt", "r", encoding="utf-8") as f:
            print(f.read())
    except Exception as e2:
        print(f"Error reading utf-8: {e2}")
