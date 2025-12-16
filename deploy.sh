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

# 4. Update Frontend
echo "🎨 Updating Frontend..."
cd frontend
npm install
npm run build
cd ..

# 5. Restart Services
echo "🔄 Restarting Services..."
sudo systemctl restart setu-admin
sudo systemctl restart setu-dashboard

echo "✅ Deployment Complete! 🚀"
echo "   - Modules updated."
echo "   - Frontend rebuilt."
echo "   - Services restarted."
