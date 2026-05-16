<#
.SYNOPSIS
    Run Microsoft 365 user offboarding.

.DESCRIPTION
    Runs common Microsoft 365 user offboarding actions, including:
    - Revoke active sessions
    - Disable user sign-in
    - Remove user from groups
    - Add user to a former employees group
    - Set mailbox auto-reply
    - Hide mailbox from address lists
    - Disable mailbox client protocols
    - Convert mailbox to shared mailbox
    - Remove assigned licenses

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
    Optional auto-reply message to configure on the user's mailbox.

.PARAMETER RemoveLicenses
    Removes all assigned Microsoft 365 licenses from the user.

.PARAMETER RemoveGroups
    Removes the user from all Microsoft 365 groups.

.PARAMETER ConvertToSharedMailbox
    Converts the user's mailbox to a shared mailbox.

.PARAMETER ContinueOnError
    Continues running remaining offboarding steps even if one step fails.

.EXAMPLE
    Invoke-M365UserOffboarding -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Invoke-M365UserOffboarding `
        -UserPrincipalName "john.doe@contoso.com" `
        -FormerEmployeesGroup "Former Employees" `
        -OutOfOfficeMessage "John Doe is no longer with the company. Please contact support@contoso.com." `
        -RemoveGroups `
        -RemoveLicenses `
        -ConvertToSharedMailbox

