<#
.SYNOPSIS
    Archive a SharePoint site.

.DESCRIPTION
    Sets a SharePoint site to read-only lock state.

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
function Archive-SharePointSite { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$SiteUrl) if($PSCmdlet.ShouldProcess($SiteUrl,'Archive SharePoint site')){ Set-PnPTenantSite -Url $SiteUrl -LockState ReadOnly } }