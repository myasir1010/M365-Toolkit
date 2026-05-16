<#
.SYNOPSIS
    Export Microsoft 365 groups.

.DESCRIPTION
    Exports group inventory to CSV.

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
function Export-M365Groups { [CmdletBinding()] param([string]$OutputPath='./reports/csv/m365-groups.csv')
    $Groups = Get-MgGroup -All -Property Id,DisplayName,Description,Mail,MailEnabled,SecurityEnabled,CreatedDateTime,GroupTypes | Select-Object Id,DisplayName,Description,Mail,MailEnabled,SecurityEnabled,CreatedDateTime,@{n='GroupTypes';e={$_.GroupTypes -join ';'}}
    $Groups | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8
    Get-Item $OutputPath
}
r