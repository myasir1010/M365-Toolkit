<#
.SYNOPSIS
    Set SharePoint site owner.

.DESCRIPTION
    Changes the primary owner of a SharePoint Online site using PnP PowerShell.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER SiteUrl
    The SharePoint Online site URL where the owner will be changed.

.PARAMETER Owner
    The user principal name of the new site owner.

.EXAMPLE
    Set-SharePointSiteOwner `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha" `
        -Owner "owner@contoso.com"

.EXAMPLE
    Set-SharePointSiteOwner `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha" `
        -Owner "owner@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    Connect to the SharePoint Online admin center before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Set-SharePointSiteOwner {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUrl,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Owner
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
            if ($PSCmdlet.ShouldProcess($SiteUrl, "Set SharePoint site owner to $Owner")) {
                Set-PnPTenantSite `
                    -Url $SiteUrl `
                    -Owner $Owner `
                    -ErrorAction Stop

                Write-Host "Successfully set SharePoint site owner to '$Owner' for site: $SiteUrl" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to set SharePoint site owner for '$SiteUrl'. $($_.Exception.Message)"
        }
    }
}