<#
.SYNOPSIS
    Grant OneDrive access.

.DESCRIPTION
    Adds a user as a site collection administrator to a OneDrive site using PnP PowerShell.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OneDriveUrl
    The OneDrive site URL where access will be granted.

.PARAMETER UserPrincipalName
    The user principal name of the user who will be added as a OneDrive site collection administrator.

.EXAMPLE
    Grant-OneDriveAccess `
        -OneDriveUrl "https://contoso-my.sharepoint.com/personal/john_doe_contoso_com" `
        -UserPrincipalName "manager@contoso.com"

.EXAMPLE
    Grant-OneDriveAccess `
        -OneDriveUrl "https://contoso-my.sharepoint.com/personal/john_doe_contoso_com" `
        -UserPrincipalName "manager@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.
    Connect to the SharePoint Online admin center before running this function.

    Example:
    Connect-PnPOnline -Url "https://contoso-admin.sharepoint.com" -Interactive
#>

function Grant-OneDriveAccess {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$OneDriveUrl,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName
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
            if ($PSCmdlet.ShouldProcess($OneDriveUrl, "Grant OneDrive site collection admin access to $UserPrincipalName")) {
                Set-PnPTenantSite `
                    -Url $OneDriveUrl `
                    -Owners $UserPrincipalName `
                    -ErrorAction Stop

                Write-Host "Successfully granted OneDrive admin access to '$UserPrincipalName' on '$OneDriveUrl'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to grant OneDrive access to '$UserPrincipalName' on '$OneDriveUrl'. $($_.Exception.Message)"
        }
    }
}