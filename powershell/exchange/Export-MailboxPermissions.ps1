<#
.SYNOPSIS
    Export mailbox permissions.

.DESCRIPTION
    Exports mailbox FullAccess permissions.

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
function Export-MailboxPermissions { [CmdletBinding()] param([string]$OutputPath='./reports/csv/mailbox-permissions.csv') $Mailboxes=Get-EXOMailbox -ResultSize Unlimited; $Report=foreach($M in $Mailboxes){ Get-MailboxPermission -Identity $M.UserPrincipalName | Where-Object { -not $_.IsInherited -and $_.User -notlike 'NT AUTHORITY*' } | Select-Object @{n='Mailbox';e={$M.UserPrincipalName}},User,AccessRights,Deny,IsInherited }; $Report | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }