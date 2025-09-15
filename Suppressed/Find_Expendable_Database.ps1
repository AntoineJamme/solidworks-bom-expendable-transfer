# Expendable ERP Database Detection Script
# This script helps identify the database used by Expendable ERP

Write-Host "Expendable ERP Database Detection" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

# Common database file extensions and locations
$databaseExtensions = @("*.mdb", "*.accdb", "*.db", "*.sqlite", "*.sqlite3", "*.sdf")
$searchLocations = @(
    "$env:USERPROFILE\AppData\Local",
    "$env:USERPROFILE\AppData\Roaming", 
    "$env:PROGRAMFILES",
    "$env:PROGRAMFILES(x86)",
    "$env:PROGRAMDATA",
    "C:\ProgramData"
)

Write-Host "Searching for database files..." -ForegroundColor Yellow

foreach ($location in $searchLocations) {
    if (Test-Path $location) {
        Write-Host "Searching in: $location" -ForegroundColor Cyan
        
        foreach ($extension in $databaseExtensions) {
            try {
                $files = Get-ChildItem -Path $location -Filter $extension -Recurse -ErrorAction SilentlyContinue |
                         Where-Object { 
                             $_.Name -like "*expendable*" -or $_.Name -like "*expandable*" -or 
                             $_.Name -like "*erp*" -or 
                             $_.Directory.Name -like "*expendable*" -or $_.Directory.Name -like "*expandable*"
                         }
                
                foreach ($file in $files) {
                    Write-Host "FOUND: $($file.FullName)" -ForegroundColor Green
                    Write-Host "  Size: $([math]::Round($file.Length/1KB, 2)) KB" -ForegroundColor White
                    Write-Host "  Modified: $($file.LastWriteTime)" -ForegroundColor White
                }
            }
            catch {
                # Skip access denied errors
            }
        }
    }
}

# Check for SQL Server databases
Write-Host "`nChecking for SQL Server databases..." -ForegroundColor Yellow
try {
    $sqlInstances = Get-Service | Where-Object { $_.Name -like "*SQL*" -and $_.Status -eq "Running" }
    foreach ($instance in $sqlInstances) {
        Write-Host "Found SQL Service: $($instance.Name)" -ForegroundColor Green
    }
}
catch {
    Write-Host "No SQL Server instances found or access denied" -ForegroundColor Gray
}

# Check Windows Registry for Expendable ERP
Write-Host "`nChecking registry for Expendable ERP..." -ForegroundColor Yellow
try {
    $uninstallKeys = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    
    foreach ($keyPath in $uninstallKeys) {
        Get-ItemProperty $keyPath -ErrorAction SilentlyContinue |
        Where-Object { 
            $_.DisplayName -like "*expendable*" -or $_.DisplayName -like "*expandable*" -or 
            $_.DisplayName -like "*ERP*" 
        } |
        ForEach-Object {
            Write-Host "Found Application: $($_.DisplayName)" -ForegroundColor Green
            Write-Host "  Install Location: $($_.InstallLocation)" -ForegroundColor White
            Write-Host "  Version: $($_.DisplayVersion)" -ForegroundColor White
        }
    }
}
catch {
    Write-Host "Registry search failed or access denied" -ForegroundColor Gray
}

# Output instructions
Write-Host "`n" -ForegroundColor White
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. If database files were found, you can use direct database access" -ForegroundColor White
Write-Host "2. If no databases found, the application might use:" -ForegroundColor White
Write-Host "   - Remote database (SQL Server, MySQL, etc.)" -ForegroundColor White
Write-Host "   - Web service/API calls" -ForegroundColor White
Write-Host "   - Proprietary file format" -ForegroundColor White
Write-Host "3. Check Expendable ERP installation folder for:" -ForegroundColor White
Write-Host "   - Configuration files (*.ini, *.config, *.xml)" -ForegroundColor White
Write-Host "   - Documentation about database connections" -ForegroundColor White
Write-Host "   - Connection strings in config files" -ForegroundColor White 