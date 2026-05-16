<#
.SYNOPSIS
    Export Active Directory users.

.DESCRIPTION
    Exports on-premises Active Directory users to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-ADUsers

.EXAMPLE
    Export-ADUsers -OutputPath ".\reports\csv\ad-users.csv"

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Requires the ActiveDirectory PowerShell module.
#>

function Export-ADUsers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\ad-users.csv"
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
    }

    process {
        try {
            Get-ADUser `
                -Filter * `
                -Properties DisplayName, Mail, Department, Title, Enabled, LastLogonDate |
                Select-Object `
                    SamAccountName,
                    UserPrincipalName,
                    DisplayName,
                    Mail,
                    Department,
                    Title,
                    Enabled,
                    LastLogonDate |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Active Directory users exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export Active Directory users. $($_.Exception.Message)"
        }
    }
}