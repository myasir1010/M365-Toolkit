<#
.SYNOPSIS
    Connect to SharePoint Online.

.DESCRIPTION
    Connects to SharePoint Online using PnP PowerShell.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Url
    The SharePoint Online site URL or SharePoint admin center URL to connect to.

.PARAMETER InstallModules
    Installs the required PnP.PowerShell module if it is missing.

.EXAMPLE
    Connect-SharePointToolkit -Url "https://contoso-admin.sharepoint.com"

.EXAMPLE
    Connect-SharePointToolkit -Url "https://contoso.sharepoint.com/sites/project-alpha"

.EXAMPLE
    Connect-SharePointToolkit `
        -Url "https://contoso-admin.sharepoint.com" `
        -InstallModules

.NOTES
    Run PowerShell as Administrator when module installation is required.
    Requires SharePoint administrator or site-level permissions depending on the target URL.
    Requires the PnP.PowerShell module.
#>

function Connect-SharePointToolkit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [switch]$InstallModules
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (Get-Command -Name Test-RequiredModule -CommandType Function -ErrorAction SilentlyContinue) {
            Test-RequiredModule `
                -ModuleName "PnP.PowerShell" `
                -InstallIfMissing:$InstallModules
        }
        else {
            if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
                if ($InstallModules) {
                    Install-Module `
                        -Name PnP.PowerShell `
                        -Scope CurrentUser `
                        -Force `
                        -AllowClobber `
                        -ErrorAction Stop
                }
                else {
                    throw "The PnP.PowerShell module is not installed. Run with -InstallModules or install it manually."
                }
            }

            Import-Module PnP.PowerShell -ErrorAction Stop
        }
    }

    process {
        try {
            Connect-PnPOnline `
                -Url $Url `
                -Interactive `
                -ErrorAction Stop

            Write-Host "Connected to SharePoint Online successfully: $Url" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to connect to SharePoint Online at '$Url'. $($_.Exception.Message)"
        }
    }
}