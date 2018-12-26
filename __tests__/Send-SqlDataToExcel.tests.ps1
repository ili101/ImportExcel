#Requires -Modules Pester

Describe 'Send-SqlDataToExcel' {
    Context 'Check params' {
        $ExportExcelParameters = (Get-Command Export-Excel).Parameters
        $OpenExcelPackageParameters = (Get-Command Send-SqlDataToExcel).Parameters

        It 'Check if all Export-Excel params are present' {
            foreach ($ExportExcelParameter in $ExportExcelParameters.Values) {
                if ($ExportExcelParameter.Name -ne 'TargetData') {
                    $OpenExcelPackageParameter = $OpenExcelPackageParameters.Item($ExportExcelParameter.Name)
                    $ExportExcelParameter.ParameterType | Should -Be $OpenExcelPackageParameter.ParameterType
                    $ExportExcelParameter.ParameterSets.Keys | ForEach-Object {$OpenExcelPackageParameter.ParameterSets.Keys -join ', ' | Should -BeLike "*$_*"}
                }
            }
        }
    }

    Context "DataTable" {
        $path = "$Env:TEMP\test.xlsx"

        $Date = Get-Date
        $Time = [TimeSpan]::FromHours(16)
        $DataTable = [Data.DataTable]::new('Test')
        $null = $DataTable.Columns.Add('IDD', [Int32])
        $null = $DataTable.Columns.Add('Name')
        $null = $DataTable.Columns.Add('Junk')
        $null = $DataTable.Columns.Add('IntT', [Int32])
        $null = $DataTable.Columns.Add('Date', [DateTime])
        $null = $DataTable.Columns.Add('Time', [TimeSpan])
        $null = $DataTable.Rows.Add(1, 'A', 'AAA', 5, $Date, $Time)
        $null = $DataTable.Rows.Add(3, '6', $null, $null, $null, $null)

        Remove-Item -Path $path -ErrorAction SilentlyContinue
        Send-SqlDataToExcel -Path $Path -DataTable $DataTable -Table

        $excel = Open-ExcelPackage -Path $path
        $ws = $excel.Workbook.Worksheets[1]

        it 'Tables Name' {
            $DataTable.TableName | Should -BeExactly 'Test'
            $ws.Tables.Count | Should -BeExactly 1
            $ws.Tables[0].Name | Should -BeExactly $DataTable.TableName
        }
    }
}