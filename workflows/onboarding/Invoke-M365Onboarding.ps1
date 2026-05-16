<#
.SYNOPSIS
    Run onboarding workflow.

.DESCRIPTION
    Runs the Microsoft 365 onboarding workflow for the M365 Toolkit.

    This workflow reads new user data from a CSV file and creates cloud-only
    Microsoft 365 users using Microsoft Graph PowerShell.

    The CSV file should include the following columns:
    - UserPrincipalName
    - DisplayName
    - GivenName
    - Surname
    - UsageLocation

    Optional columns:
    - Department
    - JobTitle
    - MailNickname

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER CsvPath
    The path to the CSV file containing users to onboard.

.PARAMETER TemporaryPassword
    The temporary password assigned to all users created from the CSV file.

.PARAMETER ForceChangePasswordNextSignIn
    Forces users to change their password at next sign-in.
    Enabled by default.

.PARAMETER WhatIfOnly
    Runs the workflow in WhatIf mode without creating users.

.EXAMPLE
    $Password = Read-Host "Enter temporary password" -AsSecureString

    Invoke-M365Onboarding `
        -CsvPath ".\data\input\users.sample.csv" `
        -TemporaryPassword $Password

.EXAMPLE
    $Password = Read-Host "Enter temporary password" -AsSecureString

    Invoke-M365Onboarding `
        -CsvPath ".\data\input\users.sample.csv" `
        -TemporaryPassword $Password `
        -WhatIfOnly

.NOTES
    Run PowerShell as Administrator when local or Microsoft 365 permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.ReadWrite.All

    This workflow expects New-M365User to be available.
#>

function Invoke-M365Onboarding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            if (-not (Test-Path -Path $_ -PathType Leaf)) {
                throw "CSV file not found: $_"
            }

            if ([System.IO.Path]::GetExtension($_) -ne ".csv") {
                throw "Input file must be a CSV file: $_"
            }

            return $true
        })]
        [string]$CsvPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [securestring]$TemporaryPassword,

        [Parameter(Mandatory = $false)]
        [bool]$ForceChangePasswordNextSignIn = $true,

        [Parameter(Mandatory = $false)]
        [switch]$WhatIfOnly
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name New-M365User -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: New-M365User. Import the M365Toolkit module first."
        }

        $requiredColumns = @(
            "UserPrincipalName",
            "DisplayName",
            "GivenName",
            "Surname",
            "UsageLocation"
        )
    }

    process {
        try {
            $users = Import-Csv -Path $CsvPath -ErrorAction Stop

            if (-not $users) {
                throw "CSV file contains no users: $CsvPath"
            }

            $results = foreach ($user in $users) {
                foreach ($column in $requiredColumns) {
                    if (-not $user.PSObject.Properties.Name.Contains($column)) {
                        throw "CSV file is missing required column: $column"
                    }

                    if ([string]::IsNullOrWhiteSpace($user.$column)) {
                        throw "CSV row for '$($user.UserPrincipalName)' has empty required column: $column"
                    }
                }

                $newUserParameters = @{
                    UserPrincipalName           = $user.UserPrincipalName
                    DisplayName                 = $user.DisplayName
                    GivenName                   = $user.GivenName
                    Surname                     = $user.Surname
                    Password                    = $TemporaryPassword
                    UsageLocation               = $user.UsageLocation
                    ForceChangePasswordNextSignIn = $ForceChangePasswordNextSignIn
                }

                if ($user.PSObject.Properties.Name.Contains("Department") -and $user.Department) {
                    $newUserParameters.Department = $user.Department
                }

                if ($user.PSObject.Properties.Name.Contains("JobTitle") -and $user.JobTitle) {
                    $newUserParameters.JobTitle = $user.JobTitle
                }

                if ($user.PSObject.Properties.Name.Contains("MailNickname") -and $user.MailNickname) {
                    $newUserParameters.MailNickname = $user.MailNickname
                }

                try {
                    if ($WhatIfOnly) {
                        New-M365User @newUserParameters -WhatIf

                        [PSCustomObject]@{
                            UserPrincipalName = $user.UserPrincipalName
                            DisplayName       = $user.DisplayName
                            Status            = "WhatIf"
                            Error             = $null
                        }
                    }
                    else {
                        New-M365User @newUserParameters | Out-Null

                        [PSCustomObject]@{
                            UserPrincipalName = $user.UserPrincipalName
                            DisplayName       = $user.DisplayName
                            Status            = "Created"
                            Error             = $null
                        }
                    }
                }
                catch {
                    [PSCustomObject]@{
                        UserPrincipalName = $user.UserPrincipalName
                        DisplayName       = $user.DisplayName
                        Status            = "Failed"
                        Error             = $_.Exception.Message
                    }
                }
            }

            $createdCount = @($results | Where-Object { $_.Status -eq "Created" }).Count
            $whatIfCount = @($results | Where-Object { $_.Status -eq "WhatIf" }).Count
            $failedCount = @($results | Where-Object { $_.Status -eq "Failed" }).Count

            Write-Host "Microsoft 365 onboarding workflow completed." -ForegroundColor Green
            Write-Host "Created: $createdCount" -ForegroundColor Green
            Write-Host "WhatIf: $whatIfCount" -ForegroundColor Yellow
            Write-Host "Failed: $failedCount" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })

            return $results
        }
        catch {
            Write-Error "Failed to run Microsoft 365 onboarding workflow. $($_.Exception.Message)"
        }
    }
}