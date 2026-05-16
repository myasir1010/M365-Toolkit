<#
.SYNOPSIS
    Export Conditional Access policies.

.DESCRIPTION
    Exports Microsoft Entra Conditional Access policies using Microsoft Graph
    and saves the result to a JSON file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the Conditional Access policies JSON file will be saved.

.EXAMPLE
    Get-ConditionalAccessPolicies

.EXAMPLE
    Get-ConditionalAccessPolicies -OutputPath ".\reports\json\conditional-access-policies.json"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - Policy.Read.All
#>

function Get-ConditionalAccessPolicies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\json\conditional-access-policies.json"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
            throw "The Microsoft.Graph.Authentication module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

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
            $uri = "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies"
            $policies = @()

            do {
                $response = Invoke-MgGraphRequest `
                    -Method GET `
                    -Uri $uri `
                    -ErrorAction Stop

                if ($response.value) {
                    $policies += $response.value
                }

                $uri = $response.'@odata.nextLink'
            }
            while ($uri)

            $exportObject = [PSCustomObject]@{
                GeneratedAt = Get-Date
                Count       = $policies.Count
                Policies    = $policies
            }

            $exportObject |
                ConvertTo-Json -Depth 30 |
                Set-Content `
                    -Path $OutputPath `
                    -Encoding UTF8

            Write-Host "Conditional Access policies exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export Conditional Access policies. $($_.Exception.Message)"
        }
    }
}