<#
.SYNOPSIS
    Export Microsoft 365 inventory report.

.DESCRIPTION
    Runs user, group, license, and device inventory exports.

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
function Export-M365InventoryReport { [CmdletBinding()] param() Export-M365Users; Export-M365Groups; Export-M365LicenseReport; Export-EntraDevices }