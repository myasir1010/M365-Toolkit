<#
.SYNOPSIS
    Get device compliance report.

.DESCRIPTION
    Exports device compliance-related fields from Entra ID using Microsoft Graph
    and saves the report to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Get-DeviceComplianceReport

.EXAMPLE
    Get-DeviceComplianceReport -OutputPath ".\reports\csv\device-compliance.csv"

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - Device.Read.All
#>

function Get-DeviceComplianceReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\device-compliance.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.DirectoryManagement)) {
            throw "The Microsoft.Graph.Identity.DirectoryManagement module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
    }

    process {
        try {
            Get-MgDevice `
                -All `
                -Property Id, DisplayName, OperatingSystem, OperatingSystemVersion, IsManaged, IsCompliant, ApproximateLastSignInDateTime, AccountEnabled |
                Select-Object `
                    Id,
                    DisplayName,
                    OperatingSystem,
                    OperatingSystemVersion,
                    IsManaged,
                    IsCompliant,
                    AccountEnabled,
                    ApproximateLastSignInDateTime |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Device compliance report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export device compliance report. $($_.Exception.Message)"
        }
    }
}