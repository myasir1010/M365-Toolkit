<#
.SYNOPSIS
    Reset a Microsoft 365 user password.

.DESCRIPTION
    Resets the password for a cloud-only Microsoft 365 user by updating the
    password profile using Microsoft Graph PowerShell.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user whose password will be reset.

.PARAMETER NewPassword
    The new password as a secure string.

.PARAMETER ForceChangePasswordNextSignIn
    Forces the user to change the password at the next sign-in.

.EXAMPLE
    $Password = Read-Host "Enter new password" -AsSecureString

    Reset-M365UserPassword `
        -UserPrincipalName "john.doe@contoso.com" `
        -NewPassword $Password

.EXAMPLE
    $Password = Read-Host "Enter new password" -AsSecureString

    Reset-M365UserPassword `
        -UserPrincipalName "john.doe@contoso.com" `
        -NewPassword $Password `
        -ForceChangePasswordNextSignIn

.EXAMPLE
    $Password = Read-Host "Enter new password" -AsSecureString

    Reset-M365UserPassword `
        -UserPrincipalName "john.doe@contoso.com" `
        -NewPassword $Password `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.ReadWrite.All
#>

function Reset-M365UserPassword {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [securestring]$NewPassword,

        [Parameter(Mandatory = $false)]
        [switch]$ForceChangePasswordNextSignIn
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
            throw "The Microsoft.Graph.Users module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Users -ErrorAction Stop
    }

    process {
        try {
            $plainTextPassword = [System.Net.NetworkCredential]::new("", $NewPassword).Password

            $passwordProfile = @{
                Password                      = $plainTextPassword
                ForceChangePasswordNextSignIn = [bool]$ForceChangePasswordNextSignIn
            }

            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Reset Microsoft 365 user password")) {
                Update-MgUser `
                    -UserId $UserPrincipalName `
                    -PasswordProfile $passwordProfile `
                    -ErrorAction Stop

                Write-Host "Successfully reset password for Microsoft 365 user: $UserPrincipalName" -ForegroundColor Green

                return [PSCustomObject]@{
                    UserPrincipalName             = $UserPrincipalName
                    ForceChangePasswordNextSignIn = [bool]$ForceChangePasswordNextSignIn
                    Status                        = "Completed"
                }
            }
        }
        catch {
            Write-Error "Failed to reset password for Microsoft 365 user '$UserPrincipalName'. $($_.Exception.Message)"
        }
        finally {
            if ($plainTextPassword) {
                Remove-Variable -Name plainTextPassword -Force -ErrorAction SilentlyContinue
            }
        }
    }
}