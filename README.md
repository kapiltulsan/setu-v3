# Setu V3

Setu V3 is a Flask-based application for algorithmic trading and portfolio management, integrated with Zerodha Kite Connect and TimescaleDB for high-frequency data analysis.

## 🏗 Architecture & Terminology
- **Reporting Panel (Port 3000)**: The frontend dashboard interface (Next.js).
- **Admin Panel (Port 5000)**: The backend API and Flask-based reporting views (HTTPS).

## 🚀 Setup Instructions

### Prerequisites
- Python 3.10+
- PostgreSQL 14+ with TimescaleDB extension

### 1. Installation
Clone the repository and install dependencies:
```bash
# Create virtual environment
python -m venv venv
./venv/Scripts/Activate.ps1  # Windows PowerShell

# Install packages
pip install -r requirements.txt
```

### 2. Configuration
Create a `.env` file in the root directory by copying the example:
```bash
cp .env.example .env
```
Edit `.env` and fill in your details:
- **DB_HOST, DB_NAME, DB_USER, DB_PASS**: Your Postgres credentials.
- **KITE_API_KEY, KITE_API_SECRET**: Your Zerodha API keys.

### 3. Database Setup
Ensure your Postgres user has permissions to create schemas and extensions.

**Import Schema (First Run):**
```bash
psql -U postgres -d your_db_name -f schema.sql
```
*Note: This will create the `ohlc`, `trading`, and `ref` schemas along with TimescaleDB hypertables.*

**Run Migrations:**
If updating an existing database, check the `migrations` folder.
```bash
python tools/run_migration.py migrations/001_update_trades.sql
```

## 🛠 Usage

### Start the Application
```bash
python app.py
```
Access the dashboard at `https://localhost:5000`.
*Note: The app uses ad-hoc SSL certificates for local HTTPS development.*

### Developer Tools
- **Generate DB Documentation**:
  ```bash
  python tools/document_db.py
  ```
  Updates `database_schema.md`.

- **Export DB Schema**:
  ```bash
  python tools/export_schema.py
  ```
  Dumps current DB structure to `schema.sql`.

## 📂 Project Structure
- `app.py`: Entry point for the Flask server.
- `modules/`: Core logic (Auth, Charts, Logs).
- `templates/`: HTML templates.
- `tools/`: Utility scripts for DB management.
- `migrations/`: SQL migration files.
- `database_schema.md`: Reference documentation for table structures.

## 📝 Maintenance Protocol
To ensure the project remains maintainable, please follow these rules when making changes:

1. **Database Changes**:
   - Always create a migration script in `migrations/`.
   - Run `python tools/document_db.py` to update `database_schema.md`.
   - Run `python tools/export_schema.py` to update `schema.sql`.

2. **Environment Variables**:
   - If you add a new key to `.env`, immediately add it to `.env.example` with a dummy value.

3. **Deployment**:
   - If you change the launch process, update `deploy.sh` and `DEPLOYMENT.md`.
