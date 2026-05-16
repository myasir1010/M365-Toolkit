<#
.SYNOPSIS
    Get SharePoint external sharing report.

.DESCRIPTION
    Lists sites with external sharing enabled.

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
function Get-SharePointExternalSharingReport { [CmdletBinding()] param([string]$OutputPath) $Data=Get-PnPTenantSite -Detailed | Where-Object { $_.SharingCapability -ne 'Disabled' } | Select-Object Url,Title,SharingCapability,Owner,LastContentModifiedDate; if($OutputPath){$Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8}; $Data }