# SolidWorks BOM to Expendable ERP Transfer Tool

This tool automates the transfer of Bill of Materials (BOM) data from SolidWorks 2022 assemblies to Expendable ERP systems.

## 📁 Folder Structure

```
C:\Users\Antoi\SolidWorks_BOM_Transfer\
├── Scripts\
│   ├── SolidWorks_BOM_Export.swp      # SolidWorks VBA macro
│   └── Process_BOM_for_Expendable.ps1 # PowerShell processing script
├── Exports\                           # Raw CSV exports from SolidWorks
├── Processed\                         # Processed files ready for Expendable ERP
├── Templates\                         # Templates and examples
├── config.json                        # Configuration settings
├── Run_BOM_Transfer.bat              # Main automation script
└── README.md                         # This file
```

## 🚀 Quick Start

### Step 1: Install the SolidWorks Macro

1. Copy `Scripts\SolidWorks_BOM_Export.swp` to your SolidWorks macro folder:
   - Usually located at: `C:\Users\[Username]\AppData\Roaming\SolidWorks\Macros\`
   - Or your custom macro folder if configured

2. In SolidWorks, go to **Tools > Macro > Run** and select the macro file

3. Add the macro to your toolbar for quick access:
   - **Tools > Customize > Commands**
   - Drag "Macro" to your toolbar
   - Browse to the macro file

### Step 2: Configure for Your Expendable ERP

Edit `config.json` to match your Expendable ERP system requirements:

```json
{
  "expendable_settings": {
    "default_category": "Your_Category_Name",
    "default_location": "Your_Warehouse_Name",
    "currency_symbol": "$"
  }
}
```

### Step 3: Set Up SolidWorks Custom Properties

For best results, set up these custom properties in your SolidWorks parts:

- **PartNo**: Part number or SKU
- **Description**: Part description
- **Material**: Material type
- **Weight**: Part weight
- **Cost**: Unit cost
- **Supplier**: Preferred supplier

## 📋 How to Use

### Method 1: Manual Process

1. **Export BOM from SolidWorks:**
   - Open your assembly in SolidWorks
   - Run the `SolidWorks_BOM_Export` macro
   - CSV file is saved to `Exports\` folder

2. **Process for Expendable ERP:**
   - Double-click `Run_BOM_Transfer.bat`
   - Processed file appears in `Processed\` folder

3. **Import to Expendable ERP:**
   - Follow instructions in `Import_Instructions.txt`
   - Import the `*_Expendable_Ready.csv` file

### Method 2: Automated Workflow

Create a desktop shortcut to `Run_BOM_Transfer.bat` for quick access after exporting from SolidWorks.

## ⚙️ Configuration Options

### Expendable Settings

```json
"expendable_settings": {
  "date_format": "MM/dd/yyyy",        // Date format for Expendable ERP
  "currency_symbol": "$",             // Currency symbol
  "default_category": "Parts",        // Default item category
  "default_location": "Main Warehouse", // Default warehouse location
  "default_unit_of_measure": "EA"     // Default unit of measure
}
```

### Field Mapping

Customize how SolidWorks fields map to Expendable ERP fields:

```json
"field_mapping": {
  "part_number": "Part Number",       // Maps to Expendable part number field
  "description": "Description",       // Maps to Expendable description field
  "quantity": "Quantity"              // Maps to Expendable quantity field
}
```

### SolidWorks Custom Properties

Configure which custom properties to extract:

```json
"solidworks_custom_properties": {
  "part_number_property": "PartNo",   // Custom property name for part number
  "description_property": "Description",
  "material_property": "Material",
  "cost_property": "Cost"
}
```

## 📊 Output Format

The processed CSV file includes these columns for Expendable ERP:

| Column | Description | Source |
|--------|-------------|--------|
| Item | Item number | Auto-generated |
| Part Number | Part number/SKU | SolidWorks custom property or filename |
| Description | Part description | SolidWorks custom property |
| Quantity | Quantity in assembly | Calculated from BOM |
| Material | Material type | SolidWorks custom property |
| Weight | Part weight | SolidWorks custom property |
| Cost | Unit cost | SolidWorks custom property |
| Supplier | Preferred supplier | SolidWorks custom property |
| Category | Item category | From configuration |
| Location | Warehouse location | From configuration |
| UOM | Unit of measure | From configuration |
| Date_Created | Creation date | Current date |
| Status | Item status | "Active" |

## 🔧 Troubleshooting

### Common Issues

**1. "No CSV files found" error**
- Run the SolidWorks macro first to export BOM data
- Check that files are in the `Exports\` folder

**2. PowerShell execution error**
- Run PowerShell as Administrator
- Execute: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**3. Missing custom properties**
- Add custom properties to your SolidWorks parts
- Or modify the macro to use default values

**4. Import errors in Expendable ERP**
- Check field mapping in `config.json`
- Verify column names match Expendable ERP requirements
- Review `Import_Instructions.txt`

### Advanced Troubleshooting

**Enable PowerShell logging:**
```powershell
# Add this to the beginning of Process_BOM_for_Expendable.ps1
Start-Transcript -Path "C:\Users\Antoi\SolidWorks_BOM_Transfer\debug.log"
```

**Test macro in SolidWorks:**
- Open VBA editor in SolidWorks (Alt + F11)
- Set breakpoints to debug issues
- Check that assembly is open and contains components

## 🔄 Workflow Integration

### Daily Use Workflow

1. **Design Phase**: Create assembly in SolidWorks with proper custom properties
2. **Export Phase**: Run macro to export BOM → `Exports\` folder
3. **Process Phase**: Run batch file → Creates `*_Expendable_Ready.csv`
4. **Import Phase**: Import CSV into Expendable ERP
5. **Cleanup**: Files automatically archived with timestamps

### Batch Processing

For multiple assemblies:

1. Export all BOMs to `Exports\` folder using the macro
2. Run `Run_BOM_Transfer.bat` once to process all files
3. Import all `*_Expendable_Ready.csv` files to Expendable ERP

## 📝 Customization

### Adding Custom Fields

1. **Modify the SolidWorks macro:**
   ```vb
   ' Add your custom property
   customValue = GetCustomProperty(swCompModel, "YourCustomProperty")
   ' Add to CSV output
   Print #fileNum, ... & "," & EscapeCSV(customValue)
   ```

2. **Update PowerShell script:**
   ```powershell
   $processedRow["Your_Custom_Field"] = $row.YourCustomProperty
   ```

3. **Update configuration:**
   ```json
   "field_mapping": {
     "your_custom_field": "Your Custom Field"
   }
   ```

### Integration with Other Systems

The PowerShell script can be modified to output to other formats:
- XML for advanced ERP systems
- JSON for API integration
- Direct database connection

## 📞 Support

### System Requirements

- Windows 10/11
- SolidWorks 2022 (may work with other versions)
- PowerShell 5.0 or later
- Expendable ERP system with CSV import capability

### Getting Help

1. Check this README for common solutions
2. Review the configuration file settings
3. Check the debug log files in the `Processed\` folder
4. Verify SolidWorks custom properties are set correctly

### Version History

- **v1.0** - Initial release with basic BOM export
- **v1.1** - Added Expendable ERP formatting
- **v1.2** - Added configuration file support
- **v1.3** - Added batch processing and automation

---

**Created:** $(Get-Date)  
**Last Updated:** $(Get-Date)  
**Compatible with:** SolidWorks 2022, Expendable ERP 