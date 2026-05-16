<#
.SYNOPSIS
    Generate tenant security baseline.

.DESCRIPTION
    Creates a high-level security baseline from MFA, privileged role and external sharing checks.

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
function Get-TenantSecurityBaseline { [CmdletBinding()] param([string]$OutputPath='./reports/json/tenant-security-baseline.json') $Baseline=[ordered]@{GeneratedAt=(Get-Date);UsersWithoutMFA=(Import-Csv (Find-UsersWithoutMFA).FullName).Count;PrivilegedAssignments=(Import-Csv (Export-PrivilegedUsers).FullName).Count}; $Baseline|ConvertTo-Json -Depth 5|Set-Content $OutputPath -Encoding UTF8; Get-Item $OutputPath }