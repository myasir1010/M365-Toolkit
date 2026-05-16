<#
.SYNOPSIS
    Export Active Directory users.

.DESCRIPTION
    Exports on-premises Active Directory users.

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
function Export-ADUsers { [CmdletBinding()] param([string]$OutputPath='./reports/csv/ad-users.csv') Import-Module ActiveDirectory; Get-ADUser -Filter * -Properties DisplayName,Mail,Department,Title,Enabled,LastLogonDate | Select-Object SamAccountName,UserPrincipalName,DisplayName,Mail,Department,Title,Enabled,LastLogonDate | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }