# SolidWorks BOM Export Macro

A SolidWorks VBA macro for exporting Bill of Materials (BOM) data from assemblies to Expendable ERP text files.

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

The macro creates two files from your assembly:

1. **Parts Master (ICUPM)**: `{AssemblyName}_ICUPM_{timestamp}.txt`
   - Tab-separated values for Expendable ERP Parts Master
   - Columns: PART_ID, PART_DESC, PART_CLASS, PART_TYPE, DWG_REV, ORIG_REL_DATE, Processed Flag
   - **Part Type**: Automatically determined as "B" (Buy) or "M" (Make) based on business rules
   - **Part Class**: Automatically determined as "PC" (Pure Component), "FC" (Fabricated Component), "SA" (Sub-Assembly), or "TA" (Top Assembly)

2. **Bill of Material (PDUBM)**: `{AssemblyName}_PDUBM_{timestamp}.txt`
   - Tab-separated values for Expendable ERP BOM
   - Columns: ASSEMBLY_ID, COMPONENT_ID, REQUIRED_QTY, Processed Flag

## 🔧 Part Type and Part Class Logic

The macro automatically determines Part Type and Part Class based on your business rules:

### Part Type (B/M):
- **"M" (Make)**: Parts with "SEE BOM" in their Material custom property
- **"B" (Buy)**: Off-the-shelf components starting with "0" (e.g., "004-0306-2", "123-456")
- **"B" (Buy)**: Everything else (default)

### Part Class (PC/FC/SA/TA):
- **"PC" (Pure Component)**: Off-the-shelf components starting with "0"
- **"TA" (Top Assembly)**: The main assembly the macro is run on (if it's type "M")
- **"SA" (Sub-Assembly)**: All other "M" parts except the top assembly
- **"FC" (Fabricated Component)**: Everything else (default)

### Examples:
- `004-0306-2` → Type: "B", Class: "PC" (off-the-shelf component)
- `0123-456` → Type: "B", Class: "PC" (off-the-shelf component)
- `128-031213-001` with "SEE BOM" in Material → Type: "M", Class: "TA" (if top assembly) or "SA" (if sub-assembly)
- `128-031213-002` with regular material → Type: "B", Class: "FC" (fabricated component)

## 📝 Notes

- Only parts with numeric-only part numbers (including dashes and dots) are exported
- Parts with letters in their part numbers are automatically excluded
- Suppressed components are automatically excluded
- Part numbers are extracted from the "PartNo" custom property or filename
- Descriptions are extracted from the "Description" custom property
- Drawing revision is extracted from the "REV" custom property
- Original release date is extracted from the "created_date" custom property