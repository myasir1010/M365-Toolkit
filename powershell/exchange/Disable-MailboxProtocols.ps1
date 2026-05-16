<#
.SYNOPSIS
    Disable mailbox client protocols.

.DESCRIPTION
    Disables POP, IMAP, ActiveSync, OWA, MAPI, EWS and SMTP client auth where supported.

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
function Disable-MailboxProtocols { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity) if ($PSCmdlet.ShouldProcess($Identity,'Disable mailbox protocols')) { Set-CASMailbox -Identity $Identity -PopEnabled:$false -ImapEnabled:$false -ActiveSyncEnabled:$false -OWAEnabled:$false -MAPIEnabled:$false -EwsEnabled:$false -SmtpClientAuthenticationDisabled:$true } }