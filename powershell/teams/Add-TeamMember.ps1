<#
.SYNOPSIS
    Add team member.

.DESCRIPTION
    Adds a user to a Microsoft Team by adding the user to the Microsoft 365 group
    backing the Team.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER TeamId
    The Microsoft Team ID or Microsoft 365 group ID.

.PARAMETER UserPrincipalName
    The user principal name of the user to add to the Team.

.EXAMPLE
    Add-TeamMemberToolkit `
        -TeamId "00000000-0000-0000-0000-000000000000" `
        -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Add-TeamMemberToolkit `
        -TeamId "00000000-0000-0000-0000-000000000000" `
        -UserPrincipalName "john.doe@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - Group.ReadWrite.All
    - User.Read.All

    This function expects Add-M365GroupMember to be available.
#>

function Add-TeamMemberToolkit {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TeamId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Add-M365GroupMember -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Add-M365GroupMember. Import the M365Toolkit module first."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($TeamId, "Add $UserPrincipalName as Microsoft Team member")) {
                Add-M365GroupMember `
                    -GroupId $TeamId `
                    -UserPrincipalName $UserPrincipalName

                Write-Host "Successfully added '$UserPrincipalName' to Microsoft Team '$TeamId'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to add '$UserPrincipalName' to Microsoft Team '$TeamId'. $($_.Exception.Message)"
        }
    }
}