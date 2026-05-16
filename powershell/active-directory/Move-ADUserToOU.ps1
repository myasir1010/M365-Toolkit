<#
.SYNOPSIS
    Move an Active Directory user to an organizational unit.

.DESCRIPTION
    Moves an on-premises Active Directory user account to a target organizational unit.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The Active Directory user identity to move.
    Accepts SamAccountName, DistinguishedName, GUID, SID, or UserPrincipalName.

.PARAMETER TargetOU
    The distinguished name of the target organizational unit.

.EXAMPLE
    Move-ADUserToOU -Identity "john.doe" -TargetOU "OU=Disabled Users,DC=contoso,DC=com"

.EXAMPLE
    Move-ADUserToOU -Identity "john.doe" -TargetOU "OU=Disabled Users,DC=contoso,DC=com" -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Requires the ActiveDirectory PowerShell module.
#>

function Move-ADUserToOU {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TargetOU
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
            throw "The ActiveDirectory module is not installed. Install RSAT Active Directory tools and try again."
        }

        Import-Module ActiveDirectory -ErrorAction Stop
    }

    process {
        try {
            $user = Get-ADUser -Identity $Identity -ErrorAction Stop

            $targetOrganizationalUnit = Get-ADOrganizationalUnit `
                -Identity $TargetOU `
                -ErrorAction Stop

            if ($PSCmdlet.ShouldProcess($Identity, "Move AD user to $($targetOrganizationalUnit.DistinguishedName)")) {
                Move-ADObject `
                    -Identity $user.DistinguishedName `
                    -TargetPath $targetOrganizationalUnit.DistinguishedName `
                    -ErrorAction Stop

                Write-Host "Successfully moved AD user '$Identity' to '$($targetOrganizationalUnit.DistinguishedName)'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to move AD user '$Identity' to '$TargetOU'. $($_.Exception.Message)"
        }
    }
}