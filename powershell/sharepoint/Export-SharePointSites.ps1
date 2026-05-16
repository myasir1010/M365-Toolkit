<#
.SYNOPSIS
    Export SharePoint sites.

.DESCRIPTION
    Exports tenant SharePoint site inventory.

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
function Export-SharePointSites { [CmdletBinding()] param([string]$OutputPath='./reports/csv/sharepoint-sites.csv') $Sites=Get-PnPTenantSite -Detailed | Select-Object Url,Title,Template,Owner,StorageUsageCurrent,SharingCapability,LastContentModifiedDate; $Sites | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }