<#
.SYNOPSIS
    Set SharePoint site owner.

.DESCRIPTION
    Changes owner for a SharePoint site.

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
function Set-SharePointSiteOwner { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$SiteUrl,[Parameter(Mandatory)][string]$Owner) if($PSCmdlet.ShouldProcess($SiteUrl,"Set owner $Owner")){ Set-PnPTenantSite -Url $SiteUrl -Owner $Owner } }