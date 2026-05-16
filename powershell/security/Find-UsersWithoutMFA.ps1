<#
.SYNOPSIS
    Find users without MFA.

.DESCRIPTION
    Generates an MFA status report and exports enabled Microsoft 365 users
    who are not registered for multifactor authentication.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the users without MFA report will be exported as a CSV file.

.EXAMPLE
    Find-UsersWithoutMFA

.EXAMPLE
    Find-UsersWithoutMFA -OutputPath ".\reports\csv\users-without-mfa.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - User.Read.All
    - UserAuthenticationMethod.Read.All

    This function expects Get-MFAStatusReport to be available.
#>

function Find-UsersWithoutMFA {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\users-without-mfa.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Get-MFAStatusReport -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Get-MFAStatusReport. Import the M365Toolkit module first."
        }

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $outputDirectory `
                -Force | Out-Null
        }

        $temporaryReportPath = Join-Path `
            -Path $env:TEMP `
            -ChildPath "m365toolkit-mfa-status-$([guid]::NewGuid()).csv"
    }

    process {
        try {
            Get-MFAStatusReport `
                -OutputPath $temporaryReportPath | Out-Null

            $usersWithoutMfa = Import-Csv -Path $temporaryReportPath |
                Where-Object {
                    $_.MfaRegistered -eq "False" -and
                    $_.AccountEnabled -eq "True"
                }

            $usersWithoutMfa |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Users without MFA report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export users without MFA report. $($_.Exception.Message)"
        }
        finally {
            if (Test-Path -Path $temporaryReportPath) {
                Remove-Item -Path $temporaryReportPath -Force -ErrorAction SilentlyContinue
            }
        }
    }
}