import os
import subprocess
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def export_schema():
    # Get DB credentials from env
    db_name = os.getenv("DB_NAME")
    db_user = os.getenv("DB_USER")
    db_pass = os.getenv("DB_PASS")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432")

    if not all([db_name, db_user, db_pass]):
        print("Error: Missing database credentials in .env file.")
        return

    # Set PGPASSWORD environment variable so pg_dump doesn't ask for password
    env = os.environ.copy()
    env["PGPASSWORD"] = db_pass

    output_file = "schema.sql"
    
    # Construct pg_dump command
    # -s: schema only
    # -x: no privileges
    # -O: no owner
    command = [
        "pg_dump",
        "-h", db_host,
        "-p", db_port,
        "-U", db_user,
        "-s", # Schema only
        "-x", # No privileges
        "-O", # No owner
        "-f", output_file,
        db_name
    ]

    print(f"Exporting schema for database '{db_name}' to {output_file}...")

    try:
        subprocess.run(command, env=env, check=True)
        print(f"Successfully exported schema to {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error exporting schema: {e}")
    except FileNotFoundError:
        print("Error: pg_dump not found. Please ensure Postgres tools are installed and in PATH.")

if __name__ == "__main__":
    export_schema()
