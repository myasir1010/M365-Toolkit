<#
.SYNOPSIS
    Get Microsoft 365 license overview.

.DESCRIPTION
    Lists subscribed SKU capacity and consumption.

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
function Get-M365LicenseOverview { [CmdletBinding()] param([string]$OutputPath)
    $Data = Get-MgSubscribedSku -All | Select-Object SkuPartNumber,SkuId,@{n='Enabled';e={$_.PrepaidUnits.Enabled}},ConsumedUnits,@{n='Available';e={$_.PrepaidUnits.Enabled - $_.ConsumedUnits}}
    if ($OutputPath) { $Data | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8 }
    $Data
}
r