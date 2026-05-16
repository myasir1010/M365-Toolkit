<#
.SYNOPSIS
    Export Microsoft 365 users.

.DESCRIPTION
    Exports Microsoft 365 cloud user inventory from Microsoft Graph to a CSV file.

    The report includes:
    - Display name
    - User principal name
    - Email address
    - Department
    - Job title
    - Account status
    - User type
    - Creation date
    - Usage location

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-M365Users

.EXAMPLE
    Export-M365Users -OutputPath ".\reports\csv\m365-users.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.Read.All
#>

function Export-M365Users {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\m365-users.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
            throw "The Microsoft.Graph.Users module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Users -ErrorAction Stop

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
            Get-MgUser `
                -All `
                -Property Id, DisplayName, UserPrincipalName, Mail, Department, JobTitle, AccountEnabled, UserType, CreatedDateTime, UsageLocation |
                Select-Object `
                    Id,
                    DisplayName,
                    UserPrincipalName,
                    Mail,
                    Department,
                    JobTitle,
                    AccountEnabled,
                    UserType,
                    CreatedDateTime,
                    UsageLocation |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Microsoft 365 users exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export Microsoft 365 users. $($_.Exception.Message)"
        }
    }
}