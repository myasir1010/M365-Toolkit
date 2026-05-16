<#
.SYNOPSIS
    Disable mailbox client protocols.

.DESCRIPTION
    Disables mailbox client access protocols and access methods for an Exchange Online mailbox.

    The function disables:
    - POP
    - IMAP
    - ActiveSync
    - Outlook Web App
    - MAPI
    - EWS
    - SMTP client authentication

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The mailbox identity where client protocols will be disabled.
    Accepts mailbox alias, email address, user principal name, or distinguished name.

.EXAMPLE
    Disable-MailboxProtocols -Identity "john.doe@contoso.com"

.EXAMPLE
    Disable-MailboxProtocols -Identity "john.doe@contoso.com" -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Disable-MailboxProtocols {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Set-CASMailbox -ErrorAction SilentlyContinue)) {
            throw "Set-CASMailbox is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($Identity, "Disable mailbox client protocols")) {
                Set-CASMailbox `
                    -Identity $Identity `
                    -PopEnabled $false `
                    -ImapEnabled $false `
                    -ActiveSyncEnabled $false `
                    -OWAEnabled $false `
                    -MAPIEnabled $false `
                    -EwsEnabled $false `
                    -SmtpClientAuthenticationDisabled $true `
                    -ErrorAction Stop

                Write-Host "Successfully disabled mailbox client protocols for: $Identity" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to disable mailbox client protocols for '$Identity'. $($_.Exception.Message)"
        }
    }
}