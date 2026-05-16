<#
.SYNOPSIS
    Set mailbox auto-reply.

.DESCRIPTION
    Enables internal and external auto-reply messages.

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
function Set-MailboxAutoReply { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity,[Parameter(Mandatory)][string]$InternalMessage,[string]$ExternalMessage) if (-not $ExternalMessage) { $ExternalMessage=$InternalMessage }; if ($PSCmdlet.ShouldProcess($Identity,'Set mailbox auto-reply')) { Set-MailboxAutoReplyConfiguration -Identity $Identity -AutoReplyState Enabled -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage } }