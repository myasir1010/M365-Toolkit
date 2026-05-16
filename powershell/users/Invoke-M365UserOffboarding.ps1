<#
.SYNOPSIS
    Run Microsoft 365 user offboarding.

.DESCRIPTION
    Runs common offboarding actions: revoke sessions, disable login, hide mailbox, set auto-reply, convert mailbox, remove licenses and groups.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Run PowerShell as Administrator when local or Active Directory permissions are required.
    Configure app permissions, delegated permissions, or admin consent before running tenant-level automation.
#>
r
function Invoke-M365UserOffboarding {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$UserPrincipalName,[string]$FormerEmployeesGroup,[string]$OutOfOfficeMessage,[switch]$RemoveLicenses,[switch]$RemoveGroups,[switch]$ConvertToSharedMailbox)
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Run Microsoft 365 offboarding')) {
        Revoke-M365UserSessions -UserPrincipalName $UserPrincipalName
        Disable-M365User -UserPrincipalName $UserPrincipalName
        if ($RemoveGroups) { Remove-M365UserFromAllGroups -UserPrincipalName $UserPrincipalName }
        if ($FormerEmployeesGroup) { Add-M365GroupMember -GroupDisplayName $FormerEmployeesGroup -UserPrincipalName $UserPrincipalName }
        if ($OutOfOfficeMessage) { Set-MailboxAutoReply -Identity $UserPrincipalName -InternalMessage $OutOfOfficeMessage -ExternalMessage $OutOfOfficeMessage }
        Hide-MailboxFromAddressList -Identity $UserPrincipalName
        Disable-MailboxProtocols -Identity $UserPrincipalName
        if ($ConvertToSharedMailbox) { Convert-MailboxToShared -Identity $UserPrincipalName }
        if ($RemoveLicenses) { Remove-M365UserLicenses -UserPrincipalName $UserPrincipalName }
    }
}
r