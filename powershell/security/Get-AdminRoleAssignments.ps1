<#
.SYNOPSIS
    Get admin role assignments.

.DESCRIPTION
    Exports directory role assignments.

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
function Get-AdminRoleAssignments { [CmdletBinding()] param([string]$OutputPath='./reports/csv/admin-role-assignments.csv') $Roles=Get-MgDirectoryRole -All; $Report=foreach($R in $Roles){ Get-MgDirectoryRoleMember -DirectoryRoleId $R.Id -All | Select-Object @{n='Role';e={$R.DisplayName}},Id,AdditionalProperties }; $Report|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }