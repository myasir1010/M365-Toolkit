<#
.SYNOPSIS
    Convert mailbox to shared mailbox.

.DESCRIPTION
    Converts a user mailbox to a shared mailbox.

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
function Convert-MailboxToShared { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Identity) if ($PSCmdlet.ShouldProcess($Identity,'Convert mailbox to shared')) { Set-Mailbox -Identity $Identity -Type Shared } }