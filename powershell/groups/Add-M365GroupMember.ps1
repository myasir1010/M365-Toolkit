<#
.SYNOPSIS
    Add a user to a Microsoft 365 group.

.DESCRIPTION
    Adds a user to a group by display name or group ID.

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
function Add-M365GroupMember { [CmdletBinding(SupportsShouldProcess)] param([string]$GroupId,[string]$GroupDisplayName,[Parameter(Mandatory)][string]$UserPrincipalName)
    if (-not $GroupId) { $GroupId = (Get-MgGroup -Filter "displayName eq '$GroupDisplayName'" -ConsistencyLevel eventual).Id }
    $User = Get-MgUser -UserId $UserPrincipalName
    $Ref = @{ '@odata.id' = "https://graph.microsoft.com/v1.0/directoryObjects/$($User.Id)" }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Add to group $GroupId")) { New-MgGroupMemberByRef -GroupId $GroupId -BodyParameter $Ref }
}
r