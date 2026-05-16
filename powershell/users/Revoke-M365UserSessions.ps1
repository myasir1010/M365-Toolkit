<#
.SYNOPSIS
    Revoke Microsoft 365 user sessions.

.DESCRIPTION
    Invalidates refresh tokens for a user using Microsoft Graph.

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
function Revoke-M365UserSessions {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$UserPrincipalName)
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Revoke sign-in sessions')) { Revoke-MgUserSignInSession -UserId $UserPrincipalName }
}
r