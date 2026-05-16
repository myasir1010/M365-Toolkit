<#
.SYNOPSIS
    Sync group membership from CSV.

.DESCRIPTION
    Adds users from a CSV file to a target group.

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

function Sync-M365GroupMembershipFromCsv { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$CsvPath,[Parameter(Mandatory)][string]$GroupId)
    Import-Csv $CsvPath | ForEach-Object { if ($_.UserPrincipalName) { Add-M365GroupMember -GroupId $GroupId -UserPrincipalName $_.UserPrincipalName } }
}
