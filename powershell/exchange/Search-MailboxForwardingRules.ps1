<#
.SYNOPSIS
    Search mailbox forwarding rules.

.DESCRIPTION
    Finds Exchange Online mailboxes with mailbox-level forwarding configured.

    This function checks:
    - ForwardingSmtpAddress
    - ForwardingAddress
    - DeliverToMailboxAndForward

    The result can be displayed in the console and optionally exported to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    Optional path where the mailbox forwarding report will be exported as a CSV file.

.EXAMPLE
    Search-MailboxForwardingRules

.EXAMPLE
    Search-MailboxForwardingRules -OutputPath ".\reports\csv\mailbox-forwarding-rules.csv"

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Search-MailboxForwardingRules {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Get-EXOMailbox -ErrorAction SilentlyContinue)) {
            throw "Get-EXOMailbox is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }

        if ($OutputPath) {
            $outputDirectory = Split-Path -Path $OutputPath -Parent

            if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
                New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
            }
        }
    }

    process {
        try {
            $forwardingRules = Get-EXOMailbox `
                -ResultSize Unlimited `
                -Properties ForwardingSmtpAddress, ForwardingAddress, DeliverToMailboxAndForward `
                -ErrorAction Stop |
                Where-Object {
                    $_.ForwardingSmtpAddress -or
                    $_.ForwardingAddress
                } |
                Select-Object `
                    DisplayName,
                    UserPrincipalName,
                    PrimarySmtpAddress,
                    RecipientTypeDetails,
                    ForwardingSmtpAddress,
                    ForwardingAddress,
                    DeliverToMailboxAndForward

            if ($OutputPath) {
                $forwardingRules |
                    Export-Csv `
                        -Path $OutputPath `
                        -NoTypeInformation `
                        -Encoding UTF8

                Write-Host "Mailbox forwarding rules exported successfully: $OutputPath" -ForegroundColor Green

                return Get-Item -Path $OutputPath
            }

            return $forwardingRules
        }
        catch {
            Write-Error "Failed to search mailbox forwarding rules. $($_.Exception.Message)"
        }
    }
}