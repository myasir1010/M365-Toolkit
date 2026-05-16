<#
.SYNOPSIS
    Revoke Microsoft 365 user sessions.

.DESCRIPTION
    Invalidates refresh tokens and revokes active sign-in sessions for a Microsoft 365 user
    using Microsoft Graph PowerShell.

    This is commonly used during user offboarding or suspected account compromise response.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user whose sessions will be revoked.

.EXAMPLE
    Revoke-M365UserSessions -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Revoke-M365UserSessions `
        -UserPrincipalName "john.doe@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.RevokeSessions.All
#>

function Revoke-M365UserSessions {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users.Actions)) {
            throw "The Microsoft.Graph.Users.Actions module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Users.Actions -ErrorAction Stop
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Revoke Microsoft 365 user sign-in sessions")) {
                Revoke-MgUserSignInSession `
                    -UserId $UserPrincipalName `
                    -ErrorAction Stop

                Write-Host "Successfully revoked sign-in sessions for Microsoft 365 user: $UserPrincipalName" -ForegroundColor Green

                return [PSCustomObject]@{
                    UserPrincipalName = $UserPrincipalName
                    Status            = "Completed"
                    RevokedAt         = Get-Date
                }
            }
        }
        catch {
            Write-Error "Failed to revoke sessions for Microsoft 365 user '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}