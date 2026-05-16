<#
.SYNOPSIS
    Export Microsoft Teams.

.DESCRIPTION
    Exports teams using Microsoft Graph group metadata.

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
function Export-Teams { [CmdletBinding()] param([string]$OutputPath='./reports/csv/teams.csv') $Teams=Get-MgGroup -All -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" -Property Id,DisplayName,Mail,CreatedDateTime,Visibility | Select-Object Id,DisplayName,Mail,CreatedDateTime,Visibility; $Teams | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }