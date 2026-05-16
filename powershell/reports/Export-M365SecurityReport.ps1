<#
.SYNOPSIS
    Export Microsoft 365 security report.

.DESCRIPTION
    Runs MFA, privileged user, risky user, and baseline reports.

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
function Export-M365SecurityReport { [CmdletBinding()] param() Get-MFAStatusReport; Find-UsersWithoutMFA; Export-PrivilegedUsers; Export-RiskyUsers; Get-TenantSecurityBaseline }