<#
.SYNOPSIS
    Export Active Directory groups.

.DESCRIPTION
    Exports on-premises Active Directory groups.

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
function Export-ADGroups { [CmdletBinding()] param([string]$OutputPath='./reports/csv/ad-groups.csv') Import-Module ActiveDirectory; Get-ADGroup -Filter * -Properties Description,GroupCategory,GroupScope | Select-Object Name,SamAccountName,Description,GroupCategory,GroupScope | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }