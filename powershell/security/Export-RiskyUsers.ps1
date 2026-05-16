<#
.SYNOPSIS
    Export risky users.

.DESCRIPTION
    Exports Microsoft Entra ID Protection risky users from Microsoft Graph
    and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the risky users report will be exported as a CSV file.

.EXAMPLE
    Export-RiskyUsers

.EXAMPLE
    Export-RiskyUsers -OutputPath ".\reports\csv\risky-users.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - IdentityRiskyUser.Read.All
#>

function Export-RiskyUsers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\risky-users.csv"
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
            $uri = "https://graph.microsoft.com/v1.0/identityProtection/riskyUsers"
            $riskyUsers = @()

            do {
                $response = Invoke-MgGraphRequest `
                    -Method GET `
                    -Uri $uri `
                    -ErrorAction Stop

                if ($response.value) {
                    $riskyUsers += $response.value
                }

                $uri = $response.'@odata.nextLink'
            }
            while ($uri)

            $riskyUsers |
                Select-Object `
                    Id,
                    UserPrincipalName,
                    UserDisplayName,
                    RiskLevel,
                    RiskState,
                    RiskDetail,
                    IsDeleted,
                    IsProcessing,
                    RiskLastUpdatedDateTime |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Risky users report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export risky users report. $($_.Exception.Message)"
        }
    }
}