.EXAMPLE
    Invoke-M365UserOffboarding `
        -UserPrincipalName "john.doe@contoso.com" `
        -RemoveGroups `
        -RemoveLicenses `
        -ConvertToSharedMailbox `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft 365 permissions are required.
    Configure Microsoft Graph and Exchange Online permissions before running tenant-level automation.

    Recommended Microsoft Graph permissions:
    - User.ReadWrite.All
    - Group.ReadWrite.All
    - Directory.ReadWrite.All

    Exchange Online connection is required for mailbox-related actions.

    This function expects the following toolkit functions to be available:
    - Revoke-M365UserSessions
    - Disable-M365User
    - Remove-M365UserFromAllGroups
    - Add-M365GroupMember
    - Set-MailboxAutoReply
    - Hide-MailboxFromAddressList
    - Disable-MailboxProtocols
    - Convert-MailboxToShared
    - Remove-M365UserLicenses
#>

function Invoke-M365UserOffboarding {
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
        [switch]$RemoveLicenses,

        [Parameter(Mandatory = $false)]
        [switch]$RemoveGroups,

        [Parameter(Mandatory = $false)]
        [switch]$ConvertToSharedMailbox,

        [Parameter(Mandatory = $false)]
        [switch]$ContinueOnError
    )

    begin {
        $ErrorActionPreference = "Stop"

        $requiredFunctions = @(
            "Revoke-M365UserSessions",
            "Disable-M365User",
            "Hide-MailboxFromAddressList",
            "Disable-MailboxProtocols"
        )

        $optionalFunctionMap = @{
            RemoveGroups            = "Remove-M365UserFromAllGroups"
            FormerEmployeesGroup    = "Add-M365GroupMember"
            OutOfOfficeMessage      = "Set-MailboxAutoReply"
            ConvertToSharedMailbox  = "Convert-MailboxToShared"
            RemoveLicenses          = "Remove-M365UserLicenses"
        }

        foreach ($functionName in $requiredFunctions) {
            if (-not (Get-Command -Name $functionName -CommandType Function -ErrorAction SilentlyContinue)) {
                throw "Required function is missing: $functionName. Import the M365Toolkit module first."
            }
        }

        if ($RemoveGroups -and -not (Get-Command -Name $optionalFunctionMap.RemoveGroups -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing for -RemoveGroups: $($optionalFunctionMap.RemoveGroups)."
        }

        if ($FormerEmployeesGroup -and -not (Get-Command -Name $optionalFunctionMap.FormerEmployeesGroup -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing for -FormerEmployeesGroup: $($optionalFunctionMap.FormerEmployeesGroup)."
        }

        if ($OutOfOfficeMessage -and -not (Get-Command -Name $optionalFunctionMap.OutOfOfficeMessage -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing for -OutOfOfficeMessage: $($optionalFunctionMap.OutOfOfficeMessage)."
        }

        if ($ConvertToSharedMailbox -and -not (Get-Command -Name $optionalFunctionMap.ConvertToSharedMailbox -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing for -ConvertToSharedMailbox: $($optionalFunctionMap.ConvertToSharedMailbox)."
        }

        if ($RemoveLicenses -and -not (Get-Command -Name $optionalFunctionMap.RemoveLicenses -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing for -RemoveLicenses: $($optionalFunctionMap.RemoveLicenses)."
        }

        function Invoke-OffboardingStep {
            param(
                [Parameter(Mandatory = $true)]
                [string]$StepName,

                [Parameter(Mandatory = $true)]
                [scriptblock]$Action
            )

            try {
                Write-Host "Running step: $StepName" -ForegroundColor Cyan
                & $Action
                Write-Host "Completed step: $StepName" -ForegroundColor Green

                return [PSCustomObject]@{
                    Step      = $StepName
                    Status    = "Completed"
                    Error     = $null
                    Timestamp = Get-Date
                }
            }
            catch {
                Write-Host "Failed step: $StepName" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red

                $result = [PSCustomObject]@{
                    Step      = $StepName
                    Status    = "Failed"
                    Error     = $_.Exception.Message
                    Timestamp = Get-Date
                }

                if (-not $ContinueOnError) {
                    throw
                }

                return $result
            }
        }
    }

    process {
        try {
            if (-not $PSCmdlet.ShouldProcess($UserPrincipalName, "Run Microsoft 365 user offboarding")) {
                return
            }

            Write-Host "Starting Microsoft 365 offboarding for: $UserPrincipalName" -ForegroundColor Cyan

            $results = @()

            $results += Invoke-OffboardingStep -StepName "Revoke active sessions" -Action {
                Revoke-M365UserSessions -UserPrincipalName $UserPrincipalName
            }

            $results += Invoke-OffboardingStep -StepName "Disable user sign-in" -Action {
                Disable-M365User -UserPrincipalName $UserPrincipalName
            }

            if ($RemoveGroups) {
                $results += Invoke-OffboardingStep -StepName "Remove user from all groups" -Action {
                    Remove-M365UserFromAllGroups -UserPrincipalName $UserPrincipalName
                }
            }

            if ($FormerEmployeesGroup) {
                $results += Invoke-OffboardingStep -StepName "Add user to former employees group" -Action {
                    Add-M365GroupMember `
                        -GroupDisplayName $FormerEmployeesGroup `
                        -UserPrincipalName $UserPrincipalName
                }
            }

            if ($OutOfOfficeMessage) {
                $results += Invoke-OffboardingStep -StepName "Set mailbox auto-reply" -Action {
                    Set-MailboxAutoReply `
                        -Identity $UserPrincipalName `
                        -InternalMessage $OutOfOfficeMessage `
                        -ExternalMessage $OutOfOfficeMessage
                }
            }

            $results += Invoke-OffboardingStep -StepName "Hide mailbox from address lists" -Action {
                Hide-MailboxFromAddressList -Identity $UserPrincipalName
            }

            $results += Invoke-OffboardingStep -StepName "Disable mailbox client protocols" -Action {
                Disable-MailboxProtocols -Identity $UserPrincipalName
            }

            if ($ConvertToSharedMailbox) {
                $results += Invoke-OffboardingStep -StepName "Convert mailbox to shared mailbox" -Action {
                    Convert-MailboxToShared -Identity $UserPrincipalName
                }
            }

            if ($RemoveLicenses) {
                $results += Invoke-OffboardingStep -StepName "Remove user licenses" -Action {
                    Remove-M365UserLicenses -UserPrincipalName $UserPrincipalName
                }
            }

            $failedSteps = @($results | Where-Object { $_.Status -eq "Failed" })

            Write-Host ""
            Write-Host "Microsoft 365 offboarding completed for: $UserPrincipalName" -ForegroundColor Green
            Write-Host "Completed steps: $(@($results | Where-Object { $_.Status -eq 'Completed' }).Count)" -ForegroundColor Green
            Write-Host "Failed steps: $($failedSteps.Count)" -ForegroundColor $(if ($failedSteps.Count -gt 0) { "Red" } else { "Green" })

            return [PSCustomObject]@{
                UserPrincipalName = $UserPrincipalName
                CompletedSteps    = @($results | Where-Object { $_.Status -eq "Completed" }).Count
                FailedSteps       = $failedSteps.Count
                Results           = $results
                GeneratedAt       = Get-Date
            }
        }
        catch {
            Write-Error "Microsoft 365 offboarding failed for '$UserPrincipalName'. $($_.Exception.Message)"
        }
    }
}