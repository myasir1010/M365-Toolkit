<#
.SYNOPSIS
    Get SharePoint external sharing report.

.DESCRIPTION
    Lists SharePoint Online sites where external sharing is enabled using PnP PowerShell.
    The result can be displayed in the console and optionally exported to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    Optional path where the SharePoint external sharing report will be exported as a CSV file.

.PARAMETER IncludeOneDriveSites
    Includes OneDrive for Business personal sites in the report.

.EXAMPLE
    Get-SharePointExternalSharingReport

.EXAMPLE
    Get-SharePointExternalSharingReport `
        -OutputPath ".\reports\csv\sharepoint-external-sharing.csv"

.EXAMPLE
    Get-SharePointExternalSharingReport `
        -OutputPath ".\reports\csv\sharepoint-external-sharing.csv" `
        -IncludeOneDriveSites

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    Connect to the SharePoint Online admin center before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Get-SharePointExternalSharingReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath,

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

        if ($OutputPath) {
            $outputDirectory = Split-Path -Path $OutputPath -Parent

            if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
                New-Item `
                    -ItemType Directory `
                    -Path $outputDirectory `
                    -Force | Out-Null
            }
        }
    }

    process {
        try {
            $externalSharingSites = Get-PnPTenantSite `
                -Detailed `
                -IncludeOneDriveSites:$IncludeOneDriveSites `
                -ErrorAction Stop |
                Where-Object {
                    $_.SharingCapability -ne "Disabled"
                } |
                Select-Object `
                    Url,
                    Title,
                    Template,
                    Owner,
                    SharingCapability,
                    StorageUsageCurrent,
                    LockState,
                    LastContentModifiedDate,
                    Status

            if ($OutputPath) {
                $externalSharingSites |
                    Export-Csv `
                        -Path $OutputPath `
                        -NoTypeInformation `
                        -Encoding UTF8

                Write-Host "SharePoint external sharing report exported successfully: $OutputPath" -ForegroundColor Green

                return Get-Item -Path $OutputPath
            }

            return $externalSharingSites
        }
        catch {
            Write-Error "Failed to get SharePoint external sharing report. $($_.Exception.Message)"
        }
    }
}