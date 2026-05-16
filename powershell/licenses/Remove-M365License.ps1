<#
.SYNOPSIS
    Remove a Microsoft 365 license.

.DESCRIPTION
    Removes a selected license SKU from a user.

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
function Remove-M365License { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$UserPrincipalName,[Parameter(Mandatory)][string]$SkuPartNumber)
    $Sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $SkuPartNumber | Select-Object -First 1
    if (-not $Sku) { throw "SKU not found: $SkuPartNumber" }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Remove license $SkuPartNumber")) { Set-MgUserLicense -UserId $UserPrincipalName -AddLicenses @() -RemoveLicenses @($Sku.SkuId) }
}
r