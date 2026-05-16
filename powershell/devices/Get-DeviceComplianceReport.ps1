<#
.SYNOPSIS
    Get device compliance report.

.DESCRIPTION
    Exports device compliance-related fields from Entra ID.

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
function Get-DeviceComplianceReport { [CmdletBinding()] param([string]$OutputPath='./reports/csv/device-compliance.csv') $Data=Get-MgDevice -All -Property DisplayName,OperatingSystem,IsManaged,IsCompliant,ApproximateLastSignInDateTime | Select-Object DisplayName,OperatingSystem,IsManaged,IsCompliant,ApproximateLastSignInDateTime; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }