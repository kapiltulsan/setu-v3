#!/bin/bash
# Script to set up the systemd timer for Midnight Jobs on Raspberry Pi

# Get absolute path to the project root
PROJECT_DIR=$(dirname $(dirname $(realpath $0)))
SERVICE_FILE="systemd/setu-midnight-jobs.service"
TIMER_FILE="systemd/setu-midnight-jobs.timer"

echo "🔧 Setting up Midnight Jobs Schedule on Pi..."
echo "Project Directory: $PROJECT_DIR"

# Check if systemd files exist
if [ ! -f "$PROJECT_DIR/$SERVICE_FILE" ] || [ ! -f "$PROJECT_DIR/$TIMER_FILE" ]; then
    echo "❌ Error: Systemd files not found in $PROJECT_DIR/systemd/"
    exit 1
fi

# Update the service file with correct paths (if needed) - simplified for now assuming standard path
# If user installed elsewhere, they might need to edit. 
# For a robust script, we could stream-edit the service file, but let's stick to copy for now as per instructions.

echo "📋 Copying systemd files to /etc/systemd/system/..."
sudo cp "$PROJECT_DIR/$SERVICE_FILE" /etc/systemd/system/
sudo cp "$PROJECT_DIR/$TIMER_FILE" /etc/systemd/system/

echo "🔄 Reloading systemd..."
sudo systemctl daemon-reload

echo "✅ Enabling and Starting Timer..."
sudo systemctl enable setu-midnight-jobs.timer
sudo systemctl start setu-midnight-jobs.timer

echo "📅 Current Timer Status:"
systemctl list-timers --all | grep setu

echo ""
echo "🎉 Done! The jobs will run daily at 00:30."
    