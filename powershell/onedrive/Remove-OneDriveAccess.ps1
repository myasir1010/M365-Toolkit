<#
.SYNOPSIS
    Remove OneDrive access.

.DESCRIPTION
    Removes a user from the site collection administrators of a OneDrive site
    using PnP PowerShell.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OneDriveUrl
    The OneDrive site URL where admin access will be removed.

.PARAMETER UserPrincipalName
    The user principal name of the user who will be removed as a OneDrive site collection administrator.

.EXAMPLE
    Remove-OneDriveAccess `
        -OneDriveUrl "https://contoso-my.sharepoint.com/personal/john_doe_contoso_com" `
        -UserPrincipalName "manager@contoso.com"

.EXAMPLE
    Remove-OneDriveAccess `
        -OneDriveUrl "https://contoso-my.sharepoint.com/personal/john_doe_contoso_com" `
        -UserPrincipalName "manager@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.

    This function connects directly to the provided OneDrive site URL.
#>

function Remove-OneDriveAccess {
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
    }

    process {
        try {
            Connect-PnPOnline `
                -Url $OneDriveUrl `
                -Interactive `
                -ErrorAction Stop

            if ($PSCmdlet.ShouldProcess($OneDriveUrl, "Remove OneDrive site collection admin access from $UserPrincipalName")) {
                Remove-PnPSiteCollectionAdmin `
                    -Owners $UserPrincipalName `
                    -ErrorAction Stop

                Write-Host "Successfully removed OneDrive admin access from '$UserPrincipalName' on '$OneDriveUrl'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to remove OneDrive access from '$UserPrincipalName' on '$OneDriveUrl'. $($_.Exception.Message)"
        }
    }
}