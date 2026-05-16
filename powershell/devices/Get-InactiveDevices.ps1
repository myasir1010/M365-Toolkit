<#
.SYNOPSIS
    Find inactive devices.

.DESCRIPTION
    Finds Entra ID devices not seen in selected days.

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
function Get-InactiveDevices { [CmdletBinding()] param([int]$InactiveDays=90,[string]$OutputPath) $Cutoff=(Get-Date).AddDays(-$InactiveDays); $Data=Get-MgDevice -All -Property DisplayName,DeviceId,ApproximateLastSignInDateTime,OperatingSystem,AccountEnabled | Where-Object { $_.ApproximateLastSignInDateTime -and ([datetime]$_.ApproximateLastSignInDateTime) -lt $Cutoff } | Select-Object DisplayName,DeviceId,OperatingSystem,AccountEnabled,ApproximateLastSignInDateTime; if($OutputPath){$Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8}; $Data }