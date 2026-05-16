<#
.SYNOPSIS
    Assign a Microsoft 365 license.

.DESCRIPTION
    Assigns a license SKU to a user.

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

function Assign-M365License { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$UserPrincipalName,[Parameter(Mandatory)][string]$SkuPartNumber,[string]$UsageLocation='DE')
    Update-MgUser -UserId $UserPrincipalName -UsageLocation $UsageLocation
    $Sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $SkuPartNumber | Select-Object -First 1
    if (-not $Sku) { throw "SKU not found: $SkuPartNumber" }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Assign license $SkuPartNumber")) { Set-MgUserLicense -UserId $UserPrincipalName -AddLicenses @(@{SkuId=$Sku.SkuId}) -RemoveLicenses @() }
}
