<#
.SYNOPSIS
    Find inactive Microsoft 365 users.

.DESCRIPTION
    Returns Microsoft 365 users whose last sign-in is older than a selected
    number of days using Microsoft Graph.

    The result can be displayed in the console and optionally exported to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER InactiveDays
    The number of days a user must be inactive before being included in the report.

.PARAMETER OutputPath
    Optional path where the inactive users report will be exported as a CSV file.

.EXAMPLE
    Get-M365InactiveUsers

.EXAMPLE
    Get-M365InactiveUsers -InactiveDays 180

.EXAMPLE
    Get-M365InactiveUsers `
        -InactiveDays 90 `
        -OutputPath ".\reports\csv\m365-inactive-users.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - User.Read.All
    - AuditLog.Read.All

    The SignInActivity property requires appropriate Microsoft Entra ID licensing and permissions.
#>

function Get-M365InactiveUsers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3650)]
        [int]$InactiveDays = 90,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
            throw "The Microsoft.Graph.Users module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Users -ErrorAction Stop

        if ($OutputPath) {
            $outputDirectory = Split-Path -Path $OutputPath -Parent

            if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
                New-Item `
                    -ItemType Directory `
                    -Path $outputDirectory `
                    -Force | Out-Null
            }
        }

        $cutoffDate = (Get-Date).AddDays(-$InactiveDays)
    }

    process {
        try {
            $inactiveUsers = Get-MgUser `
                -All `
                -Property Id, DisplayName, UserPrincipalName, Mail, AccountEnabled, UserType, CreatedDateTime, SignInActivity `
                -ErrorAction Stop |
                Where-Object {
                    $_.SignInActivity.LastSignInDateTime -and
                    ([datetime]$_.SignInActivity.LastSignInDateTime) -lt $cutoffDate
                } |
                Select-Object `
                    Id,
                    DisplayName,
                    UserPrincipalName,
                    Mail,
                    AccountEnabled,
                    UserType,
                    CreatedDateTime,
                    @{ Name = "LastSignInDateTime"; Expression = { $_.SignInActivity.LastSignInDateTime } },
                    @{ Name = "LastNonInteractiveSignInDateTime"; Expression = { $_.SignInActivity.LastNonInteractiveSignInDateTime } }

            if ($OutputPath) {
                $inactiveUsers |
                    Export-Csv `
                        -Path $OutputPath `
                        -NoTypeInformation `
                        -Encoding UTF8

                Write-Host "Inactive Microsoft 365 users exported successfully: $OutputPath" -ForegroundColor Green

                return Get-Item -Path $OutputPath
            }

            return $inactiveUsers
        }
        catch {
            Write-Error "Failed to find inactive Microsoft 365 users. $($_.Exception.Message)"
        }
    }
}