<#
.SYNOPSIS
    Run security-audit workflow.

.DESCRIPTION
    Runs the security-audit workflow for the M365 Toolkit.

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
function Invoke-M365SecurityAudit { [CmdletBinding()] param() Export-M365SecurityReport }