<#
.SYNOPSIS
    Export Microsoft 365 audit report.

.DESCRIPTION
    Exports directory audit logs using Microsoft Graph.

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
function Export-M365AuditReport { [CmdletBinding()] param([string]$OutputPath='./reports/csv/audit-logs.csv') $Data=Get-MgAuditLogDirectoryAudit -All | Select-Object ActivityDateTime,ActivityDisplayName,Category,Result,LoggedByService; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }