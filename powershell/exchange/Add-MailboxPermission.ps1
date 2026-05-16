<#
.SYNOPSIS
    Add mailbox permission.

.DESCRIPTION
    Grants FullAccess permission to a mailbox.

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
function Add-MailboxPermissionToolkit { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity,[Parameter(Mandatory)][string]$User,[string[]]$AccessRights=@('FullAccess')) if ($PSCmdlet.ShouldProcess($Identity,"Grant $($AccessRights -join ',') to $User")) { Add-MailboxPermission -Identity $Identity -User $User -AccessRights $AccessRights -InheritanceType All } }