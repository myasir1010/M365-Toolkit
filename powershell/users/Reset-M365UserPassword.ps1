<#
.SYNOPSIS
    Reset a Microsoft 365 user password.

.DESCRIPTION
    Updates password profile for a cloud user.

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
function Reset-M365UserPassword {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$UserPrincipalName,[Parameter(Mandatory)][string]$NewPassword,[switch]$ForceChangePasswordNextSignIn)
    $Profile = @{ password = $NewPassword; forceChangePasswordNextSignIn = [bool]$ForceChangePasswordNextSignIn }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Reset password')) { Update-MgUser -UserId $UserPrincipalName -PasswordProfile $Profile }
}
r