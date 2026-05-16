<#
.SYNOPSIS
    Set mailbox auto-reply.

.DESCRIPTION
    Enables internal and external auto-reply messages for an Exchange Online mailbox.
    If no external message is provided, the internal message is used for both
    internal and external auto-replies.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The mailbox identity where auto-reply will be configured.
    Accepts mailbox alias, email address, user principal name, or distinguished name.

.PARAMETER InternalMessage
    The internal auto-reply message.

.PARAMETER ExternalMessage
    The external auto-reply message.
    If omitted, the internal message will also be used externally.

.EXAMPLE
    Set-MailboxAutoReply `
        -Identity "john.doe@contoso.com" `
        -InternalMessage "John Doe is no longer with the company. Please contact support@contoso.com."

.EXAMPLE
    Set-MailboxAutoReply `
        -Identity "john.doe@contoso.com" `
        -InternalMessage "Internal auto-reply message." `
        -ExternalMessage "External auto-reply message."

.EXAMPLE
    Set-MailboxAutoReply `
        -Identity "john.doe@contoso.com" `
        -InternalMessage "John Doe is no longer with the company." `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Set-MailboxAutoReply {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InternalMessage,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ExternalMessage
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Set-MailboxAutoReplyConfiguration -ErrorAction SilentlyContinue)) {
            throw "Set-MailboxAutoReplyConfiguration is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }
    }

    process {
        try {
            if (-not $ExternalMessage) {
                $ExternalMessage = $InternalMessage
            }

            if ($PSCmdlet.ShouldProcess($Identity, "Enable mailbox auto-reply")) {
                Set-MailboxAutoReplyConfiguration `
                    -Identity $Identity `
                    -AutoReplyState Enabled `
                    -InternalMessage $InternalMessage `
                    -ExternalMessage $ExternalMessage `
                    -ErrorAction Stop

                Write-Host "Successfully enabled auto-reply for mailbox: $Identity" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to set mailbox auto-reply for '$Identity'. $($_.Exception.Message)"
        }
    }
}