<#
.SYNOPSIS
    Update a Microsoft 365 user profile.

.DESCRIPTION
    Updates common Microsoft 365 user profile fields using Microsoft Graph PowerShell.

    Supported profile fields:
    - Display name
    - Department
    - Job title
    - Office location
    - Mobile phone

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user to update.

.PARAMETER DisplayName
    Optional new display name for the user.

.PARAMETER Department
    Optional department value for the user.

.PARAMETER JobTitle
    Optional job title value for the user.

.PARAMETER OfficeLocation
    Optional office location value for the user.

.PARAMETER MobilePhone
    Optional mobile phone number for the user.

.EXAMPLE
    Update-M365UserProfile `
        -UserPrincipalName "john.doe@contoso.com" `
        -Department "IT" `
        -JobTitle "System Engineer"

.EXAMPLE
    Update-M365UserProfile `
        -UserPrincipalName "john.doe@contoso.com" `
        -DisplayName "John Doe" `
        -OfficeLocation "Frankfurt" `
        -MobilePhone "+49 123 456789"

.EXAMPLE
    Update-M365UserProfile `
        -UserPrincipalName "john.doe@contoso.com" `
        -Department "Finance" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - User.ReadWrite.All
#>

function Update-M365UserProfile {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $false)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$Department,

        [Parameter(Mandatory = $false)]
        [string]$JobTitle,

        [Parameter(Mandatory = $false)]
        [string]$OfficeLocation,

        [Parameter(Mandatory = $false)]
        [string]$MobilePhone
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
            $updateBody = @{}

            if ($PSBoundParameters.ContainsKey("DisplayName")) {
                $updateBody.DisplayName = $DisplayName
            }

            if ($PSBoundParameters.ContainsKey("Department")) {
                $updateBody.Department = $Department
            }

            if ($PSBoundParameters.ContainsKey("JobTitle")) {
                $updateBody.JobTitle = $JobTitle
            }

            if ($PSBoundParameters.ContainsKey("OfficeLocation")) {
                $updateBody.OfficeLocation = $OfficeLocation
            }

            if ($PSBoundParameters.ContainsKey("MobilePhone")) {
                $updateBody.MobilePhone = $MobilePhone
            }

            if ($updateBody.Count -eq 0) {
                Write-Host "No profile fields were provided for update." -ForegroundColor Yellow

                return [PSCustomObject]@{
                    UserPrincipalName = $UserPrincipalName
                    UpdatedFields     = 0
                    Status            = "No changes requested"
                }
            }

            if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Update Microsoft 365 user profile")) {
                Update-MgUser `
                    -UserId $UserPrincipalName `
                    -BodyParameter $updateBody `
                    -ErrorAction Stop

                Write-Host "Successfully updated Microsoft 365 user profile: $UserPrincipalName" -ForegroundColor Green

                return [PSCustomObject]@{
                    UserPrincipalName = $UserPrincipalName
                    UpdatedFields     = ($updateBody.Keys -join ", ")
                    Status            = "Completed"
                }
            }
        }
        catch {
            Write-Error "Failed to update Microsoft 365 user profile '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}