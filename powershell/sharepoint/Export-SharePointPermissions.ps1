<#
.SYNOPSIS
    Export SharePoint permissions.

.DESCRIPTION
    Exports permissions for a selected SharePoint site.

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
function Export-SharePointPermissions { [CmdletBinding()] param([Parameter(Mandatory)][string]$SiteUrl,[string]$OutputPath='./reports/csv/sharepoint-permissions.csv') Connect-PnPOnline -Url $SiteUrl -Interactive; $Groups=Get-PnPGroup; $Report=foreach($G in $Groups){ Get-PnPGroupMember -Identity $G | Select-Object @{n='SiteUrl';e={$SiteUrl}},@{n='Group';e={$G.Title}},Title,LoginName,Email,PrincipalType }; $Report | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }