<#
.SYNOPSIS
    Find inactive AD users.

.DESCRIPTION
    Finds AD users inactive for a selected number of days.

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
function Find-InactiveADUsers { [CmdletBinding()] param([int]$InactiveDays=90,[string]$OutputPath='./reports/csv/inactive-ad-users.csv') Import-Module ActiveDirectory; $Cutoff=(Get-Date).AddDays(-$InactiveDays); $Data=Get-ADUser -Filter { LastLogonDate -lt $Cutoff -and Enabled -eq $true } -Properties LastLogonDate,Mail,Department | Select-Object SamAccountName,UserPrincipalName,Mail,Department,LastLogonDate; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }