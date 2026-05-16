<#
.SYNOPSIS
    Export objects as CSV, JSON, or HTML.

.DESCRIPTION
    Writes PowerShell objects to a report file in a selected format.

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

function New-ToolkitReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object[]]$InputObject,
        [Parameter(Mandatory)][string]$OutputPath,
        [ValidateSet('Csv','Json','Html')][string]$Format = 'Csv',
        [string]$Title = 'M365 Toolkit Report'
    )
    $Directory = Split-Path -Path $OutputPath -Parent
    if ($Directory -and -not (Test-Path $Directory)) { New-Item -ItemType Directory -Path $Directory -Force | Out-Null }
    switch ($Format) {
        'Csv' { $InputObject | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8 }
        'Json' { $InputObject | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputPath -Encoding UTF8 }
        'Html' { $InputObject | ConvertTo-Html -Title $Title -PreContent "<h1>$Title</h1>" | Set-Content -Path $OutputPath -Encoding UTF8 }
    }
    Get-Item $OutputPath
}
