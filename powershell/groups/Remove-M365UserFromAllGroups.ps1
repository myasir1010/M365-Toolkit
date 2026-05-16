<#
.SYNOPSIS
    Remove a user from all groups.

.DESCRIPTION
    Removes a Microsoft 365 user from direct group memberships.

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
function Remove-M365UserFromAllGroups { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$UserPrincipalName)
    $User = Get-MgUser -UserId $UserPrincipalName
    $Groups = Get-MgUserMemberOf -UserId $User.Id -All | Where-Object { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.group' }
    foreach ($Group in $Groups) { if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Remove from $($Group.Id)")) { try { Remove-MgGroupMemberByRef -GroupId $Group.Id -DirectoryObjectId $User.Id } catch { Write-Warning $_.Exception.Message } } }
}
r