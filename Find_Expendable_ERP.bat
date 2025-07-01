@echo off
echo ===============================================
echo  Expendable ERP Installation & Integration Finder
echo ===============================================
echo.

echo Searching for Expendable ERP installation...
echo.

echo 1. Checking Program Files directories:
if exist "C:\Program Files\Expandable Software" (
    echo Found: C:\Program Files\Expandable Software
    dir "C:\Program Files\Expandable Software" /b
) else (
    echo Not found: C:\Program Files\Expandable Software
)

if exist "C:\Program Files (x86)\Expandable Software" (
    echo Found: C:\Program Files (x86)\Expandable Software  
    dir "C:\Program Files (x86)\Expandable Software" /b
) else (
    echo Not found: C:\Program Files (x86)\Expandable Software
)

echo.
echo 2. Checking for running Expendable/Expandable processes:
wmic process get name,executablepath | findstr -i expendable
wmic process get name,executablepath | findstr -i expandable

echo.
echo 3. Checking registry for installation info:
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Expendable" 2>nul | findstr DisplayName
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Expandable" 2>nul | findstr DisplayName

echo.
echo 4. Searching for common database files:
echo Searching for database files (this may take a moment)...
forfiles /p "C:\Users\%USERNAME%\AppData" /s /m *.db 2>nul | findstr -i expendable
forfiles /p "C:\Users\%USERNAME%\AppData" /s /m *.db 2>nul | findstr -i expandable
forfiles /p "C:\Users\%USERNAME%\AppData" /s /m *.mdb 2>nul | findstr -i expendable
forfiles /p "C:\Users\%USERNAME%\AppData" /s /m *.mdb 2>nul | findstr -i expandable
forfiles /p "C:\Users\%USERNAME%\AppData" /s /m *.accdb 2>nul | findstr -i expendable
forfiles /p "C:\Users\%USERNAME%\AppData" /s /m *.accdb 2>nul | findstr -i expandable

echo.
echo 5. Shortcut information:
echo Found shortcut: C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Expandable Software\Expandable ERP.lnk

echo.
echo ===============================================
echo  Integration Options Available:
echo ===============================================
echo.
echo 1. UI AUTOMATION (Recommended)
echo    - Run: Scripts\Expendable_UI_Automation.ps1
echo    - Requires: Expendable ERP to be open
echo    - Customize key sequences for your interface
echo.
echo 2. DATABASE DIRECT ACCESS  
echo    - First identify database location from search above
echo    - Backup database before any changes
echo    - Create SQL scripts for direct insertion
echo.
echo 3. MANUAL ENTRY
echo    - Use processed CSV as reference
echo    - Manual data entry into ERP
echo.
echo 4. Check for additional integration options:
echo    - Contact Expandable Software support
echo    - Look for API documentation
echo    - Consider RPA tools (Power Automate, UiPath)
echo.

echo ===============================================
echo  Next Steps:
echo ===============================================
echo 1. Review output above for installation path
echo 2. If Expendable ERP found, open it and test UI automation  
echo 3. If database files found, consider direct access approach
echo 4. Read EXPENDABLE_ERP_INTEGRATION_GUIDE.md for detailed instructions
echo.

pause 