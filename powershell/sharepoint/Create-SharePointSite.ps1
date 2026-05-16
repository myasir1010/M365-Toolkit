<#
.SYNOPSIS
    Create a SharePoint site.

.DESCRIPTION
    Creates a modern SharePoint Online team site using PnP PowerShell.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Title
    The display title of the SharePoint site.

.PARAMETER Alias
    The site alias used for the Microsoft 365 group and site URL.

.PARAMETER Owner
    The user principal name of the site owner.

.EXAMPLE
    Create-SharePointSite `
        -Title "Project Alpha" `
        -Alias "project-alpha" `
        -Owner "owner@contoso.com"

.EXAMPLE
    Create-SharePointSite `
        -Title "Project Alpha" `
        -Alias "project-alpha" `
        -Owner "owner@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    Connect to SharePoint Online before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Create-SharePointSite {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[a-zA-Z0-9-]+$")]
        [string]$Alias,

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

        if (-not (Get-Command -Name New-PnPSite -ErrorAction SilentlyContinue)) {
            throw "New-PnPSite is not available. Connect to SharePoint Online using Connect-PnPOnline first."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($Title, "Create modern SharePoint team site with alias '$Alias'")) {
                $site = New-PnPSite `
                    -Type TeamSite `
                    -Title $Title `
                    -Alias $Alias `
                    -Owner $Owner `
                    -ErrorAction Stop

                Write-Host "Successfully created SharePoint team site: $Title" -ForegroundColor Green

                return $site
            }
        }
        catch {
            Write-Error "Failed to create SharePoint site '$Title'. $($_.Exception.Message)"
        }
    }
}