<#
.SYNOPSIS
    Create a Microsoft 365 user.

.DESCRIPTION
    Creates a cloud-only Microsoft 365 user using Microsoft Graph PowerShell.

    The function creates an enabled user account, sets the password profile,
    configures usage location, and optionally sets department and job title.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name for the new Microsoft 365 user.

.PARAMETER DisplayName
    The display name of the new user.

.PARAMETER GivenName
    The given name or first name of the new user.

.PARAMETER Surname
    The surname or last name of the new user.

.PARAMETER Password
    The temporary password for the new user as a secure string.

.PARAMETER UsageLocation
    The two-letter ISO country code used for Microsoft 365 licensing.
    Defaults to DE.

.PARAMETER Department
    Optional department value for the new user.

.PARAMETER JobTitle
    Optional job title value for the new user.

.PARAMETER MailNickname
    Optional mail nickname for the new user.
    If omitted, the value before @ in the user principal name is used.

.PARAMETER ForceChangePasswordNextSignIn
    Forces the user to change the password at next sign-in.
    Defaults to true.

.EXAMPLE
    $Password = Read-Host "Enter temporary password" -AsSecureString

    New-M365User `
        -UserPrincipalName "john.doe@contoso.com" `
        -DisplayName "John Doe" `
        -GivenName "John" `
        -Surname "Doe" `
        -Password $Password `
        -UsageLocation "DE"

.EXAMPLE
    $Password = Read-Host "Enter temporary password" -AsSecureString

    New-M365User `
        -UserPrincipalName "jane.smith@contoso.com" `
        -DisplayName "Jane Smith" `
        -GivenName "Jane" `
        -Surname "Smith" `
        -Password $Password `
        -Department "Finance" `
        -JobTitle "Accountant" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.ReadWrite.All
#>

function New-M365User {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GivenName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Surname,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [securestring]$Password,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[A-Z]{2}$")]
        [string]$UsageLocation = "DE",

        [Parameter(Mandatory = $false)]
        [string]$Department,

        [Parameter(Mandatory = $false)]
        [string]$JobTitle,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[a-zA-Z0-9._-]+$")]
        [string]$MailNickname,

        [Parameter(Mandatory = $false)]
        [bool]$ForceChangePasswordNextSignIn = $true
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
            if (-not $MailNickname) {
                $MailNickname = ($UserPrincipalName -split "@")[0]
            }

            $plainTextPassword = [System.Net.NetworkCredential]::new("", $Password).Password

            $passwordProfile = @{
                ForceChangePasswordNextSignIn = $ForceChangePasswordNextSignIn
                Password                      = $plainTextPassword
            }

            $newUserParameters = @{
                AccountEnabled    = $true
                UserPrincipalName = $UserPrincipalName
                DisplayName       = $DisplayName
                GivenName         = $GivenName
                Surname           = $Surname
                MailNickname      = $MailNickname
                PasswordProfile   = $passwordProfile
                UsageLocation     = $UsageLocation
                ErrorAction       = "Stop"
            }

            if ($Department) {
                $newUserParameters.Department = $Department
            }

            if ($JobTitle) {
                $newUserParameters.JobTitle = $JobTitle
            }

            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Create Microsoft 365 user")) {
                $createdUser = New-MgUser @newUserParameters

                Write-Host "Successfully created Microsoft 365 user: $UserPrincipalName" -ForegroundColor Green

                return $createdUser
            }
        }
        catch {
            Write-Error "Failed to create Microsoft 365 user '$UserPrincipalName'. $($_.Exception.Message)"
        }
        finally {
            if ($plainTextPassword) {
                Remove-Variable -Name plainTextPassword -Force -ErrorAction SilentlyContinue
            }
        }
    }
}