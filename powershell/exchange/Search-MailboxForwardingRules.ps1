<#
.SYNOPSIS
    Search mailbox forwarding rules.

.DESCRIPTION
    Finds mailboxes with mailbox-level forwarding configured.

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
function Search-MailboxForwardingRules { [CmdletBinding()] param([string]$OutputPath) $Data=Get-EXOMailbox -ResultSize Unlimited -Properties ForwardingSmtpAddress,ForwardingAddress,DeliverToMailboxAndForward | Where-Object { $_.ForwardingSmtpAddress -or $_.ForwardingAddress } | Select-Object DisplayName,UserPrincipalName,ForwardingSmtpAddress,ForwardingAddress,DeliverToMailboxAndForward; if($OutputPath){$Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8}; $Data }