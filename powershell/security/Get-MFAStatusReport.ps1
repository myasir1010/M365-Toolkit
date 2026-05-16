<#
.SYNOPSIS
    Get MFA status report.

.DESCRIPTION
    Checks registered authentication methods for Microsoft 365 users using Microsoft Graph
    and exports the result to a CSV file.

    The report includes:
    - Display name
    - User principal name
    - Account enabled status
    - Authentication method count
    - MFA registration status
    - Registered authentication method types

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the MFA status report will be exported as a CSV file.

.EXAMPLE
    Get-MFAStatusReport

.EXAMPLE
    Get-MFAStatusReport -OutputPath ".\reports\csv\mfa-status.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - User.Read.All
    - UserAuthenticationMethod.Read.All
#>

function Get-MFAStatusReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\mfa-status.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
            throw "The Microsoft.Graph.Users module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
            throw "The Microsoft.Graph.Authentication module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Users -ErrorAction Stop
        Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $outputDirectory `
                -Force | Out-Null
        }
    }

    process {
        try {
            $users = Get-MgUser `
                -All `
                -Property Id, DisplayName, UserPrincipalName, AccountEnabled, UserType `
                -ErrorAction Stop

            $report = foreach ($user in $users) {
                try {
                    $uri = "https://graph.microsoft.com/v1.0/users/$($user.Id)/authentication/methods"

                    $methodsResponse = Invoke-MgGraphRequest `
                        -Method GET `
                        -Uri $uri `
                        -ErrorAction Stop

                    $methods = @($methodsResponse.value)

                    $methodTypes = $methods |
                        ForEach-Object {
                            $_.'@odata.type' -replace "#microsoft.graph.", ""
                        }

                    $mfaCapableMethods = $methodTypes |
                        Where-Object {
                            $_ -notin @(
                                "passwordAuthenticationMethod",
                                "emailAuthenticationMethod"
                            )
                        }

                    [PSCustomObject]@{
                        DisplayName       = $user.DisplayName
                        UserPrincipalName = $user.UserPrincipalName
                        UserType          = $user.UserType
                        AccountEnabled    = $user.AccountEnabled
                        MethodCount       = $methods.Count
                        MfaMethodCount    = @($mfaCapableMethods).Count
                        MfaRegistered     = (@($mfaCapableMethods).Count -gt 0)
                        Methods           = ($methodTypes -join ";")
                    }
                }
                catch {
                    [PSCustomObject]@{
                        DisplayName       = $user.DisplayName
                        UserPrincipalName = $user.UserPrincipalName
                        UserType          = $user.UserType
                        AccountEnabled    = $user.AccountEnabled
                        MethodCount       = $null
                        MfaMethodCount    = $null
                        MfaRegistered     = $false
                        Methods           = "Error: $($_.Exception.Message)"
                    }
                }
            }

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "MFA status report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export MFA status report. $($_.Exception.Message)"
        }
    }
}