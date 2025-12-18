# Check if venv exists
if (!(Test-Path ".\venv")) {
    Write-Host "Virtual environment not found. Please run 'python -m venv venv' first." -ForegroundColor Red
    exit
}

# Start Backend
Write-Host "Starting Backend (Flask) on port 5000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command & { . .\venv\Scripts\Activate.ps1; python app.py }"

# Start Frontend
Write-Host "Starting Frontend (Next.js) on port 3000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command & { cd frontend; npm run dev }"

Write-Host "Development environment started!" -ForegroundColor Cyan
Write-Host "Backend: http://localhost:5000"
Write-Host "Frontend: http://localhost:3000"
