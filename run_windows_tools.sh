#!/bin/bash

# Git Bash compatible launcher for Windows tools
echo "=== Expendable ERP Integration Tools Launcher ==="
echo ""

echo "Available options:"
echo "1. Find Expendable ERP installation and processes"
echo "2. Test ERP detection for UI automation"
echo "3. Run BOM processing"
echo "4. Open project folder in Windows Explorer"
echo "5. Exit"
echo ""

read -p "Choose option (1-5): " choice

case $choice in
    1)
        echo "Launching Expendable ERP finder..."
        if command -v winpty > /dev/null; then
            winpty cmd.exe /c "Find_Expendable_ERP.bat"
        else
            echo "Opening Command Prompt..."
            cmd.exe /c "start cmd.exe /k cd /d C:\\Users\\ajamme\\solidworks-bom-expendable-transfer && Find_Expendable_ERP.bat"
        fi
        ;;
    2)
        echo "Launching ERP detection test..."
        echo "(Using ExecutionPolicy Bypass to avoid script restrictions)"
        if command -v winpty > /dev/null; then
            winpty powershell.exe -ExecutionPolicy Bypass -File "Test_ERP_Detection.ps1"
        else
            echo "Opening PowerShell with bypass policy..."
            cmd.exe /c "start powershell.exe -ExecutionPolicy Bypass -File Test_ERP_Detection.ps1"
        fi
        ;;
    3)
        echo "Running BOM processing..."
        if [ -f "Run_BOM_Transfer.bat" ]; then
            if command -v winpty > /dev/null; then
                winpty cmd.exe /c "Run_BOM_Transfer.bat"
            else
                cmd.exe /c "start cmd.exe /k Run_BOM_Transfer.bat"
            fi
        else
            echo "Run_BOM_Transfer.bat not found"
        fi
        ;;
    4)
        echo "Opening project folder..."
        explorer.exe .
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        ;;
esac

echo ""
echo "Press any key to continue..."
read -n 1 