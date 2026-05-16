<#
.SYNOPSIS
    Remove all licenses from a Microsoft 365 user.

.DESCRIPTION
    Reads assigned licenses and removes them using Microsoft Graph.

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
function Remove-M365UserLicenses {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$UserPrincipalName)
    $User = Get-MgUser -UserId $UserPrincipalName -Property Id,AssignedLicenses
    $SkuIds = @($User.AssignedLicenses | ForEach-Object { $_.SkuId })
    if (-not $SkuIds) { Write-Host 'No licenses found.' -ForegroundColor Yellow; return }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Remove $($SkuIds.Count) licenses")) { Set-MgUserLicense -UserId $User.Id -AddLicenses @() -RemoveLicenses $SkuIds }
}
r