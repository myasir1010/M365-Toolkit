<#
.SYNOPSIS
    Find inactive Microsoft 365 users.

.DESCRIPTION
    Returns users whose last sign-in is older than a selected number of days.

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
function Get-M365InactiveUsers {
    [CmdletBinding()]
    param([int]$InactiveDays = 90,[string]$OutputPath)
    $Cutoff = (Get-Date).AddDays(-$InactiveDays)
    $Users = Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,AccountEnabled,SignInActivity,CreatedDateTime |
        Where-Object { $_.SignInActivity.LastSignInDateTime -and ([datetime]$_.SignInActivity.LastSignInDateTime) -lt $Cutoff } |
        Select-Object DisplayName,UserPrincipalName,AccountEnabled,CreatedDateTime,@{n='LastSignInDateTime';e={$_.SignInActivity.LastSignInDateTime}}
    if ($OutputPath) { $Users | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8 }
    $Users
}
r