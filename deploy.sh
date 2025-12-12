#!/bin/bash

# Deployment Script for Setu V3 on Raspberry Pi 5

echo "🚀 Starting Deployment..."

# 1. Pull latest code
echo "📥 Pulling latest changes from Git..."
git pull origin main

# 2. Activate Virtual Environment
echo "🔌 Activating Virtual Environment..."
source venv/bin/activate

# 3. Install Dependencies
echo "📦 Installing/Updating Dependencies..."
pip install -r requirements.txt

# 4. Success Message & Reminders
echo "✅ Code updated successfully."
echo ""
echo "⚠️  IMPORTANT REMINDERS:"
echo "---------------------------------------------------"
echo "1. If you made DB schema changes, run migrations:"
echo "   python tools/run_migration.py migrations/YOUR_MIGRATION_FILE.sql"
echo ""
echo "2. Restart the Service to apply changes:"
echo "   sudo systemctl restart setu-admin"
echo "---------------------------------------------------"
