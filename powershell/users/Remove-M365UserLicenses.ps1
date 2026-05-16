<#
.SYNOPSIS
    Remove all licenses from a Microsoft 365 user.

.DESCRIPTION
    Reads all assigned Microsoft 365 licenses from a user and removes them
    using Microsoft Graph PowerShell.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user whose licenses will be removed.

.EXAMPLE
    Remove-M365UserLicenses -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Remove-M365UserLicenses `
        -UserPrincipalName "john.doe@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - User.ReadWrite.All
    - Directory.ReadWrite.All
#>

function Remove-M365UserLicenses {
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
            $user = Get-MgUser `
                -UserId $UserPrincipalName `
                -Property Id, UserPrincipalName, AssignedLicenses `
                -ErrorAction Stop

            $skuIds = @(
                $user.AssignedLicenses |
                    Where-Object { $_.SkuId } |
                    ForEach-Object { $_.SkuId }
            )

            if (-not $skuIds -or $skuIds.Count -eq 0) {
                Write-Host "No licenses found for user: $UserPrincipalName" -ForegroundColor Yellow

                return [PSCustomObject]@{
                    UserPrincipalName = $UserPrincipalName
                    RemovedLicenses   = 0
                    Status            = "No licenses found"
                }
            }

            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Remove $($skuIds.Count) assigned Microsoft 365 license(s)")) {
                Set-MgUserLicense `
                    -UserId $user.Id `
                    -AddLicenses @() `
                    -RemoveLicenses $skuIds `
                    -ErrorAction Stop

                Write-Host "Successfully removed $($skuIds.Count) license(s) from user: $UserPrincipalName" -ForegroundColor Green

                return [PSCustomObject]@{
                    UserPrincipalName = $UserPrincipalName
                    RemovedLicenses   = $skuIds.Count
                    Status            = "Completed"
                }
            }
        }
        catch {
            Write-Error "Failed to remove licenses from Microsoft 365 user '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}