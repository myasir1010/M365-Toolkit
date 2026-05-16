<#
.SYNOPSIS
    Convert mailbox to shared mailbox.

.DESCRIPTION
    Converts an Exchange Online user mailbox to a shared mailbox.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The mailbox identity to convert.
    Accepts mailbox alias, email address, user principal name, or distinguished name.

.EXAMPLE
    Convert-MailboxToShared -Identity "john.doe@contoso.com"

.EXAMPLE
    Convert-MailboxToShared -Identity "john.doe@contoso.com" -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Convert-MailboxToShared {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
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
            if ($PSCmdlet.ShouldProcess($Identity, "Convert mailbox to shared mailbox")) {
                Set-Mailbox `
                    -Identity $Identity `
                    -Type Shared `
                    -ErrorAction Stop

                Write-Host "Successfully converted mailbox to shared mailbox: $Identity" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to convert mailbox '$Identity' to shared mailbox. $($_.Exception.Message)"
        }
    }
}