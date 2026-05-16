<#
.SYNOPSIS
    Export Microsoft 365 guest users.

.DESCRIPTION
    Lists Microsoft 365 guest users from Microsoft Entra ID using Microsoft Graph.
    The result can be displayed in the console and optionally exported to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    Optional path where the guest users report will be exported as a CSV file.

.EXAMPLE
    Get-M365GuestUsers

.EXAMPLE
    Get-M365GuestUsers -OutputPath ".\reports\csv\m365-guest-users.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.Read.All
#>

function Get-M365GuestUsers {
    [CmdletBinding()]
    param(
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
    }

    process {
        try {
            $guestUsers = Get-MgUser `
                -All `
                -Filter "userType eq 'Guest'" `
                -Property Id, DisplayName, UserPrincipalName, Mail, CreatedDateTime, AccountEnabled, ExternalUserState, ExternalUserStateChangeDateTime |
                Select-Object `
                    Id,
                    DisplayName,
                    UserPrincipalName,
                    Mail,
                    CreatedDateTime,
                    AccountEnabled,
                    ExternalUserState,
                    ExternalUserStateChangeDateTime

            if ($OutputPath) {
                $guestUsers |
                    Export-Csv `
                        -Path $OutputPath `
                        -NoTypeInformation `
                        -Encoding UTF8

                Write-Host "Microsoft 365 guest users exported successfully: $OutputPath" -ForegroundColor Green

                return Get-Item -Path $OutputPath
            }

            return $guestUsers
        }
        catch {
            Write-Error "Failed to export Microsoft 365 guest users. $($_.Exception.Message)"
        }
    }
}