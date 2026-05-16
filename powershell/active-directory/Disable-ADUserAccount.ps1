<#
.SYNOPSIS
    Disable an Active Directory user account.

.DESCRIPTION
    Disables an on-premises Active Directory user account by identity.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The Active Directory user identity to disable.
    Accepts SamAccountName, DistinguishedName, GUID, SID, or UserPrincipalName.

.EXAMPLE
    Disable-ADUserAccount -Identity "john.doe"

.EXAMPLE
    Disable-ADUserAccount -Identity "john.doe" -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Requires the ActiveDirectory PowerShell module.
#>

function Disable-ADUserAccount {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity
    )

    begin {
        $ErrorActionPreference = 'Stop'

        if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
            throw "The ActiveDirectory module is not installed. Install RSAT Active Directory tools and try again."
        }

        Import-Module ActiveDirectory -ErrorAction Stop
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($Identity, 'Disable Active Directory user account')) {
                Disable-ADAccount -Identity $Identity -ErrorAction Stop

                Write-Host "Successfully disabled AD user account: $Identity" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to disable AD user account '$Identity'. $($_.Exception.Message)"
        }
    }
}