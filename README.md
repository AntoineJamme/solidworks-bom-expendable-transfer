# SolidWorks BOM Export Macro

A SolidWorks VBA macro for exporting Bill of Materials (BOM) data from assemblies to CSV format and Expendable ERP text files.

## 🚀 Quick Start

### 1. Set Export Location
**IMPORTANT**: Before running the macro, edit line 13 to set your preferred export location:
```vba
Const EXPORT_PATH As String = "C:\Your\Desired\Path\"
```
Make sure to include the trailing backslash and ensure the folder exists.

### 2. Load and Run the Macro
1. Open SolidWorks and your assembly document
2. Go to **Tools** → **Macro** → **Run...**
3. Select the `SW_BOM_Export.swb` file
4. Click **Run**

## 📋 What the Macro Exports

The macro creates three files from your assembly:

1. **Indented BOM (CSV)**: `{AssemblyName}_IndentedBOM_{timestamp}.csv`
   - Hierarchical BOM with indentation showing assembly structure
   - Columns: ITEM NO., PART NUMBER, DESCRIPTION, QTY.

2. **Parts Master (ICUPM)**: `{AssemblyName}_ICUPM_{timestamp}.txt`
   - Tab-separated values for Expendable ERP Parts Master
   - Columns: PART_ID, PART_DESC, Processed Flag

3. **Bill of Material (PDUBM)**: `{AssemblyName}_PDUBM_{timestamp}.txt`
   - Tab-separated values for Expendable ERP BOM
   - Columns: PARENT_PART_ID, COMPONENT_PART_ID, QTY_PER, Processed Flag

## 📝 Notes

- Only parts with numeric-only part numbers (including dashes and dots) are exported
- Parts with letters in their part numbers are automatically excluded
- Suppressed components are automatically excluded
- Part numbers are extracted from the "PartNo" custom property or filename
- Descriptions are extracted from the "Description" custom property