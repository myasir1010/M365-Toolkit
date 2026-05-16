<#
.SYNOPSIS
    Export Microsoft 365 license report.

.DESCRIPTION
    Exports users and assigned license SKU IDs.

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

function Export-M365LicenseReport { [CmdletBinding()] param([string]$OutputPath='./reports/csv/m365-license-report.csv')
    $Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AssignedLicenses,AccountEnabled
    $Report = foreach ($User in $Users) { [pscustomobject]@{ DisplayName=$User.DisplayName; UserPrincipalName=$User.UserPrincipalName; AccountEnabled=$User.AccountEnabled; LicenseSkuIds=($User.AssignedLicenses.SkuId -join ';') } }
    $Report | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8
    Get-Item $OutputPath
}
