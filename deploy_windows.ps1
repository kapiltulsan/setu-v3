<#
.SYNOPSIS
    Deployment Script for Setu V3 on Windows
    Equivalent to deploy.sh but adapted for PowerShell and Windows environment.

.DESCRIPTION
    1. Pulls latest code.
    2. Installs Python dependencies.
    3. Updates and builds Frontend.
    4. Checks for migrations.
    5. Sends notification.

    NOTE: Does NOT manage background services (Systemd equivalent) as Windows dev setup varies.
#>

Write-Host "🚀 Starting Deployment on Windows..." -ForegroundColor Cyan

# 0. Check Branch
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "main") {
    Write-Host "⚠️  WARNING: You are on branch '$currentBranch', not 'main'." -ForegroundColor Yellow
    # Uncomment below to force exit on non-main branch
    # Write-Host "❌ Aborting." -ForegroundColor Red
    # exit 1
}

# 1. Pull latest code
Write-Host "📥 Pulling latest changes from Git..." -ForegroundColor Cyan
git pull origin $currentBranch

# 2. Python Dependencies
Write-Host "📦 Installing/Updating Python Dependencies..." -ForegroundColor Cyan
# Using the venv python directly to ensure we use the virtual environment
$venvPython = ".\venv\Scripts\python.exe"

if (Test-Path $venvPython) {
    & $venvPython -m pip install -r requirements.txt
} else {
    Write-Host "⚠️  Virtual environment not found at .\venv. Using global python..." -ForegroundColor Yellow
    python -m pip install -r requirements.txt
}

# 3. Update Frontend
Write-Host "🎨 Updating Frontend..." -ForegroundColor Cyan
Push-Location frontend
    # Check if NVM is installed (via nvm-windows)
    # nvm-windows usually manages the PATH, so 'node' should be the right one.
    
    Write-Host "   Running npm install..." -ForegroundColor Gray
    npm install
    
    Write-Host "   Running npm build..." -ForegroundColor Gray
    npm run build
Pop-Location

# 4. Check for Migrations
Write-Host "🔍 Checking for DB Migrations..." -ForegroundColor Cyan
$migrationFiles = Get-ChildItem -Path "migrations" -Filter "*.sql"
if ($migrationFiles) {
    Write-Host "⚠️  Found migration files in migrations/. Check if they need to be run:" -ForegroundColor Yellow
    $migrationFiles | ForEach-Object { Write-Host "   - $($_.Name)" }
    Write-Host "   Run: python tools/run_migration.py migrations/<filename>" -ForegroundColor Gray
} else {
    Write-Host "✅ No migrations found." -ForegroundColor Green
}

# 5. Service Management (Placeholder)
# Windows services or scheduled tasks handling is complex and specific to user setup.
# We will just notify the user to restart manually if needed.
Write-Host "ℹ️  NOTE: If you are running servers manually (e.g., python app.py), please restart them now." -ForegroundColor Magenta

# 6. Notification
Write-Host "🔔 Sending Notification..." -ForegroundColor Cyan
$hostname = hostname
# Use venv python if available
if (Test-Path $venvPython) {
    & $venvPython -m modules.notifier -t "Deployment" -m "✅ Setu V3 Updated Successfully on $hostname" -p "default"
} else {
    python -m modules.notifier -t "Deployment" -m "✅ Setu V3 Updated Successfully on $hostname" -p "default"
}

Write-Host "✅ Deployment Complete! 🚀" -ForegroundColor Green
