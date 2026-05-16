<#
.SYNOPSIS
    Find inactive AD computers.

.DESCRIPTION
    Finds AD computers inactive for a selected number of days.

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
function Find-InactiveADComputers { [CmdletBinding()] param([int]$InactiveDays=90,[string]$OutputPath='./reports/csv/inactive-ad-computers.csv') Import-Module ActiveDirectory; $Cutoff=(Get-Date).AddDays(-$InactiveDays); $Data=Get-ADComputer -Filter { LastLogonDate -lt $Cutoff -and Enabled -eq $true } -Properties LastLogonDate,OperatingSystem | Select-Object Name,DNSHostName,OperatingSystem,LastLogonDate; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }