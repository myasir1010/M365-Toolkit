<#
.SYNOPSIS
    Remove team member.

.DESCRIPTION
    Removes a user from a Microsoft Team by removing the user from the Microsoft 365 group
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
    The user principal name of the user to remove from the Team.

.EXAMPLE
    Remove-TeamMemberToolkit `
        -TeamId "00000000-0000-0000-0000-000000000000" `
        -UserPrincipalName "john.doe@contoso.com"

.EXAMPLE
    Remove-TeamMemberToolkit `
        -TeamId "00000000-0000-0000-0000-000000000000" `
        -UserPrincipalName "john.doe@contoso.com" `
        -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permissions:
    - Group.ReadWrite.All
    - User.Read.All

    This function expects Remove-M365GroupMember to be available.
#>

function Remove-TeamMemberToolkit {
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

        if (-not (Get-Command -Name Remove-M365GroupMember -CommandType Function -ErrorAction SilentlyContinue)) {
            throw "Required function is missing: Remove-M365GroupMember. Import the M365Toolkit module first."
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($TeamId, "Remove $UserPrincipalName from Microsoft Team")) {
                Remove-M365GroupMember `
                    -GroupId $TeamId `
                    -UserPrincipalName $UserPrincipalName

                Write-Host "Successfully removed '$UserPrincipalName' from Microsoft Team '$TeamId'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to remove '$UserPrincipalName' from Microsoft Team '$TeamId'. $($_.Exception.Message)"
        }
    }
}