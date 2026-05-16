<#
.SYNOPSIS
    Export risky sign-ins.

.DESCRIPTION
    Exports risky sign-in detections.

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
function Export-RiskySignIns { [CmdletBinding()] param([string]$OutputPath='./reports/csv/risky-signins.csv') $Data=(Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/identityProtection/riskyUsers').value; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }