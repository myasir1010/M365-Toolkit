<#
.SYNOPSIS
    Disable SharePoint external sharing.

.DESCRIPTION
    Disables external sharing for a selected SharePoint Online site using PnP PowerShell.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER SiteUrl
    The SharePoint Online site URL where external sharing will be disabled.

.EXAMPLE
    Disable-SharePointExternalSharing `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha"

.EXAMPLE
    Disable-SharePointExternalSharing `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    Connect to the SharePoint Online admin center before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Disable-SharePointExternalSharing {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUrl
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
            throw "The PnP.PowerShell module is not installed. Install it using: Install-Module PnP.PowerShell -Scope CurrentUser"
        }

        Import-Module PnP.PowerShell -ErrorAction Stop

        if (-not (Get-Command -Name Set-PnPTenantSite -ErrorAction SilentlyContinue)) {
            throw "Set-PnPTenantSite is not available. Connect to the SharePoint Online admin center using Connect-PnPOnline."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($SiteUrl, "Disable SharePoint external sharing")) {
                Set-PnPTenantSite `
                    -Url $SiteUrl `
                    -SharingCapability Disabled `
                    -ErrorAction Stop

                Write-Host "Successfully disabled external sharing for SharePoint site: $SiteUrl" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to disable external sharing for SharePoint site '$SiteUrl'. $($_.Exception.Message)"
        }
    }
}