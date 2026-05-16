<#
.SYNOPSIS
    Create a Microsoft 365 group.

.DESCRIPTION
    Creates an Entra ID security group or Microsoft 365 group.

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

function New-M365Group { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$DisplayName,[string]$Description,[switch]$MailEnabled,[switch]$SecurityEnabled,[string]$MailNickname)
    if (-not $MailNickname) { $MailNickname = ($DisplayName -replace '[^a-zA-Z0-9]','').ToLower() }
    if ($PSCmdlet.ShouldProcess($DisplayName,'Create group')) { New-MgGroup -DisplayName $DisplayName -Description $Description -MailEnabled:$MailEnabled -MailNickname $MailNickname -SecurityEnabled:$SecurityEnabled }
}
