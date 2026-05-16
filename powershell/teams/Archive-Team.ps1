<#
.SYNOPSIS
    Archive a Microsoft Team.

.DESCRIPTION
    Archives a Microsoft Team using Microsoft Teams PowerShell.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER GroupId
    The Microsoft 365 group ID of the Team to archive.

.EXAMPLE
    Archive-TeamToolkit -GroupId "00000000-0000-0000-0000-000000000000"

.EXAMPLE
    Archive-TeamToolkit `
        -GroupId "00000000-0000-0000-0000-000000000000" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Teams permissions are required.
    Requires the MicrosoftTeams PowerShell module.
    Connect to Microsoft Teams before running this function.

    Example:
    Connect-MicrosoftTeams
#>

function Archive-TeamToolkit {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupId
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
            throw "The MicrosoftTeams module is not installed. Install it using: Install-Module MicrosoftTeams -Scope CurrentUser"
        }

        Import-Module MicrosoftTeams -ErrorAction Stop

        if (-not (Get-Command -Name Set-TeamArchivedState -ErrorAction SilentlyContinue)) {
            throw "Set-TeamArchivedState is not available. Connect to Microsoft Teams first using Connect-MicrosoftTeams."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($GroupId, "Archive Microsoft Team")) {
                Set-TeamArchivedState `
                    -GroupId $GroupId `
                    -Archived $true `
                    -ErrorAction Stop

                Write-Host "Successfully archived Microsoft Team: $GroupId" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to archive Microsoft Team '$GroupId'. $($_.Exception.Message)"
        }
    }
}