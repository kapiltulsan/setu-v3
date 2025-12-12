#!/bin/bash
# Wrapper to run midnight jobs on Linux/Pi

# Ensure we are in the project root
cd "$(dirname "$0")/.."

# Activate Venv if it exists
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
fi

# Run the python script
python3 tools/run_midnight_jobs.py
