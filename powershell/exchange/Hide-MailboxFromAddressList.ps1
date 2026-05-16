<#
.SYNOPSIS
    Hide mailbox from address list.

.DESCRIPTION
    Hides a mailbox from Exchange address lists.

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
function Hide-MailboxFromAddressList { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity) if ($PSCmdlet.ShouldProcess($Identity,'Hide mailbox from address list')) { Set-Mailbox -Identity $Identity -HiddenFromAddressListsEnabled $true } }