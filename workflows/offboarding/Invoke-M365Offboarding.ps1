<#
.SYNOPSIS
    Run offboarding workflow.

.DESCRIPTION
    Runs the Microsoft 365 offboarding workflow for the M365 Toolkit.

    By default, this workflow:
    - Revokes user sessions
    - Disables Microsoft 365 sign-in
    - Removes the user from Microsoft 365 groups
    - Hides the mailbox from address lists
    - Disables mailbox client protocols
    - Converts the mailbox to a shared mailbox
    - Removes assigned licenses

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    The user principal name of the Microsoft 365 user to offboard.

.PARAMETER FormerEmployeesGroup
    Optional Microsoft 365 group display name where the user will be added after offboarding.

.PARAMETER OutOfOfficeMessage
    Optional mailbox auto-reply message to configure during offboarding.

.PARAMETER SkipLicenseRemoval
    Skips removing assigned Microsoft 365 licenses.

.PARAMETER SkipGroupRemoval
    Skips removing the user from Microsoft 365 groups.

.PARAMETER SkipMailboxConversion
    Skips converting the mailbox to a shared mailbox.

.PARAMETER ContinueOnError
    Continues running remaining offboarding steps even if one step fails.

.EXAMPLE
    Invoke-M365Offboarding -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Invoke-M365Offboarding `
        -UserPrincipalName "john.doe@contoso.com" `
        -FormerEmployeesGroup "Former Employees" `
        -OutOfOfficeMessage "John Doe is no longer with the company. Please contact support@contoso.com."

.EXAMPLE
    Invoke-M365Offboarding `
        -UserPrincipalName "john.doe@contoso.com" `
        -SkipLicenseRemoval `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft 365 permissions are required.
    Configure Microsoft Graph and Exchange Online permissions before running tenant-level automation.

    This workflow expects Invoke-M365UserOffboarding to be available.
#>

function Invoke-M365Offboarding {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$FormerEmployeesGroup,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutOfOfficeMessage,

        [Parameter(Mandatory = $false)]
        [switch]$SkipLicenseRemoval,

        [Parameter(Mandatory = $false)]
        [switch]$SkipGroupRemoval,

        [Parameter(Mandatory = $false)]
        [switch]$SkipMailboxConversion,

        [Parameter(Mandatory = $false)]
        [switch]$ContinueOnError
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Invoke-M365UserOffboarding -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Invoke-M365UserOffboarding. Import the M365Toolkit module first."
        }
    }

    process {
        try {
            if (-not $PSCmdlet.ShouldProcess($UserPrincipalName, "Run full Microsoft 365 offboarding workflow")) {
                return
            }

            $offboardingParameters = @{
                UserPrincipalName = $UserPrincipalName
                RemoveLicenses    = -not $SkipLicenseRemoval
                RemoveGroups      = -not $SkipGroupRemoval
                ConvertToSharedMailbox = -not $SkipMailboxConversion
            }

            if ($FormerEmployeesGroup) {
                $offboardingParameters.FormerEmployeesGroup = $FormerEmployeesGroup
            }

            if ($OutOfOfficeMessage) {
                $offboardingParameters.OutOfOfficeMessage = $OutOfOfficeMessage
            }

            if ($ContinueOnError) {
                $offboardingParameters.ContinueOnError = $true
            }

            Invoke-M365UserOffboarding @offboardingParameters
        }
        catch {
            Write-Error "Failed to run Microsoft 365 offboarding workflow for '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}