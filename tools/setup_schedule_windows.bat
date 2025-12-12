@echo off
REM Script to schedule Setu V3 Midnight Jobs on Windows
REM This will create a Task Scheduler entry to run daily at 00:30

set "TASK_NAME=SetuV3_MidnightJobs"
set "SCRIPT_PATH=%~dp0run_midnight_jobs.bat"

echo Creating Scheduled Task: %TASK_NAME%
echo Script: %SCRIPT_PATH%
echo Schedule: Daily @ 00:30

schtasks /create /tn "%TASK_NAME%" /tr "\"%SCRIPT_PATH%\"" /sc daily /st 00:30 /f

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Task created successfully!
    echo To verify, open Task Scheduler and look for "%TASK_NAME%".
) else (
    echo.
    echo [ERROR] Failed to create task. Note: You may need to run this script as Administrator.
)
pause
