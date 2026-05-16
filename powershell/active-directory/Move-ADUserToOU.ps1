<#
.SYNOPSIS
    Move AD user to OU.

.DESCRIPTION
    Moves an on-premises AD user to a target OU.

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
function Move-ADUserToOU { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity,[Parameter(Mandatory)][string]$TargetOU) Import-Module ActiveDirectory; $User=Get-ADUser -Identity $Identity; if($PSCmdlet.ShouldProcess($Identity,"Move to $TargetOU")){ Move-ADObject -Identity $User.DistinguishedName -TargetPath $TargetOU } }