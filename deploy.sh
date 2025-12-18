#!/bin/bash

# Deployment Script for Setu V3 on Raspberry Pi 5

echo "🚀 Starting Deployment..."

# 0. Safety Check: Ensure we are on 'main'
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "❌ ERROR: Production deployment requires being on 'main' branch."
    echo "   You are currently on: $CURRENT_BRANCH"
    echo "   Aborting to prevent mistakes."
    exit 1
fi


# 1. Pull latest code
echo "📥 Pulling latest changes from Git..."
git pull origin main

# 2. Activate Virtual Environment
echo "🔌 Activating Virtual Environment..."
source venv/bin/activate

# 3. Install Dependencies
echo "📦 Installing/Updating Dependencies..."
pip install -r requirements.txt

# 4. Update Frontend
echo "🎨 Updating Frontend..."

# Load NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cd frontend
npm install
npm run build
cd ..

# 5. Check for Migrations
echo "🔍 Checking for DB Migrations..."
if ls migrations/*.sql 1> /dev/null 2>&1; then
    echo "⚠️  Found migration files in migrations/. Check if they need to be run:"
    ls migrations/*.sql
    echo "   Run: python tools/run_migration.py migrations/<filename>"
else
    echo "✅ No migrations found."
fi

# Copy service files to /etc/systemd/system/ to ensure latest config is used
echo "📋 Copying systemd service files..."
sudo cp systemd/setu-admin.service /etc/systemd/system/
sudo cp systemd/setu-dashboard.service /etc/systemd/system/


# 6. Restart Services
restart_service() {
    if systemctl list-units --full -all | grep -Fq "$1.service"; then
        echo "   Restarting $1..."
        sudo systemctl restart $1
    else
        echo "⚠️  Service $1 not found. Skipping restart."
    fi
}

echo "🔄 Restarting Services..."


# Reload systemd manager configuration to handle any file changes
sudo systemctl daemon-reload
restart_service "setu-admin"
restart_service "setu-dashboard"

echo "✅ Deployment Complete! 🚀"
echo "   - Modules updated."
echo "   - Frontend rebuilt."
echo "   - Services restarted (if active)."
