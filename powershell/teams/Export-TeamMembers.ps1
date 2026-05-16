<#
.SYNOPSIS
    Export team members.

.DESCRIPTION
    Exports members of a selected Microsoft Team by Microsoft 365 group ID
    using Microsoft Graph and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER TeamId
    The Microsoft Team ID or Microsoft 365 group ID.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-TeamMembers `
        -TeamId "00000000-0000-0000-0000-000000000000"

.EXAMPLE
    Export-TeamMembers `
        -TeamId "00000000-0000-0000-0000-000000000000" `
        -OutputPath ".\reports\csv\team-members.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - GroupMember.Read.All
    - User.Read.All
#>

function Export-TeamMembers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TeamId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\team-members.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Groups)) {
            throw "The Microsoft.Graph.Groups module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Groups -ErrorAction Stop

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
            $members = Get-MgGroupMember `
                -GroupId $TeamId `
                -All `
                -ErrorAction Stop

            $report = foreach ($member in $members) {
                $properties = $member.AdditionalProperties

                [PSCustomObject]@{
                    TeamId            = $TeamId
                    MemberId          = $member.Id
                    DisplayName       = $properties.displayName
                    UserPrincipalName = $properties.userPrincipalName
                    Mail              = $properties.mail
                    JobTitle          = $properties.jobTitle
                    Department        = $properties.department
                    UserType          = $properties.userType
                    AccountEnabled    = $properties.accountEnabled
                    ObjectType        = $properties.'@odata.type'
                }
            }

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Team members exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export team members for Team '$TeamId'. $($_.Exception.Message)"
        }
    }
}