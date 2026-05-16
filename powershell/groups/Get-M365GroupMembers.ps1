<#
.SYNOPSIS
    Get Microsoft 365 group members.

.DESCRIPTION
    Exports group members using Microsoft Graph.

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

function Get-M365GroupMembers { [CmdletBinding()] param([Parameter(Mandatory)][string]$GroupId,[string]$OutputPath)
    $Members = Get-MgGroupMember -GroupId $GroupId -All | ForEach-Object { Get-MgDirectoryObject -DirectoryObjectId $_.Id } | Select-Object Id,AdditionalProperties
    if ($OutputPath) { $Members | ConvertTo-Json -Depth 10 | Set-Content $OutputPath -Encoding UTF8 }
    $Members
}
