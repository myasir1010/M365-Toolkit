<#
.SYNOPSIS
    Export Microsoft 365 users.

.DESCRIPTION
    Exports cloud user inventory to CSV.

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
function Export-M365Users {
    [CmdletBinding()]
    param([string]$OutputPath = './reports/csv/m365-users.csv')
    $Users = Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,Mail,Department,JobTitle,AccountEnabled,UserType,CreatedDateTime,UsageLocation |
        Select-Object DisplayName,UserPrincipalName,Mail,Department,JobTitle,AccountEnabled,UserType,CreatedDateTime,UsageLocation
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Get-Item $OutputPath
}
r