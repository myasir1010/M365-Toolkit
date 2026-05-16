<#
.SYNOPSIS
    Disable Active Directory user account.

.DESCRIPTION
    Disables an on-premises AD user.

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
function Disable-ADUserAccount { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity) Import-Module ActiveDirectory; if($PSCmdlet.ShouldProcess($Identity,'Disable AD user')){ Disable-ADAccount -Identity $Identity } }