<#
.SYNOPSIS
    Disable SharePoint external sharing.

.DESCRIPTION
    Disables external sharing for a selected site.

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
function Disable-SharePointExternalSharing { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$SiteUrl) if($PSCmdlet.ShouldProcess($SiteUrl,'Disable external sharing')){ Set-PnPTenantSite -Url $SiteUrl -SharingCapability Disabled } }