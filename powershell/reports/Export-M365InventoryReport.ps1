<#
.SYNOPSIS
    Export Microsoft 365 inventory report.

.DESCRIPTION
    Runs Microsoft 365 user, group, license, and Entra ID device inventory exports.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputDirectory
    The directory where all Microsoft 365 inventory report CSV files will be saved.

.EXAMPLE
    Export-M365InventoryReport

.EXAMPLE
    Export-M365InventoryReport -OutputDirectory ".\reports\csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    This function expects the following functions to be available:
    - Export-M365Users
    - Export-M365Groups
    - Export-M365LicenseReport
    - Export-EntraDevices
#>

function Export-M365InventoryReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory = ".\reports\csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Test-Path -Path $OutputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $OutputDirectory `
                -Force | Out-Null
        }

        $requiredFunctions = @(
            "Export-M365Users",
            "Export-M365Groups",
            "Export-M365LicenseReport",
            "Export-EntraDevices"
        )

        foreach ($functionName in $requiredFunctions) {
            if (-not (Get-Command -Name $functionName -CommandType Function -ErrorAction SilentlyContinue)) {
                throw "Required function is missing: $functionName. Import the M365Toolkit module first."
            }
        }
    }

    process {
        try {
            Write-Host "Creating Microsoft 365 inventory report..." -ForegroundColor Cyan

            $usersReport = Export-M365Users `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "m365-users.csv")

            $groupsReport = Export-M365Groups `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "m365-groups.csv")

            $licensesReport = Export-M365LicenseReport `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "m365-license-report.csv")

            $devicesReport = Export-EntraDevices `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "entra-devices.csv")

            Write-Host "Microsoft 365 inventory report created successfully." -ForegroundColor Green

            [PSCustomObject]@{
                OutputDirectory = (Resolve-Path -Path $OutputDirectory).Path
                UsersReport     = $usersReport.FullName
                GroupsReport    = $groupsReport.FullName
                LicensesReport  = $licensesReport.FullName
                DevicesReport   = $devicesReport.FullName
                GeneratedAt     = Get-Date
            }
        }
        catch {
            Write-Error "Failed to create Microsoft 365 inventory report. $($_.Exception.Message)"
        }
    }
}