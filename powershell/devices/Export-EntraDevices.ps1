<#
.SYNOPSIS
    Export Entra ID devices.

.DESCRIPTION
    Exports Entra ID device inventory from Microsoft Graph to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-EntraDevices

.EXAMPLE
    Export-EntraDevices -OutputPath ".\reports\csv\entra-devices.csv"

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - Device.Read.All
#>

function Export-EntraDevices {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\entra-devices.csv"
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
                -Property Id, DisplayName, OperatingSystem, OperatingSystemVersion, ApproximateLastSignInDateTime, AccountEnabled, IsCompliant, IsManaged |
                Select-Object `
                    Id,
                    DisplayName,
                    OperatingSystem,
                    OperatingSystemVersion,
                    ApproximateLastSignInDateTime,
                    AccountEnabled,
                    IsCompliant,
                    IsManaged |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Entra ID devices exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export Entra ID devices. $($_.Exception.Message)"
        }
    }
}