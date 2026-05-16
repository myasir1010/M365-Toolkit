<#
.SYNOPSIS
    Reset an Active Directory user password.

.DESCRIPTION
    Resets an on-premises Active Directory user password.
    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The Active Directory user identity whose password will be reset.
    Accepts SamAccountName, DistinguishedName, GUID, SID, or UserPrincipalName.

.PARAMETER NewPassword
    The new password as a secure string.

.PARAMETER ChangePasswordAtLogon
    Forces the user to change the password at the next sign-in.

.EXAMPLE
    $Password = Read-Host "Enter new password" -AsSecureString
    Reset-ADUserPassword -Identity "john.doe" -NewPassword $Password

.EXAMPLE
    $Password = Read-Host "Enter new password" -AsSecureString
    Reset-ADUserPassword -Identity "john.doe" -NewPassword $Password -ChangePasswordAtLogon

.EXAMPLE
    $Password = Read-Host "Enter new password" -AsSecureString
    Reset-ADUserPassword -Identity "john.doe" -NewPassword $Password -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Requires the ActiveDirectory PowerShell module.
#>

function Reset-ADUserPassword {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [securestring]$NewPassword,

        [Parameter(Mandatory = $false)]
        [switch]$ChangePasswordAtLogon
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
            if ($PSCmdlet.ShouldProcess($Identity, "Reset Active Directory user password")) {
                Set-ADAccountPassword `
                    -Identity $Identity `
                    -NewPassword $NewPassword `
                    -Reset `
                    -ErrorAction Stop

                if ($ChangePasswordAtLogon) {
                    Set-ADUser `
                        -Identity $Identity `
                        -ChangePasswordAtLogon $true `
                        -ErrorAction Stop
                }

                Write-Host "Successfully reset password for AD user: $Identity" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to reset password for AD user '$Identity'. $($_.Exception.Message)"
        }
    }
}