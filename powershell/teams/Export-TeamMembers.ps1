<#
.SYNOPSIS
    Export team members.

.DESCRIPTION
    Exports members of a selected Team by group ID.

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
function Export-TeamMembers { [CmdletBinding()] param([Parameter(Mandatory)][string]$TeamId,[string]$OutputPath='./reports/csv/team-members.csv') $Members=Get-MgGroupMember -GroupId $TeamId -All | Select-Object Id,AdditionalProperties; $Members | ConvertTo-Json -Depth 10 | Set-Content $OutputPath -Encoding UTF8; Get-Item $OutputPath }