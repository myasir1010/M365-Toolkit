<#
.SYNOPSIS
    Export OneDrive permissions.

.DESCRIPTION
    Exports OneDrive site collection admins.

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
function Export-OneDrivePermissions { [CmdletBinding()] param([Parameter(Mandatory)][string]$OneDriveUrl,[string]$OutputPath='./reports/csv/onedrive-permissions.csv') Connect-PnPOnline -Url $OneDriveUrl -Interactive; $Admins=Get-PnPSiteCollectionAdmin | Select-Object @{n='OneDriveUrl';e={$OneDriveUrl}},Title,LoginName,Email; $Admins | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }