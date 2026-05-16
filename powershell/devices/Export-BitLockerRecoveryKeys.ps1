<#
.SYNOPSIS
    Export BitLocker recovery key metadata.

.DESCRIPTION
    Exports BitLocker recovery key metadata from Microsoft Graph to a CSV file.

    This script exports recovery key metadata only. It does not export the actual
    BitLocker recovery passwords.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.EXAMPLE
    Export-BitLockerRecoveryKeys

.EXAMPLE
    Export-BitLockerRecoveryKeys -OutputPath ".\reports\csv\bitlocker-keys.csv"

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - BitLockerKey.ReadBasic.All

    To retrieve actual recovery key values, higher permissions are required.
#>

function Export-BitLockerRecoveryKeys {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\bitlocker-keys.csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
            throw "The Microsoft.Graph.Authentication module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
    }

    process {
        try {
            $uri = "https://graph.microsoft.com/v1.0/informationProtection/bitlocker/recoveryKeys?`$top=999"
            $recoveryKeys = @()

            do {
                $response = Invoke-MgGraphRequest `
                    -Method GET `
                    -Uri $uri `
                    -ErrorAction Stop

                if ($response.value) {
                    $recoveryKeys += $response.value
                }

                $uri = $response.'@odata.nextLink'
            }
            while ($uri)

            $recoveryKeys |
                Select-Object `
                    Id,
                    CreatedDateTime,
                    DeviceId,
                    VolumeType |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "BitLocker recovery key metadata exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export BitLocker recovery key metadata. $($_.Exception.Message)"
        }
    }
}