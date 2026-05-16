<#
.SYNOPSIS
    Create HTML report.

.DESCRIPTION
    Creates an HTML report from CSV input.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure app permissions, delegated permissions, or admin consent before running tenant-level automation.
#>
r
function New-M365HtmlReport { [CmdletBinding()] param([Parameter(Mandatory)][string]$CsvPath,[string]$OutputPath='./reports/html/report.html',[string]$Title='M365 Toolkit Report') $Data=Import-Csv $CsvPath; $Data|ConvertTo-Html -Title $Title -PreContent "<h1>$Title</h1><p>Generated: $(Get-Date)</p>"|Set-Content $OutputPath -Encoding UTF8; Get-Item $OutputPath }