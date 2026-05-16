<#
.SYNOPSIS
    Remove mailbox permission.

.DESCRIPTION
    Removes mailbox permissions from a user in Exchange Online.
    By default, this function removes FullAccess permission.

    Supports -WhatIf and -Confirm through ShouldProcess.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The mailbox identity where permissions will be removed.
    Accepts mailbox alias, email address, user principal name, or distinguished name.

.PARAMETER User
    The user, group, or security principal whose mailbox permissions will be removed.

.PARAMETER AccessRights
    The mailbox access rights to remove.
    Defaults to FullAccess.

.EXAMPLE
    Remove-MailboxPermissionToolkit -Identity "shared.mailbox@contoso.com" -User "john.doe@contoso.com"

.EXAMPLE
    Remove-MailboxPermissionToolkit -Identity "shared.mailbox@contoso.com" -User "john.doe@contoso.com" -AccessRights FullAccess -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Remove-MailboxPermissionToolkit {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$User,

        [Parameter(Mandatory = $false)]
        [ValidateSet("FullAccess", "ReadPermission", "ChangePermission", "ChangeOwner", "DeleteItem")]
        [string[]]$AccessRights = @("FullAccess")
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Command -Name Remove-MailboxPermission -ErrorAction SilentlyContinue)) {
            throw "Remove-MailboxPermission is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }
    }

    process {
        try {
            $permissionText = $AccessRights -join ", "

            if ($PSCmdlet.ShouldProcess($Identity, "Remove $permissionText permission from $User")) {
                Remove-MailboxPermission `
                    -Identity $Identity `
                    -User $User `
                    -AccessRights $AccessRights `
                    -Confirm:$false `
                    -ErrorAction Stop

                Write-Host "Successfully removed $permissionText permission from '$User' on mailbox '$Identity'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to remove mailbox permission from '$User' on '$Identity'. $($_.Exception.Message)"
        }
    }
}