<#
.SYNOPSIS
    Disable a Microsoft 365 user.

.DESCRIPTION
    Blocks Microsoft 365 user sign-in by setting the accountEnabled property
    to false using Microsoft Graph.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user to disable.

.EXAMPLE
    Disable-M365User -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Disable-M365User `
        -UserPrincipalName "john.doe@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.ReadWrite.All
#>

function Disable-M365User {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName
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
            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Disable Microsoft 365 user sign-in")) {
                Update-MgUser `
                    -UserId $UserPrincipalName `
                    -AccountEnabled:$false `
                    -ErrorAction Stop

                Write-Host "Successfully disabled Microsoft 365 user: $UserPrincipalName" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to disable Microsoft 365 user '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}