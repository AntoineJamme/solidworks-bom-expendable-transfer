# SolidWorks BOM to Expendable ERP Transfer Tool

A streamlined tool for transferring Bill of Materials (BOM) data from SolidWorks assemblies to Expendable ERP systems via UI automation.

## ✅ **Current Status: WORKING**

- ✅ **Expendable ERP Detected**: ESIMRP process with "Expandable" window title
- ✅ **UI Automation Ready**: PowerShell scripts configured for automated data entry
- ✅ **Streamlined Interface**: Single launcher with working options only

## 🚀 Quick Start

### 1. Launch the Tool
```bash
# From Git Bash or WSL
./run_windows_tools.sh

# Or double-click on Windows
bash run_windows_tools.sh
```

### 2. Available Options
1. **Find Expendable ERP installation and processes** - Locate ERP system details
2. **Test ERP detection for UI automation** - Verify Expendable ERP is running and detectable
3. **Run BOM processing** - Execute the main BOM transfer workflow
4. **Open project folder in Windows Explorer** - Quick access to project files
5. **Exit** - Close the launcher

## 📁 Project Structure

```
solidworks-bom-expendable-transfer/
├── run_windows_tools.sh              # Main launcher (START HERE)
├── Test_ERP_Detection.ps1             # ERP detection and validation
├── Find_Expendable_ERP.bat           # ERP discovery tool
├── Run_BOM_Transfer.bat              # BOM processing automation
├── config.json                       # Configuration settings
├── Scripts/
│   ├── SolidWorks_BOM_Export.swp     # SolidWorks VBA macro
│   ├── Process_BOM_for_Expendable.ps1 # PowerShell BOM processor
│   ├── Expendable_UI_Automation.ps1  # UI automation scripts
│   └── Find_Expendable_Database.ps1  # Database discovery
└── Templates/
    └── SolidWorks_Custom_Properties_Template.txt
```

## 🔍 ERP Detection Results

The tool successfully detects:
- **Process Name**: `ESIMRP`
- **Window Title**: `"Expandable"`
- **Status**: ✅ Running and ready for automation

## ⚙️ How It Works

### 1. BOM Export from SolidWorks
- Use the included SolidWorks macro (`Scripts/SolidWorks_BOM_Export.swp`)
- Export BOM data as CSV from your assembly
- Macro extracts custom properties and component information

### 2. Data Processing
- PowerShell scripts process the raw BOM data
- Maps SolidWorks fields to Expendable ERP format
- Handles data validation and formatting

### 3. ERP Integration
- **UI Automation**: Automated data entry into Expendable ERP interface
- **Database Direct**: Optional direct database access (advanced users)
- **Manual Reference**: Structured CSV for manual entry

## 🛠️ System Requirements

- **Windows 10/11**
- **SolidWorks 2022** (or compatible version)
- **PowerShell 5.0+**
- **Expendable ERP** (ESIMRP) running
- **Git Bash** (recommended) or Windows Command Prompt

## 📋 Configuration

Edit `config.json` for your specific requirements:

```json
{
  "expendable_settings": {
    "default_category": "Parts",
    "default_location": "Main Warehouse", 
    "currency_symbol": "$",
    "date_format": "MM/dd/yyyy"
  },
  "field_mapping": {
    "part_number": "Part Number",
    "description": "Description", 
    "quantity": "Quantity"
  }
}
```

## 🔧 Troubleshooting

### PowerShell Execution Policy Issues
If you encounter script execution errors:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ERP Not Detected
1. Ensure Expendable ERP (ESIMRP) is running
2. Check the window title shows "Expandable"
3. Run option 2 in the launcher to verify detection

### BOM Processing Issues
1. Verify SolidWorks assembly is open
2. Check custom properties are set in parts
3. Ensure BOM export completed successfully

## 🎯 Workflow

1. **Prepare**: Open your SolidWorks assembly
2. **Export**: Run the SolidWorks BOM export macro
3. **Launch**: Start `./run_windows_tools.sh`
4. **Detect**: Use option 2 to verify ERP detection
5. **Process**: Use option 3 to run BOM processing
6. **Complete**: Data is transferred to Expendable ERP

## 📝 Notes

- This tool uses UI automation to interact with Expendable ERP
- Ensure ERP is in the correct screen/mode before running automation
- Test with small datasets first before processing large BOMs
- The tool is designed specifically for the ESIMRP version of Expendable ERP

## 🔄 Version History

- **v2.0** - Streamlined interface, working ERP detection
- **v1.3** - UI automation integration  
- **v1.2** - Configuration file support
- **v1.1** - Expendable ERP formatting
- **v1.0** - Initial BOM export functionality

---

**Last Updated**: $(Get-Date)  
**Compatible with**: SolidWorks 2022, Expendable ERP (ESIMRP), Windows 10/11 