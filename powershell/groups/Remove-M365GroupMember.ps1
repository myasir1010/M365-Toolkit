<#
.SYNOPSIS
    Remove a user from a Microsoft 365 group.

.DESCRIPTION
    Removes a user from a group by display name or group ID.

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

function Remove-M365GroupMember { [CmdletBinding(SupportsShouldProcess)] param([string]$GroupId,[string]$GroupDisplayName,[Parameter(Mandatory)][string]$UserPrincipalName)
    if (-not $GroupId) { $GroupId = (Get-MgGroup -Filter "displayName eq '$GroupDisplayName'" -ConsistencyLevel eventual).Id }
    $User = Get-MgUser -UserId $UserPrincipalName
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Remove from group $GroupId")) { Remove-MgGroupMemberByRef -GroupId $GroupId -DirectoryObjectId $User.Id }
}
