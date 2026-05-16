<#
.SYNOPSIS
    Get OneDrive usage report.

.DESCRIPTION
    Exports OneDrive usage account details through the Microsoft Graph reports API
    and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Period
    The reporting period to export.
    Valid values are D7, D30, D90, and D180.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Get-OneDriveUsageReport

.EXAMPLE
    Get-OneDriveUsageReport -Period D90

.EXAMPLE
    Get-OneDriveUsageReport `
        -Period D30 `
        -OutputPath ".\reports\csv\onedrive-usage.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - Reports.Read.All
#>

function Get-OneDriveUsageReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("D7", "D30", "D90", "D180")]
        [string]$Period = "D30",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\onedrive-usage.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
            throw "The Microsoft.Graph.Authentication module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
    }

    process {
        try {
            $uri = "https://graph.microsoft.com/v1.0/reports/getOneDriveUsageAccountDetail(period='$Period')"

            Invoke-MgGraphRequest `
                -Method GET `
                -Uri $uri `
                -OutputFilePath $OutputPath `
                -ErrorAction Stop

            Write-Host "OneDrive usage report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export OneDrive usage report. $($_.Exception.Message)"
        }
    }
}