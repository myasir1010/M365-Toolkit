<#
.SYNOPSIS
    Run tenant inventory workflow.

.DESCRIPTION
    Runs the Microsoft 365 tenant inventory workflow for the M365 Toolkit.

    This workflow generates inventory reports for:
    - Microsoft 365 users
    - Microsoft 365 groups
    - Microsoft 365 license usage
    - Entra ID devices

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputDirectory
    The directory where tenant inventory CSV reports will be saved.

.PARAMETER GenerateHtmlReport
    Creates HTML reports from the generated CSV inventory reports.

.EXAMPLE
    Invoke-M365TenantInventory

.EXAMPLE
    Invoke-M365TenantInventory -OutputDirectory ".\reports\csv"

.EXAMPLE
    Invoke-M365TenantInventory `
        -OutputDirectory ".\reports\csv" `
        -GenerateHtmlReport

.NOTES
    Run PowerShell as Administrator when local or Microsoft 365 permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    This workflow expects Export-M365InventoryReport to be available.
#>

function Invoke-M365TenantInventory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory = ".\reports\csv",

        [Parameter(Mandatory = $false)]
        [switch]$GenerateHtmlReport
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Export-M365InventoryReport -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Export-M365InventoryReport. Import the M365Toolkit module first."
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
    }

    process {
        try {
            Write-Host "Starting Microsoft 365 tenant inventory workflow..." -ForegroundColor Cyan

            $inventoryReport = Export-M365InventoryReport `
                -OutputDirectory $OutputDirectory

            $htmlReports = @()

            if ($GenerateHtmlReport) {
                $htmlOutputDirectory = ".\reports\html"

                if (-not (Test-Path -Path $htmlOutputDirectory)) {
                    New-Item `
                        -ItemType Directory `
                        -Path $htmlOutputDirectory `
                        -Force | Out-Null
                }

                $csvReports = Get-ChildItem `
                    -Path $OutputDirectory `
                    -Filter "*.csv" `
                    -File `
                    -ErrorAction SilentlyContinue

                foreach ($csvReport in $csvReports) {
                    $htmlOutputPath = Join-Path `
                        -Path $htmlOutputDirectory `
                        -ChildPath "$($csvReport.BaseName).html"

                    $htmlReports += New-M365HtmlReport `
                        -CsvPath $csvReport.FullName `
                        -OutputPath $htmlOutputPath `
                        -Title "M365 Tenant Inventory - $($csvReport.BaseName)"
                }
            }

            Write-Host "Microsoft 365 tenant inventory workflow completed successfully." -ForegroundColor Green

            return [PSCustomObject]@{
                OutputDirectory = (Resolve-Path -Path $OutputDirectory).Path
                InventoryReport = $inventoryReport
                HtmlReports     = $htmlReports.FullName
                GeneratedAt     = Get-Date
            }
        }
        catch {
            Write-Error "Failed to run Microsoft 365 tenant inventory workflow. $($_.Exception.Message)"
        }
    }
}