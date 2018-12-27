# 5.4.X - 2018-12-27
## What's new
* `Export-Excel` [DataTable] support and improved performance. To use the acceleration you need to provide the DataTable to Export-Excel.
When you pipe the DataTable to Export-Excel PowerShell "unrolls" it passing the individual DataRows one by one.
To prevent this you can use the -TargetData switch explicitly `Export-Excel -TargetData $DataTable` or pipe with ", " before your variable `, $DataTable | Export-Excel`. This also prevent the creation of the extra [DataRows] columns "RowError", "RowState", "Table", "ItemArray", "HasErrors".

* `Export-Excel` Added Parameter `-Table [Switch]`, To enable creating a Table without setting -TableName. The table name will be "Table[N]" or with name from the [DataTable] if exists. Table can be created by passing -TableName and/or -TableStyle and/or -Table.

* `Export-Excel` Added Parameter `-AutoSizeFirst [Int]`, It’s the same as -AutoSize but let you limit the number of checked lines to improve performance.

* `Export-Excel -New` now supports -TableName, -TableStyle and -Table.
  
### Added
* Excluded .vscode/settings.json.
* DoTests.ps1 Updates Pester if version under 4.0.0
* Export-Excel, Added DataRow Warning "You are passing DataRows to Export-Excel, consider passing DataTable for better performance and compatibility".
* Added Examples DataTableAndAutoSizePerformance.ps1
* Added Tests for [DataTable] in Export-Excel.Tests.ps1
* Added Tests for -AutoSizeFirst in Export-Excel.Tests.ps1
* Added Tests for "Help New-Plot" in unctionAlias.tests.ps1
* Added Test file Send-SqlDataToExcel.tests.ps1, it tests DataTable and that the parameters of Export-Excel exists.
### Changed
* Send-SqlDataToExcel uses Export-Excel DataTable support instead of its one implementation. probably fixed some things and added some more native Export-Excel functionality as a side effect.
### Fixed
* Fix Test accidentally closing VSCode if focus not switched to Out-GridView.
* Fix Test randomly fails depending on your running processes order as not all processes have StartTime.
* Send-SqlDataToExcel was missing parameters that was added to Export-Excel. Also ParameterSets was fixed.
* Send-SqlDataToExcel Time formatting now works.