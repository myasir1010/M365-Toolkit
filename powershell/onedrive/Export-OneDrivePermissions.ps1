<#
.SYNOPSIS
    Export OneDrive permissions.

.DESCRIPTION
    Exports OneDrive site collection administrators to a CSV file using PnP PowerShell.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OneDriveUrl
    The OneDrive site URL to inspect.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-OneDrivePermissions `
        -OneDriveUrl "https://contoso-my.sharepoint.com/personal/john_doe_contoso_com"

.EXAMPLE
    Export-OneDrivePermissions `
        -OneDriveUrl "https://contoso-my.sharepoint.com/personal/john_doe_contoso_com" `
        -OutputPath ".\reports\csv\onedrive-permissions.csv"

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.
    Requires SharePoint administrator or OneDrive site collection administrator permissions.
#>

function Export-OneDrivePermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$OneDriveUrl,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\onedrive-permissions.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
            throw "The PnP.PowerShell module is not installed. Install it using: Install-Module PnP.PowerShell -Scope CurrentUser"
        }

        Import-Module PnP.PowerShell -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
    }

    process {
        try {
            Connect-PnPOnline `
                -Url $OneDriveUrl `
                -Interactive `
                -ErrorAction Stop

            $admins = Get-PnPSiteCollectionAdmin -ErrorAction Stop |
                Select-Object `
                    @{ Name = "OneDriveUrl"; Expression = { $OneDriveUrl } },
                    Title,
                    LoginName,
                    Email,
                    PrincipalType,
                    IsSiteAdmin

            $admins |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "OneDrive permissions exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export OneDrive permissions for '$OneDriveUrl'. $($_.Exception.Message)"
        }
    }
}