# Setu V3

Setu V3 is a Flask-based application for algorithmic trading and portfolio management, integrated with Zerodha Kite Connect and TimescaleDB for high-frequency data analysis.

## 🏗 Architecture & Terminology
- **Reporting Panel (Port 3000)**: The frontend dashboard interface (Next.js).
- **Admin Panel (Port 5000)**: The backend API and Flask-based reporting views (HTTPS).
- **Stock Scanner**: Define and run algorithmic strategies on daily/weekly data.

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
# Install packages
pip install -r requirements.txt

# Install Frontend Dependencies
cd frontend
npm install
cd ..
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
### Start the Application (Windows Dev)
We have a helper script to run both Backend (5000) and Frontend (3000):

```powershell
.\tools\start_dev.ps1
```
This will open two windows:
- **Backend**: `http://localhost:5000`
- **Frontend**: `http://localhost:3000`

*Note: The app uses ad-hoc SSL certificates for local HTTPS development if configured, but defaults to HTTP for dev.*

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
