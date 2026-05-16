<#
.SYNOPSIS
    Export BitLocker recovery key metadata.

.DESCRIPTION
    Exports BitLocker recovery key metadata from Microsoft Graph.

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
function Export-BitLockerRecoveryKeys { [CmdletBinding()] param([string]$OutputPath='./reports/csv/bitlocker-keys.csv') $Data=Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/informationProtection/bitlocker/recoveryKeys?$top=999'; $Data.value | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }