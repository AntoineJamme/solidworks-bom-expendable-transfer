# PowerShell Script to Process SolidWorks BOM for Expendable ERP
# File: Process_BOM_for_Expendable.ps1

param(
    [string]$ConfigFile = "C:\Users\Antoi\SolidWorks_BOM_Transfer\config.json",
    [string]$InputFolder = "C:\Users\Antoi\SolidWorks_BOM_Transfer\Exports",
    [string]$OutputFolder = "C:\Users\Antoi\SolidWorks_BOM_Transfer\Processed"
)

# Function to load configuration
function Load-Config {
    param([string]$configPath)
    
    if (Test-Path $configPath) {
        $config = Get-Content $configPath | ConvertFrom-Json
        return $config
    } else {
        Write-Host "Configuration file not found. Creating default config..." -ForegroundColor Yellow
        
        # Create default configuration
        $defaultConfig = @{
            expendable_settings = @{
                date_format = "MM/dd/yyyy"
                currency_symbol = "$"
                default_category = "Parts"
                default_location = "Main Warehouse"
                default_unit_of_measure = "EA"
            }
            field_mapping = @{
                item_number = "Item"
                part_number = "Part Number"
                description = "Description"
                quantity = "Quantity"
                material = "Material"
                weight = "Weight"
                cost = "Cost"
                supplier = "Supplier"
                category = "Category"
                location = "Location"
                unit_of_measure = "UOM"
            }
            import_template = @{
                required_fields = @("part_number", "description", "quantity")
                optional_fields = @("material", "weight", "cost", "supplier", "category", "location", "unit_of_measure")
            }
        }
        
        $defaultConfig | ConvertTo-Json -Depth 3 | Out-File $configPath
        return $defaultConfig
    }
}

# Function to process BOM files
function Process-BOMFiles {
    param(
        [string]$inputPath,
        [string]$outputPath,
        [object]$config
    )
    
    # Create output directory if it doesn't exist
    if (!(Test-Path $outputPath)) {
        New-Item -ItemType Directory -Path $outputPath -Force
    }
    
    # Get all CSV files from input folder
    $csvFiles = Get-ChildItem -Path $inputPath -Filter "*.csv"
    
    if ($csvFiles.Count -eq 0) {
        Write-Host "No CSV files found in $inputPath" -ForegroundColor Yellow
        return
    }
    
    foreach ($file in $csvFiles) {
        Write-Host "Processing file: $($file.Name)" -ForegroundColor Green
        
        try {
            # Read the CSV file
            $bomData = Import-Csv -Path $file.FullName
            
            # Process each row
            $processedData = @()
            
            foreach ($row in $bomData) {
                $processedRow = @{}
                
                # Map fields according to configuration
                $processedRow[$config.field_mapping.item_number] = $row.Item
                $processedRow[$config.field_mapping.part_number] = $row.'Part Number'
                $processedRow[$config.field_mapping.description] = $row.Description
                $processedRow[$config.field_mapping.quantity] = $row.Quantity
                $processedRow[$config.field_mapping.material] = $row.Material
                $processedRow[$config.field_mapping.weight] = $row.Weight
                $processedRow[$config.field_mapping.cost] = Format-Currency $row.Cost $config.expendable_settings.currency_symbol
                $processedRow[$config.field_mapping.supplier] = $row.Supplier
                
                # Add default values for Expendable ERP
                $processedRow[$config.field_mapping.category] = $config.expendable_settings.default_category
                $processedRow[$config.field_mapping.location] = $config.expendable_settings.default_location
                $processedRow[$config.field_mapping.unit_of_measure] = $config.expendable_settings.default_unit_of_measure
                $processedRow["Date_Created"] = Get-Date -Format $config.expendable_settings.date_format
                $processedRow["Status"] = "Active"
                
                $processedData += New-Object PSObject -Property $processedRow
            }
            
            # Generate output filename
            $outputFileName = $file.BaseName + "_Expendable_Ready.csv"
            $outputFilePath = Join-Path $outputPath $outputFileName
            
            # Export processed data
            $processedData | Export-Csv -Path $outputFilePath -NoTypeInformation
            
            Write-Host "✓ Processed file saved as: $outputFileName" -ForegroundColor Green
            
            # Move original file to processed folder with timestamp
            $processedOriginal = Join-Path $outputPath ($file.BaseName + "_original_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".csv")
            Move-Item -Path $file.FullName -Destination $processedOriginal
            
        } catch {
            Write-Host "✗ Error processing file $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Function to format currency
function Format-Currency {
    param(
        [string]$value,
        [string]$symbol
    )
    
    if ([string]::IsNullOrWhiteSpace($value) -or $value -eq "0") {
        return ""
    }
    
    # Try to parse as number
    $numValue = 0
    if ([double]::TryParse($value, [ref]$numValue)) {
        return $symbol + $numValue.ToString("F2")
    }
    
    return $value
}

# Function to generate import instructions for Expendable ERP
function Generate-ImportInstructions {
    param([string]$outputPath)
    
    $instructions = @"
EXPENDABLE ERP IMPORT INSTRUCTIONS
==================================

1. Open Expendable ERP system
2. Navigate to: Inventory > Import > Parts/Items
3. Select the processed CSV file: *_Expendable_Ready.csv
4. Map the following fields:

   CSV Column          → Expendable Field
   ─────────────────────────────────────
   Item               → Item Number
   Part Number        → Part Number/SKU
   Description        → Description
   Quantity           → On Hand Quantity
   Material           → Material Type
   Weight             → Unit Weight
   Cost               → Unit Cost
   Supplier           → Preferred Vendor
   Category           → Item Category
   Location           → Warehouse Location
   UOM                → Unit of Measure
   Date_Created       → Date Added
   Status             → Status

5. Verify field mapping and run import
6. Review import log for any errors
7. Update inventory as needed

Generated: $(Get-Date)
"@

    $instructionsFile = Join-Path $outputPath "Import_Instructions.txt"
    $instructions | Out-File $instructionsFile
    Write-Host "✓ Import instructions saved to: Import_Instructions.txt" -ForegroundColor Cyan
}

# Main execution
Write-Host "=== SolidWorks BOM to Expendable ERP Processor ===" -ForegroundColor Cyan
Write-Host "Loading configuration..." -ForegroundColor Yellow

$config = Load-Config -configPath $ConfigFile

Write-Host "Processing BOM files..." -ForegroundColor Yellow
Process-BOMFiles -inputPath $InputFolder -outputPath $OutputFolder -config $config

Write-Host "Generating import instructions..." -ForegroundColor Yellow
Generate-ImportInstructions -outputPath $OutputFolder

Write-Host "`n=== Processing Complete ===" -ForegroundColor Green
Write-Host "Check the '$OutputFolder' folder for processed files." -ForegroundColor White

# Open output folder
if (Test-Path $OutputFolder) {
    Start-Process explorer.exe $OutputFolder
} 