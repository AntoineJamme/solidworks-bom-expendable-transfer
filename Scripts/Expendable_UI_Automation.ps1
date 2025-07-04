# Expendable ERP UI Automation Script
# This script automates data entry into Expendable ERP desktop application

param(
    [Parameter(Mandatory=$true)]
    [string]$CSVFilePath
)

# Add required assemblies for UI automation
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
Add-Type -AssemblyName System.Windows.Forms

# Import CSV data from SolidWorks BOM export
$bomData = Import-Csv $CSVFilePath

Write-Host "Starting Expendable ERP UI Automation..." -ForegroundColor Green
Write-Host "Processing $($bomData.Count) items from BOM" -ForegroundColor Yellow

foreach ($item in $bomData) {
    Write-Host "Processing: $($item.PartNumber) - $($item.Description)" -ForegroundColor Cyan
    
    # Find Expendable ERP window (try multiple window title patterns)
    $expendableWindow = $null
    $attempts = 0
    while ($expendableWindow -eq $null -and $attempts -lt 10) {
        $expendableWindow = Get-Process | Where-Object { $_.MainWindowTitle -like "*Expendable*" -or $_.MainWindowTitle -like "*Expandable*" -or $_.ProcessName -like "*expendable*" -or $_.ProcessName -like "*expandable*" } | Select-Object -First 1
        if ($expendableWindow -eq $null) {
            Write-Host "Waiting for Expendable ERP window..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            $attempts++
        }
    }
    
    if ($expendableWindow -eq $null) {
        Write-Host "ERROR: Cannot find Expendable/Expandable ERP window. Please ensure it's open." -ForegroundColor Red
        Write-Host "Looking for window titles containing: Expendable, Expandable, or processes with those names" -ForegroundColor Yellow
        exit 1
    }
    
    # Bring window to front
    [Microsoft.VisualBasic.Interaction]::AppActivate($expendableWindow.Id)
    Start-Sleep -Milliseconds 500
    
    # Navigation and data entry (customize based on Expendable ERP interface)
    # These are example key sequences - you'll need to customize for your specific ERP
    
    # Navigate to new item creation (example: Ctrl+N)
    [System.Windows.Forms.SendKeys]::SendWait("^n")
    Start-Sleep -Milliseconds 500
    
    # Enter Part Number
    [System.Windows.Forms.SendKeys]::SendWait($item.PartNumber)
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
    Start-Sleep -Milliseconds 200
    
    # Enter Description
    [System.Windows.Forms.SendKeys]::SendWait($item.Description)
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
    Start-Sleep -Milliseconds 200
    
    # Enter Quantity
    [System.Windows.Forms.SendKeys]::SendWait($item.Quantity)
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
    Start-Sleep -Milliseconds 200
    
    # Enter Unit of Measure
    if ($item.UnitOfMeasure) {
        [System.Windows.Forms.SendKeys]::SendWait($item.UnitOfMeasure)
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
        Start-Sleep -Milliseconds 200
    }
    
    # Save record (example: Ctrl+S or Enter)
    [System.Windows.Forms.SendKeys]::SendWait("^s")
    Start-Sleep -Milliseconds 1000
    
    Write-Host "✓ Added: $($item.PartNumber)" -ForegroundColor Green
}

Write-Host "UI Automation completed!" -ForegroundColor Green
Write-Host "Manual verification recommended for accuracy." -ForegroundColor Yellow
