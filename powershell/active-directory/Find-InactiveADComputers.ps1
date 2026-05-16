<#
.SYNOPSIS
    Find inactive Active Directory computers.

.DESCRIPTION
    Finds enabled on-premises Active Directory computer accounts that have been inactive
    for a selected number of days and exports the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER InactiveDays
    The number of days a computer must be inactive before it is included in the report.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Find-InactiveADComputers

.EXAMPLE
    Find-InactiveADComputers -InactiveDays 180

.EXAMPLE
    Find-InactiveADComputers -InactiveDays 90 -OutputPath ".\reports\csv\inactive-ad-computers.csv"

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Requires the ActiveDirectory PowerShell module.
#>

function Find-InactiveADComputers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3650)]
        [int]$InactiveDays = 90,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\inactive-ad-computers.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
            throw "The ActiveDirectory module is not installed. Install RSAT Active Directory tools and try again."
        }

        Import-Module ActiveDirectory -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }

        $cutoffDate = (Get-Date).AddDays(-$InactiveDays)
    }

    process {
        try {
            Get-ADComputer `
                -Filter { LastLogonDate -lt $cutoffDate -and Enabled -eq $true } `
                -Properties LastLogonDate, OperatingSystem, Enabled, DNSHostName |
                Select-Object `
                    Name,
                    DNSHostName,
                    OperatingSystem,
                    Enabled,
                    LastLogonDate |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Inactive AD computers exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to find inactive AD computers. $($_.Exception.Message)"
        }
    }
}