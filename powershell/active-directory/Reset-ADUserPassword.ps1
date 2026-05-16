<#
.SYNOPSIS
    Reset AD user password.

.DESCRIPTION
    Resets an on-premises AD user password.

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
function Reset-ADUserPassword { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity,[Parameter(Mandatory)][string]$NewPassword) Import-Module ActiveDirectory; $Secure=ConvertTo-SecureString $NewPassword -AsPlainText -Force; if($PSCmdlet.ShouldProcess($Identity,'Reset AD password')){ Set-ADAccountPassword -Identity $Identity -NewPassword $Secure -Reset } }