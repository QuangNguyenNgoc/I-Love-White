@echo off
echo ========================================
echo  White Macro BSS
echo  Version 0.1.0
echo ========================================
echo.

:: Check if AutoHotkey v2 is installed
where /q AutoHotkey64.exe
if %ERRORLEVEL% NEQ 0 (
    where /q AutoHotkey32.exe
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] AutoHotkey v2 not found!
        echo Please install from: https://www.autohotkey.com/
        pause
        exit /b 1
    )
)

:: Create logs directory if not exists
if not exist "data\logs" mkdir "data\logs"

:: Run the macro
echo Starting White Macro BSS...
start "" "src\main.ahk"

echo.
echo Macro started! Check the system tray.
echo.
