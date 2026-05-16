<#
.SYNOPSIS
    Create a Microsoft 365 user.

.DESCRIPTION
    Creates a cloud user using Microsoft Graph PowerShell.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure app permissions, delegated permissions, or admin consent before running tenant-level automation.
#>
r
function New-M365User {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$UserPrincipalName,
        [Parameter(Mandatory)][string]$DisplayName,
        [Parameter(Mandatory)][string]$GivenName,
        [Parameter(Mandatory)][string]$Surname,
        [Parameter(Mandatory)][string]$Password,
        [string]$UsageLocation = 'DE',
        [string]$Department,
        [string]$JobTitle,
        [string]$MailNickname
    )
    if (-not $MailNickname) { $MailNickname = ($UserPrincipalName -split '@')[0] }
    $PasswordProfile = @{ forceChangePasswordNextSignIn = $true; password = $Password }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName, 'Create Microsoft 365 user')) {
        New-MgUser -AccountEnabled:$true -UserPrincipalName $UserPrincipalName -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname -MailNickname $MailNickname -PasswordProfile $PasswordProfile -UsageLocation $UsageLocation -Department $Department -JobTitle $JobTitle
    }
}
r