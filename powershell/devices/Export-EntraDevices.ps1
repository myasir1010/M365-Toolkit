<#
.SYNOPSIS
    Export Entra ID devices.

.DESCRIPTION
    Exports Entra ID device inventory.

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
function Export-EntraDevices { [CmdletBinding()] param([string]$OutputPath='./reports/csv/entra-devices.csv') $Data=Get-MgDevice -All -Property Id,DisplayName,OperatingSystem,OperatingSystemVersion,ApproximateLastSignInDateTime,AccountEnabled,IsCompliant,IsManaged | Select-Object Id,DisplayName,OperatingSystem,OperatingSystemVersion,ApproximateLastSignInDateTime,AccountEnabled,IsCompliant,IsManaged; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }