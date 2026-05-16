<#
.SYNOPSIS
    Export SharePoint sites.

.DESCRIPTION
    Exports SharePoint Online tenant site inventory using PnP PowerShell
    and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.PARAMETER IncludeOneDriveSites
    Includes OneDrive for Business personal sites in the export.

.EXAMPLE
    Export-SharePointSites

.EXAMPLE
    Export-SharePointSites -OutputPath ".\reports\csv\sharepoint-sites.csv"

.EXAMPLE
    Export-SharePointSites -IncludeOneDriveSites

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    Connect to the SharePoint Online admin center before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Export-SharePointSites {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\sharepoint-sites.csv",

        [Parameter(Mandatory = $false)]
        [switch]$IncludeOneDriveSites
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
            throw "The PnP.PowerShell module is not installed. Install it using: Install-Module PnP.PowerShell -Scope CurrentUser"
        }

        Import-Module PnP.PowerShell -ErrorAction Stop

        if (-not (Get-Command -Name Get-PnPTenantSite -ErrorAction SilentlyContinue)) {
            throw "Get-PnPTenantSite is not available. Connect to the SharePoint Online admin center using Connect-PnPOnline."
        }

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $outputDirectory `
                -Force | Out-Null
        }
    }

    process {
        try {
            $sites = Get-PnPTenantSite `
                -Detailed `
                -IncludeOneDriveSites:$IncludeOneDriveSites `
                -ErrorAction Stop |
                Select-Object `
                    Url,
                    Title,
                    Template,
                    Owner,
                    StorageUsageCurrent,
                    StorageQuota,
                    SharingCapability,
                    LockState,
                    LastContentModifiedDate,
                    Status

            $sites |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "SharePoint sites exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export SharePoint sites. $($_.Exception.Message)"
        }
    }
}