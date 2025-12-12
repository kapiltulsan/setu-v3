@echo off
REM Wrapper to run midnight jobs on Windows
cd /d "%~dp0.."
if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
) else (
    echo Venv not found, trying global python...
)

python tools\run_midnight_jobs.py
