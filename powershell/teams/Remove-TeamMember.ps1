<#
.SYNOPSIS
    Remove team member.

.DESCRIPTION
    Removes a user from a Microsoft Team group.

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
function Remove-TeamMemberToolkit { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$TeamId,[Parameter(Mandatory)][string]$UserPrincipalName) Remove-M365GroupMember -GroupId $TeamId -UserPrincipalName $UserPrincipalName }