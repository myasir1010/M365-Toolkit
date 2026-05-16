<#
.SYNOPSIS
    Hide mailbox from address list.

.DESCRIPTION
    Hides an Exchange Online mailbox from Exchange address lists.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The mailbox identity to hide from address lists.
    Accepts mailbox alias, email address, user principal name, or distinguished name.

.EXAMPLE
    Hide-MailboxFromAddressList -Identity "john.doe@contoso.com"

.EXAMPLE
    Hide-MailboxFromAddressList -Identity "john.doe@contoso.com" -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Hide-MailboxFromAddressList {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Set-Mailbox -ErrorAction SilentlyContinue)) {
            throw "Set-Mailbox is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($Identity, "Hide mailbox from Exchange address lists")) {
                Set-Mailbox `
                    -Identity $Identity `
                    -HiddenFromAddressListsEnabled $true `
                    -ErrorAction Stop

                Write-Host "Successfully hidden mailbox from address lists: $Identity" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to hide mailbox '$Identity' from address lists. $($_.Exception.Message)"
        }
    }
}