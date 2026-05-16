<#
.SYNOPSIS
    Enable a Microsoft 365 user.

.DESCRIPTION
    Enables Microsoft 365 user sign-in by setting the accountEnabled property
    to true using Microsoft Graph.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user to enable.

.EXAMPLE
    Enable-M365User -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Enable-M365User `
        -UserPrincipalName "john.doe@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.ReadWrite.All
#>

function Enable-M365User {
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
            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Enable Microsoft 365 user sign-in")) {
                Update-MgUser `
                    -UserId $UserPrincipalName `
                    -AccountEnabled:$true `
                    -ErrorAction Stop

                Write-Host "Successfully enabled Microsoft 365 user: $UserPrincipalName" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to enable Microsoft 365 user '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}