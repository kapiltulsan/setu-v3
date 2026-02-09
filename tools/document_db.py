import os
import sys
# Add parent directory to path to allow importing from modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import psycopg2
from dotenv import load_dotenv
from modules.charts import get_db_connection

def generate_schema_markdown():
    load_dotenv()
    conn = get_db_connection()
    if not conn:
        print("Failed to connect to database.")
        return

    cursor = conn.cursor()
    
    # Get all tables in the database, excluding system tables
    try:
        # Fetch tables from public, ohlc, and ref schemas (adjust as needed)
        cursor.execute("""
            SELECT table_schema, table_name 
            FROM information_schema.tables 
            WHERE table_schema NOT IN ('information_schema', 'pg_catalog', '_timescaledb_internal') 
            ORDER BY table_schema, table_name;
        """)
        tables = cursor.fetchall()

        md_content = "# Database Schema Documentation\n\n"
        
        current_schema = None

        for schema, table in tables:
            if schema != current_schema:
                current_schema = schema
                md_content += f"## Schema: `{schema}`\n\n"
            
            md_content += f"### Table: `{table}`\n\n"
            
            # Get columns for the table
            cursor.execute("""
                SELECT column_name, data_type, is_nullable, column_default
                FROM information_schema.columns
                WHERE table_schema = %s AND table_name = %s
                ORDER BY ordinal_position;
            """, (schema, table))
            
            columns = cursor.fetchall()
            
            if columns:
                md_content += "| Column | Type | Nullable | Default |\n"
                md_content += "| :--- | :--- | :--- | :--- |\n"
                for col in columns:
                    col_name, data_type, is_nullable, default_val = col
                    default_str = f"`{default_val}`" if default_val else "-"
                    md_content += f"| **{col_name}** | {data_type} | {is_nullable} | {default_str} |\n"
            else:
                md_content += "*No columns found.*\n"
            
            md_content += "\n"

        # Write to file
        output_file = "database_schema.md"
        with open(output_file, "w", encoding='utf-8') as f:
            f.write(md_content)
        
        print(f"Successfully generated {output_file}")

    except Exception as e:
        print(f"Error generating schema: {e}")
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    generate_schema_markdown()
