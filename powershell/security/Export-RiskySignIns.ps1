<#
.SYNOPSIS
    Export risky sign-ins.

.DESCRIPTION
    Exports Microsoft Entra ID risky user detections from Microsoft Graph Identity Protection
    and saves the result to a CSV file.

    Note:
    The Microsoft Graph v1.0 endpoint used here returns risky users, not individual
    sign-in events. For detailed sign-in logs, use Microsoft Graph audit sign-ins
    endpoints with the required permissions.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the risky sign-ins report will be exported as a CSV file.

.EXAMPLE
    Export-RiskySignIns

.EXAMPLE
    Export-RiskySignIns -OutputPath ".\reports\csv\risky-signins.csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - IdentityRiskyUser.Read.All
#>

function Export-RiskySignIns {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\risky-signins.csv"
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

            Write-Host "Risky sign-ins report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export risky sign-ins report. $($_.Exception.Message)"
        }
    }
}