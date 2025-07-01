# Simple Test Expendable ERP Detection Script

Write-Host "=== Simple Expendable ERP Detection Test ===" -ForegroundColor Cyan
Write-Host ""

# Check for running processes
Write-Host "Checking for running Expendable/Expandable processes..." -ForegroundColor Yellow

$processes = Get-Process | Where-Object { 
    $_.ProcessName -like "*expendable*" -or 
    $_.ProcessName -like "*expandable*" -or
    $_.MainWindowTitle -like "*expendable*" -or 
    $_.MainWindowTitle -like "*expandable*"
}

if ($processes) {
    Write-Host "Found processes:" -ForegroundColor Green
    $processes | ForEach-Object {
        Write-Host "  - Name: $($_.ProcessName), Window: '$($_.MainWindowTitle)', PID: $($_.Id)" -ForegroundColor White
    }
} else {
    Write-Host "No Expendable/Expandable processes found" -ForegroundColor Red
    Write-Host "Please ensure Expendable ERP is running" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Test completed. Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 