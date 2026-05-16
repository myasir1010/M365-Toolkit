<#
.SYNOPSIS
    Add mailbox permission.

.DESCRIPTION
    Grants mailbox permissions to a user in Exchange Online.
    By default, this function grants FullAccess permission.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER Identity
    The mailbox identity where permissions will be granted.
    Accepts mailbox alias, email address, user principal name, or distinguished name.

.PARAMETER User
    The user, group, or security principal receiving mailbox permissions.

.PARAMETER AccessRights
    The mailbox access rights to grant.
    Defaults to FullAccess.

.EXAMPLE
    Add-MailboxPermissionToolkit -Identity "shared.mailbox@contoso.com" -User "john.doe@contoso.com"

.EXAMPLE
    Add-MailboxPermissionToolkit -Identity "shared.mailbox@contoso.com" -User "john.doe@contoso.com" -AccessRights FullAccess -WhatIf

.NOTES
    Run PowerShell as Administrator when local or Exchange permissions are required.
    Requires the ExchangeOnlineManagement PowerShell module.
    Connect to Exchange Online before running this function.
#>

function Add-MailboxPermissionToolkit {
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

        if (-not (Get-Command -Name Add-MailboxPermission -ErrorAction SilentlyContinue)) {
            throw "Add-MailboxPermission is not available. Connect to Exchange Online first using Connect-ExchangeOnline."
        }
    }

    process {
        try {
            $permissionText = $AccessRights -join ", "

            if ($PSCmdlet.ShouldProcess($Identity, "Grant $permissionText permission to $User")) {
                Add-MailboxPermission `
                    -Identity $Identity `
                    -User $User `
                    -AccessRights $AccessRights `
                    -InheritanceType All `
                    -ErrorAction Stop

                Write-Host "Successfully granted $permissionText permission to '$User' on mailbox '$Identity'." -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to grant mailbox permission to '$User' on '$Identity'. $($_.Exception.Message)"
        }
    }
}