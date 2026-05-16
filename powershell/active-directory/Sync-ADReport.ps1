<#
.SYNOPSIS
    Create Active Directory report.

.DESCRIPTION
    Exports AD users, groups, and inactive object reports.

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
function Sync-ADReport { [CmdletBinding()] param() Export-ADUsers; Export-ADGroups; Find-InactiveADUsers; Find-InactiveADComputers }