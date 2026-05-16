<#
.SYNOPSIS
    Export Microsoft 365 security report.

.DESCRIPTION
    Runs Microsoft 365 security-related reports, including MFA status,
    users without MFA, privileged users, risky users, and tenant security baseline.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputDirectory
    The directory where all Microsoft 365 security report CSV files will be saved.

.EXAMPLE
    Export-M365SecurityReport

.EXAMPLE
    Export-M365SecurityReport -OutputDirectory ".\reports\csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    This function expects the following functions to be available:
    - Get-MFAStatusReport
    - Find-UsersWithoutMFA
    - Export-PrivilegedUsers
    - Export-RiskyUsers
    - Get-TenantSecurityBaseline
#>

function Export-M365SecurityReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory = ".\reports\csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Test-Path -Path $OutputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $OutputDirectory `
                -Force | Out-Null
        }

        $requiredFunctions = @(
            "Get-MFAStatusReport",
            "Find-UsersWithoutMFA",
            "Export-PrivilegedUsers",
            "Export-RiskyUsers",
            "Get-TenantSecurityBaseline"
        )

        foreach ($functionName in $requiredFunctions) {
            if (-not (Get-Command -Name $functionName -CommandType Function -ErrorAction SilentlyContinue)) {
                throw "Required function is missing: $functionName. Import the M365Toolkit module first."
            }
        }
    }

    process {
        try {
            Write-Host "Creating Microsoft 365 security report..." -ForegroundColor Cyan

            $mfaStatusReport = Get-MFAStatusReport `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "mfa-status-report.csv")

            $usersWithoutMfaReport = Find-UsersWithoutMFA `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "users-without-mfa.csv")

            $privilegedUsersReport = Export-PrivilegedUsers `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "privileged-users.csv")

            $riskyUsersReport = Export-RiskyUsers `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "risky-users.csv")

            $tenantSecurityBaselineReport = Get-TenantSecurityBaseline `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "tenant-security-baseline.csv")

            Write-Host "Microsoft 365 security report created successfully." -ForegroundColor Green

            [PSCustomObject]@{
                OutputDirectory              = (Resolve-Path -Path $OutputDirectory).Path
                MFAStatusReport              = $mfaStatusReport.FullName
                UsersWithoutMFAReport        = $usersWithoutMfaReport.FullName
                PrivilegedUsersReport        = $privilegedUsersReport.FullName
                RiskyUsersReport             = $riskyUsersReport.FullName
                TenantSecurityBaselineReport = $tenantSecurityBaselineReport.FullName
                GeneratedAt                  = Get-Date
            }
        }
        catch {
            Write-Error "Failed to create Microsoft 365 security report. $($_.Exception.Message)"
        }
    }
}