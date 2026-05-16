<#
.SYNOPSIS
    Remove stale Entra ID devices.

.DESCRIPTION
    Removes Entra ID devices that have not signed in for a selected number of days.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER InactiveDays
    The number of days a device must be inactive before being removed.

.EXAMPLE
    Remove-StaleDevices

.EXAMPLE
    Remove-StaleDevices -InactiveDays 180

.EXAMPLE
    Remove-StaleDevices -InactiveDays 180 -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - Device.Read.All
    - Device.ReadWrite.All

    This function expects Get-InactiveDevices to be available.
#>

function Remove-StaleDevices {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3650)]
        [int]$InactiveDays = 180
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.DirectoryManagement)) {
            throw "The Microsoft.Graph.Identity.DirectoryManagement module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop

        if (-not (Get-Command -Name Get-InactiveDevices -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Get-InactiveDevices. Import the M365Toolkit module first."
        }
    }

    process {
        try {
            $devices = Get-InactiveDevices -InactiveDays $InactiveDays

            if (-not $devices) {
                Write-Host "No stale Entra ID devices found for the selected threshold: $InactiveDays days." -ForegroundColor Yellow
                return
            }

            foreach ($device in $devices) {
                $deviceName = if ($device.DisplayName) { $device.DisplayName } else { $device.Id }

                if ($PSCmdlet.ShouldProcess($deviceName, "Remove stale Entra ID device")) {
                    Remove-MgDevice `
                        -DeviceId $device.Id `
                        -ErrorAction Stop

                    Write-Host "Removed stale Entra ID device: $deviceName" -ForegroundColor Green
                }
            }
        }
        catch {
            Write-Error "Failed to remove stale Entra ID devices. $($_.Exception.Message)"
        }
    }
}