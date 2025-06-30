@echo off
REM ======================================================
REM SolidWorks BOM to Expendable ERP Transfer Tool
REM ======================================================

title SolidWorks BOM Transfer Tool

echo.
echo ================================================
echo    SolidWorks BOM to Expendable ERP Transfer
echo ================================================
echo.

REM Set the script directory
set SCRIPT_DIR=%~dp0

echo Current directory: %SCRIPT_DIR%
echo.

REM Check if PowerShell is available
powershell.exe -Command "Write-Host 'PowerShell is available'" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not available on this system.
    echo Please install PowerShell and try again.
    pause
    exit /b 1
)

echo Step 1: Checking for new BOM files...
if not exist "%SCRIPT_DIR%Exports\*.csv" (
    echo No CSV files found in Exports folder.
    echo.
    echo To use this tool:
    echo 1. Run the SolidWorks macro to export your BOM
    echo 2. Then run this batch file to process the data
    echo.
    echo Press any key to open the exports folder...
    pause >nul
    explorer "%SCRIPT_DIR%Exports"
    exit /b 0
)

echo Found CSV files to process!
echo.

echo Step 2: Processing BOM data for Expendable ERP...
echo.

REM Run the PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Scripts\Process_BOM_for_Expendable.ps1"

if %errorlevel% equ 0 (
    echo.
    echo ================================================
    echo SUCCESS: BOM processing completed!
    echo ================================================
    echo.
    echo Your files are ready for import into Expendable ERP.
    echo Check the 'Processed' folder for:
    echo   - *_Expendable_Ready.csv (import this file)
    echo   - Import_Instructions.txt (follow these steps)
    echo.
    echo Opening processed files folder...
    start "" explorer "%SCRIPT_DIR%Processed"
) else (
    echo.
    echo ================================================
    echo ERROR: BOM processing failed!
    echo ================================================
    echo.
    echo Please check the error messages above and try again.
    echo If problems persist, check the configuration file.
)

echo.
echo Press any key to exit...
pause >nul
