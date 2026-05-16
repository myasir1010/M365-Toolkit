<#
.SYNOPSIS
    Add team member.

.DESCRIPTION
    Adds a user to a Microsoft Team group.

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
function Add-TeamMemberToolkit { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$TeamId,[Parameter(Mandatory)][string]$UserPrincipalName) Add-M365GroupMember -GroupId $TeamId -UserPrincipalName $UserPrincipalName }