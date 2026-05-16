<#
.SYNOPSIS
    Get admin role assignments.

.DESCRIPTION
    Exports Microsoft Entra ID directory role assignments using Microsoft Graph
    and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the admin role assignments report will be exported as a CSV file.

.EXAMPLE
    Get-AdminRoleAssignments

.EXAMPLE
    Get-AdminRoleAssignments -OutputPath ".\reports\csv\admin-role-assignments.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - Directory.Read.All
    - RoleManagement.Read.Directory
#>

function Get-AdminRoleAssignments {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\admin-role-assignments.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.DirectoryManagement)) {
            throw "The Microsoft.Graph.Identity.DirectoryManagement module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop

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
            $roles = Get-MgDirectoryRole -All -ErrorAction Stop

            $report = foreach ($role in $roles) {
                $members = Get-MgDirectoryRoleMember `
                    -DirectoryRoleId $role.Id `
                    -All `
                    -ErrorAction SilentlyContinue

                foreach ($member in $members) {
                    $properties = $member.AdditionalProperties

                    [PSCustomObject]@{
                        RoleName          = $role.DisplayName
                        RoleId            = $role.Id
                        MemberId          = $member.Id
                        MemberDisplayName = $properties.displayName
                        MemberUserPrincipalName = $properties.userPrincipalName
                        MemberMail        = $properties.mail
                        MemberType        = $properties.'@odata.type'
                    }
                }
            }

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Admin role assignments exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export admin role assignments. $($_.Exception.Message)"
        }
    }
}