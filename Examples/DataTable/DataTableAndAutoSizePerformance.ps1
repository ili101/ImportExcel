try {. $PSScriptRoot\..\..\LoadPSD1.ps1} catch {}
$Path = "$env:TEMP\Results.xlsx"

# Generate big DataTable test data.
$Date = Get-Date
$Time = [TimeSpan]::FromHours(16)
$DataTable = [Data.DataTable]::new('Test')
$null = $DataTable.Columns.Add('IDD', [Int32])
$null = $DataTable.Columns.Add('Name')
$null = $DataTable.Columns.Add('Junk')
$null = $DataTable.Columns.Add('IntT', [Int32])
$null = $DataTable.Columns.Add('Date', [DateTime])
$null = $DataTable.Columns.Add('Time', [TimeSpan])
for ($I = 0; $I -lt 10000; $I++) {
    $null = $DataTable.Rows.Add($I, 'Test', 'A' * (Get-Random -Maximum 100), $I * 1000, $Date.AddHours($I), $Time)
}

# Without DataTable acceleration.
Remove-Item -Path $Path -ErrorAction SilentlyContinue
Measure-Command {
    $DataTable | Export-Excel -Path $Path -Table
}
# TotalSeconds: ~20

<# With DataTable acceleration.
To use the acceleration you need to provide the DataTable to Export-Excel.
When you pipe the DataTable to Export-Excel PowerShell "unrolls" it passing the individual DataRows one by one.
To prevent this you can use the -TargetData switch explicitly "Export-Excel -TargetData $DataTable" 
or pipe with ", " before your variable ", $DataTable | Export-Excel".
#>
Remove-Item -Path $Path -ErrorAction SilentlyContinue
Measure-Command {
    Export-Excel -TargetData $DataTable -Path $Path -Table
}
# TotalSeconds: ~0.5

# Lets go 100 times bigger!
for ($I = 0; $I -lt 1000000; $I++) {
    $null = $DataTable.Rows.Add($I, 'Test', 'A' * (Get-Random -Maximum 100), $I * 1000, $Date.AddHours($I), $Time)
}

# And add -AutoSize.
Remove-Item -Path $Path -ErrorAction SilentlyContinue
Measure-Command {
    Export-Excel -TargetData $DataTable -Path $Path -Table -AutoSize
}
# TotalSeconds: ~80

# Now replace -AutoSize with -AutoSizeFirst 100. AutoSizeFirst will limit the number of evaluated rows to the given number.
Remove-Item -Path $Path -ErrorAction SilentlyContinue
Measure-Command {
    Export-Excel -TargetData $DataTable -Path $Path -Table -AutoSizeFirst 100
}
# TotalSeconds: ~35
