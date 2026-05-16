<#
.SYNOPSIS
    Get MFA status report.

.DESCRIPTION
    Checks registered authentication methods for users.

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
function Get-MFAStatusReport { [CmdletBinding()] param([string]$OutputPath='./reports/csv/mfa-status.csv') $Users=Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,AccountEnabled; $Report=foreach($U in $Users){ $Methods=(Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/users/$($U.Id)/authentication/methods").value; [pscustomobject]@{DisplayName=$U.DisplayName;UserPrincipalName=$U.UserPrincipalName;AccountEnabled=$U.AccountEnabled;MfaMethodCount=@($Methods).Count;MfaRegistered=(@($Methods).Count -gt 1);Methods=($Methods.'@odata.type' -join ';')} }; $Report|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }