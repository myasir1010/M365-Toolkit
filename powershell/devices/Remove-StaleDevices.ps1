<#
.SYNOPSIS
    Remove stale devices.

.DESCRIPTION
    Removes inactive Entra ID devices older than selected days.

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
function Remove-StaleDevices { [CmdletBinding(SupportsShouldProcess)] param([int]$InactiveDays=180) $Devices=Get-InactiveDevices -InactiveDays $InactiveDays; foreach($D in $Devices){ if($PSCmdlet.ShouldProcess($D.DisplayName,'Remove stale device')){ Remove-MgDevice -DeviceId $D.Id } } }