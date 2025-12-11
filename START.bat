@echo off
echo ========================================
echo  White Macro BSS
echo  Version 0.1.0
echo ========================================
echo.

:: Create logs directory if not exists
if not exist "data\logs" mkdir "data\logs"

:: Run the macro directly
echo Starting White Macro BSS...
start "" "%~dp0src\main.ahk"

echo.
echo Macro started! Check the system tray.
echo.
