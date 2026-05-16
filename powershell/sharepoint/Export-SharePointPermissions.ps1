<#
.SYNOPSIS
    Export SharePoint permissions.

.DESCRIPTION
    Exports SharePoint group memberships for a selected SharePoint Online site
    using PnP PowerShell and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER SiteUrl
    The SharePoint Online site URL where permissions will be exported from.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-SharePointPermissions `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha"

.EXAMPLE
    Export-SharePointPermissions `
        -SiteUrl "https://contoso.sharepoint.com/sites/project-alpha" `
        -OutputPath ".\reports\csv\sharepoint-permissions.csv"

.NOTES
    Run PowerShell as Administrator when local or SharePoint permissions are required.
    Requires the PnP.PowerShell module.
    Requires permission to read SharePoint site groups and members.
#>

function Export-SharePointPermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUrl,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\sharepoint-permissions.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
            throw "The PnP.PowerShell module is not installed. Install it using: Install-Module PnP.PowerShell -Scope CurrentUser"
        }

        Import-Module PnP.PowerShell -ErrorAction Stop

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
            Connect-PnPOnline `
                -Url $SiteUrl `
                -Interactive `
                -ErrorAction Stop

            $groups = Get-PnPGroup -ErrorAction Stop

            $report = foreach ($group in $groups) {
                try {
                    Get-PnPGroupMember `
                        -Identity $group `
                        -ErrorAction Stop |
                        Select-Object `
                            @{ Name = "SiteUrl"; Expression = { $SiteUrl } },
                            @{ Name = "GroupName"; Expression = { $group.Title } },
                            @{ Name = "GroupId"; Expression = { $group.Id } },
                            Title,
                            LoginName,
                            Email,
                            PrincipalType
                }
                catch {
                    Write-Warning "Could not retrieve members for SharePoint group '$($group.Title)'. $($_.Exception.Message)"
                }
            }

            $report |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "SharePoint permissions exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export SharePoint permissions for '$SiteUrl'. $($_.Exception.Message)"
        }
    }
}