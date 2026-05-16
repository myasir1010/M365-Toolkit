<#
.SYNOPSIS
    Find users without MFA.

.DESCRIPTION
    Generates MFA report and returns users without multiple authentication methods.

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
function Find-UsersWithoutMFA { [CmdletBinding()] param([string]$OutputPath='./reports/csv/users-without-mfa.csv') $Temp=Join-Path $env:TEMP 'mfa-status.csv'; Get-MFAStatusReport -OutputPath $Temp | Out-Null; $Data=Import-Csv $Temp | Where-Object { $_.MfaRegistered -eq 'False' -and $_.AccountEnabled -eq 'True' }; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }