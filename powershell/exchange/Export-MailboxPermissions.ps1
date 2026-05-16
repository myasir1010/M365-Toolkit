<#
.SYNOPSIS
    Export mailbox permissions.

.DESCRIPTION
    Exports explicit Exchange Online mailbox permissions to a CSV file.

    The report includes non-inherited mailbox permissions and excludes default
    NT AUTHORITY entries.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-MailboxPermissions

.EXAMPLE
    Export-MailboxPermissions -OutputPath ".\reports\csv\mailbox-permissions.csv"

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Export-MailboxPermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\mailbox-permissions.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Get-EXOMailbox -ErrorAction SilentlyContinue)) {
            throw "Get-EXOMailbox is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }

        if (-not (Get-Command -Name Get-MailboxPermission -ErrorAction SilentlyContinue)) {
            throw "Get-MailboxPermission is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
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
                Get-MailboxPermission -Identity $mailbox.UserPrincipalName -ErrorAction SilentlyContinue |
                    Where-Object {
                        -not $_.IsInherited -and
                        $_.User -notlike "NT AUTHORITY*" -and
                        $_.User -ne "S-1-5-10"
                    } |
                    Select-Object `
                        @{ Name = "Mailbox"; Expression = { $mailbox.UserPrincipalName } },
                        @{ Name = "DisplayName"; Expression = { $mailbox.DisplayName } },
                        User,
                        AccessRights,
                        Deny,
                        IsInherited
            }

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Mailbox permissions exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export mailbox permissions. $($_.Exception.Message)"
        }
    }
}