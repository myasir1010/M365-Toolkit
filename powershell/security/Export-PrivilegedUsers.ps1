<#
.SYNOPSIS
    Export privileged users.

.DESCRIPTION
    Exports Microsoft Entra ID users assigned to administrator roles.

    This function uses Get-AdminRoleAssignments if it is available in the current
    session or imported module. The result is exported to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the privileged users report will be exported as a CSV file.

.EXAMPLE
    Export-PrivilegedUsers

.EXAMPLE
    Export-PrivilegedUsers -OutputPath ".\reports\csv\privileged-users.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - RoleManagement.Read.Directory
    - Directory.Read.All

    This function expects Get-AdminRoleAssignments to be available.
#>

function Export-PrivilegedUsers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\privileged-users.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Get-AdminRoleAssignments -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Get-AdminRoleAssignments. Import the M365Toolkit module first."
        }

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
            $report = Get-AdminRoleAssignments

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Privileged users report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export privileged users. $($_.Exception.Message)"
        }
    }
}