<#
.SYNOPSIS
    Export mailbox statistics.

.DESCRIPTION
    Exports Exchange Online mailbox statistics, including mailbox display name,
    user principal name, item count, total item size, and last logon time.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-MailboxStatistics

.EXAMPLE
    Export-MailboxStatistics -OutputPath ".\reports\csv\mailbox-statistics.csv"

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Export-MailboxStatistics {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\mailbox-statistics.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Get-EXOMailbox -ErrorAction SilentlyContinue)) {
            throw "Get-EXOMailbox is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }

        if (-not (Get-Command -Name Get-EXOMailboxStatistics -ErrorAction SilentlyContinue)) {
            throw "Get-EXOMailboxStatistics is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
    }

    process {
        try {
            $mailboxes = Get-EXOMailbox -ResultSize Unlimited -ErrorAction Stop

            $report = foreach ($mailbox in $mailboxes) {
                try {
                    $statistics = Get-EXOMailboxStatistics `
                        -Identity $mailbox.UserPrincipalName `
                        -ErrorAction Stop

                    [PSCustomObject]@{
                        DisplayName       = $mailbox.DisplayName
                        UserPrincipalName = $mailbox.UserPrincipalName
                        PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
                        RecipientTypeDetails = $mailbox.RecipientTypeDetails
                        ItemCount         = $statistics.ItemCount
                        TotalItemSize     = $statistics.TotalItemSize
                        LastLogonTime     = $statistics.LastLogonTime
                    }
                }
                catch {
                    Write-Warning "Could not retrieve mailbox statistics for '$($mailbox.UserPrincipalName)'. $($_.Exception.Message)"
                }
            }

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Mailbox statistics exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export mailbox statistics. $($_.Exception.Message)"
        }
    }
}