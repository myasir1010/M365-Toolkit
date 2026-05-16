<#
.SYNOPSIS
    Export Microsoft 365 guest users.

.DESCRIPTION
    Lists guest users from Entra ID using Microsoft Graph.

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
function Get-M365GuestUsers {
    [CmdletBinding()]
    param([string]$OutputPath)
    $Users = Get-MgUser -All -Filter "userType eq 'Guest'" -Property DisplayName,UserPrincipalName,Mail,CreatedDateTime,AccountEnabled |
        Select-Object DisplayName,UserPrincipalName,Mail,CreatedDateTime,AccountEnabled
    if ($OutputPath) { $Users | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8 }
    $Users
}
r