<#
.SYNOPSIS
    Create an Active Directory report.

.DESCRIPTION
    Exports Active Directory users, groups, inactive users, and inactive computers
    into CSV reports.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputDirectory
    The directory where all Active Directory report CSV files will be saved.

.PARAMETER InactiveDays
    The number of inactive days used for inactive user and computer reports.

.EXAMPLE
    Sync-ADReport

.EXAMPLE
    Sync-ADReport -OutputDirectory ".\reports\csv" -InactiveDays 180

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Requires the ActiveDirectory PowerShell module.

    This function expects the following functions to be available:
    - Export-ADUsers
    - Export-ADGroups
    - Find-InactiveADUsers
    - Find-InactiveADComputers
#>

function Sync-ADReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory = ".\reports\csv",

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3650)]
        [int]$InactiveDays = 90
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Test-Path -Path $OutputDirectory)) {
            New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
        }

        $requiredFunctions = @(
            "Export-ADUsers",
            "Export-ADGroups",
            "Find-InactiveADUsers",
            "Find-InactiveADComputers"
        )

        foreach ($functionName in $requiredFunctions) {
            if (-not (Get-Command -Name $functionName -CommandType Function -ErrorAction SilentlyContinue)) {
                throw "Required function is missing: $functionName. Import the M365Toolkit module first."
            }
        }
    }

    process {
        try {
            $reportFiles = [ordered]@{}

            Write-Host "Creating Active Directory report..." -ForegroundColor Cyan

            $reportFiles.Users = Export-ADUsers `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "ad-users.csv")

            $reportFiles.Groups = Export-ADGroups `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "ad-groups.csv")

            $reportFiles.InactiveUsers = Find-InactiveADUsers `
                -InactiveDays $InactiveDays `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "inactive-ad-users.csv")

            $reportFiles.InactiveComputers = Find-InactiveADComputers `
                -InactiveDays $InactiveDays `
                -OutputPath (Join-Path -Path $OutputDirectory -ChildPath "inactive-ad-computers.csv")

            Write-Host "Active Directory report created successfully." -ForegroundColor Green

            [PSCustomObject]@{
                OutputDirectory   = (Resolve-Path -Path $OutputDirectory).Path
                InactiveDays      = $InactiveDays
                UsersReport       = $reportFiles.Users.FullName
                GroupsReport      = $reportFiles.Groups.FullName
                InactiveUsers     = $reportFiles.InactiveUsers.FullName
                InactiveComputers = $reportFiles.InactiveComputers.FullName
                GeneratedAt       = Get-Date
            }
        }
        catch {
            Write-Error "Failed to create Active Directory report. $($_.Exception.Message)"
        }
    }
}