import os
from dotenv import load_dotenv

# Load environment variables once
load_dotenv()

# Base Directory (Project Root)
BASE_DIR = os.path.abspath(os.path.dirname(__file__))

# File Paths
TOKENS_FILE = os.path.join(BASE_DIR, "tokens.json")
LOG_DIR = os.path.join(BASE_DIR, "logs")
