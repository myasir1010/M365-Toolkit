<#
.SYNOPSIS
    Run security audit workflow.

.DESCRIPTION
    Runs the Microsoft 365 security audit workflow for the M365 Toolkit.

    This workflow generates security-related reports, including:
    - MFA status
    - Users without MFA
    - Privileged users
    - Risky users
    - Tenant security baseline

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputDirectory
    The directory where security audit CSV reports will be saved.

.PARAMETER BaselineOutputPath
    The path where the tenant security baseline JSON report will be saved.

.PARAMETER GenerateHtmlReport
    Creates an HTML report from the tenant security baseline if supported.

.EXAMPLE
    Invoke-M365SecurityAudit

.EXAMPLE
    Invoke-M365SecurityAudit -OutputDirectory ".\reports\csv"

.EXAMPLE
    Invoke-M365SecurityAudit `
        -OutputDirectory ".\reports\csv" `
        -BaselineOutputPath ".\reports\json\tenant-security-baseline.json"

.NOTES
    Run PowerShell as Administrator when local or Microsoft 365 permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    This workflow expects Export-M365SecurityReport to be available.
#>

function Invoke-M365SecurityAudit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory = ".\reports\csv",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BaselineOutputPath = ".\reports\json\tenant-security-baseline.json",

        [Parameter(Mandatory = $false)]
        [switch]$GenerateHtmlReport
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Export-M365SecurityReport -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Export-M365SecurityReport. Import the M365Toolkit module first."
        }

        if ($GenerateHtmlReport -and -not (Get-Command -Name New-M365HtmlReport -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing for -GenerateHtmlReport: New-M365HtmlReport."
        }

        if (-not (Test-Path -Path $OutputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $OutputDirectory `
                -Force | Out-Null
        }

        $baselineDirectory = Split-Path -Path $BaselineOutputPath -Parent

        if ($baselineDirectory -and -not (Test-Path -Path $baselineDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $baselineDirectory `
                -Force | Out-Null
        }
    }

    process {
        try {
            Write-Host "Starting Microsoft 365 security audit workflow..." -ForegroundColor Cyan

            $securityReport = Export-M365SecurityReport `
                -OutputDirectory $OutputDirectory

            $baselineReport = $null

            if (Get-Command -Name Get-TenantSecurityBaseline -CommandType Function -ErrorAction SilentlyContinue) {
                $baselineReport = Get-TenantSecurityBaseline `
                    -OutputPath $BaselineOutputPath `
                    -WorkingDirectory $OutputDirectory
            }

            $htmlReports = @()

            if ($GenerateHtmlReport) {
                $csvReports = Get-ChildItem `
                    -Path $OutputDirectory `
                    -Filter "*.csv" `
                    -File `
                    -ErrorAction SilentlyContinue

                foreach ($csvReport in $csvReports) {
                    $htmlOutputPath = Join-Path `
                        -Path ".\reports\html" `
                        -ChildPath "$($csvReport.BaseName).html"

                    $htmlReports += New-M365HtmlReport `
                        -CsvPath $csvReport.FullName `
                        -OutputPath $htmlOutputPath `
                        -Title "M365 Security Audit - $($csvReport.BaseName)"
                }
            }

            Write-Host "Microsoft 365 security audit workflow completed successfully." -ForegroundColor Green

            return [PSCustomObject]@{
                OutputDirectory    = (Resolve-Path -Path $OutputDirectory).Path
                SecurityReport     = $securityReport
                BaselineReport     = if ($baselineReport) { $baselineReport.FullName } else { $null }
                HtmlReports        = $htmlReports.FullName
                GeneratedAt        = Get-Date
            }
        }
        catch {
            Write-Error "Failed to run Microsoft 365 security audit workflow. $($_.Exception.Message)"
        }
    }
}