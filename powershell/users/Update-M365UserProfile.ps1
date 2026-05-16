<#
.SYNOPSIS
    Update a Microsoft 365 user profile.

.DESCRIPTION
    Updates common user profile fields using Microsoft Graph PowerShell.

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
function Update-M365UserProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$UserPrincipalName,[string]$DisplayName,[string]$Department,[string]$JobTitle,[string]$OfficeLocation,[string]$MobilePhone)
    $Body = @{}
    foreach ($Key in 'DisplayName','Department','JobTitle','OfficeLocation','MobilePhone') { if ($PSBoundParameters.ContainsKey($Key)) { $Body[$Key.Substring(0,1).ToLower()+$Key.Substring(1)] = $PSBoundParameters[$Key] } }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Update user profile')) { Update-MgUser -UserId $UserPrincipalName -BodyParameter $Body }
}
r