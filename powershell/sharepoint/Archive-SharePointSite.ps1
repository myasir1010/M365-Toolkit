<#
.SYNOPSIS
    Archive a SharePoint site.

.DESCRIPTION
    Sets a SharePoint Online site to read-only lock state using PnP PowerShell.
    This is useful for archiving inactive or completed project sites while keeping
    the content accessible for reference.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER SiteUrl
    The SharePoint Online site URL to archive.

.EXAMPLE
    Archive-SharePointSite -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha"

.EXAMPLE
    Archive-SharePointSite `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    Connect to the SharePoint Online admin center before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Archive-SharePointSite {
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
            if ($PSCmdlet.ShouldProcess($SiteUrl, "Set SharePoint site lock state to ReadOnly")) {
                Set-PnPTenantSite `
                    -Url $SiteUrl `
                    -LockState ReadOnly `
                    -ErrorAction Stop

                Write-Host "Successfully archived SharePoint site as read-only: $SiteUrl" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to archive SharePoint site '$SiteUrl'. $($_.Exception.Message)"
        }
    }
}