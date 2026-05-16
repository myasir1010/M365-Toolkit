<#
.SYNOPSIS
    Disable a Microsoft 365 user.

.DESCRIPTION
    Blocks user sign-in using Microsoft Graph.

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
function Disable-M365User {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$UserPrincipalName)
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Disable account')) { Update-MgUser -UserId $UserPrincipalName -AccountEnabled:$false }
}
r