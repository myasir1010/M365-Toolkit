<#
.SYNOPSIS
    Remove OneDrive access.

.DESCRIPTION
    Removes a site collection admin from OneDrive using PnP.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure app permissions, delegated permissions, or admin consent before running tenant-level automation.
#>
r
function Remove-OneDriveAccess { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$OneDriveUrl,[Parameter(Mandatory)][string]$UserPrincipalName) if($PSCmdlet.ShouldProcess($OneDriveUrl,"Remove admin $UserPrincipalName")){ Remove-PnPSiteCollectionAdmin -Owners $UserPrincipalName } }