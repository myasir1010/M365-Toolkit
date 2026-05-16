<#
.SYNOPSIS
    Example script for M365 Toolkit.

.DESCRIPTION
    Shows how to run one M365 Toolkit scenario.

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

Import-Module ..\M365Toolkit.psd1 -Force
Connect-M365Toolkit -Graph -Scopes 'User.Read.All','Directory.Read.All','AuditLog.Read.All','Policy.Read.All'
Export-M365SecurityReport
