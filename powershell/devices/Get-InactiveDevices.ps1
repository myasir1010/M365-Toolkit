<#
.SYNOPSIS
    Find inactive Entra ID devices.

.DESCRIPTION
    Finds Entra ID devices that have not signed in for a selected number of days.
    The result can be displayed in the console and optionally exported to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER InactiveDays
    The number of days a device must be inactive before being included in the report.

.PARAMETER OutputPath
    Optional path where the inactive device report will be exported as a CSV file.

.EXAMPLE
    Get-InactiveDevices

.EXAMPLE
    Get-InactiveDevices -InactiveDays 180

.EXAMPLE
    Get-InactiveDevices -InactiveDays 90 -OutputPath ".\reports\csv\inactive-devices.csv"

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - Device.Read.All
#>

function Get-InactiveDevices {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3650)]
        [int]$InactiveDays = 90,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.DirectoryManagement)) {
            throw "The Microsoft.Graph.Identity.DirectoryManagement module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop

        if ($OutputPath) {
            $outputDirectory = Split-Path -Path $OutputPath -Parent

            if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
                New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
            }
        }

        $cutoffDate = (Get-Date).AddDays(-$InactiveDays)
    }

    process {
        try {
            $inactiveDevices = Get-MgDevice `
                -All `
                -Property Id, DisplayName, DeviceId, OperatingSystem, OperatingSystemVersion, AccountEnabled, IsManaged, IsCompliant, ApproximateLastSignInDateTime |
                Where-Object {
                    $_.ApproximateLastSignInDateTime -and
                    ([datetime]$_.ApproximateLastSignInDateTime) -lt $cutoffDate
                } |
                Select-Object `
                    Id,
                    DisplayName,
                    DeviceId,
                    OperatingSystem,
                    OperatingSystemVersion,
                    AccountEnabled,
                    IsManaged,
                    IsCompliant,
                    ApproximateLastSignInDateTime

            if ($OutputPath) {
                $inactiveDevices |
                    Export-Csv `
                        -Path $OutputPath `
                        -NoTypeInformation `
                        -Encoding UTF8

                Write-Host "Inactive Entra ID devices exported successfully: $OutputPath" -ForegroundColor Green

                return Get-Item -Path $OutputPath
            }

            return $inactiveDevices
        }
        catch {
            Write-Error "Failed to find inactive Entra ID devices. $($_.Exception.Message)"
        }
    }
}