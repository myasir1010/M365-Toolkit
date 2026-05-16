<#
.SYNOPSIS
    Show current toolkit connection context.

.DESCRIPTION
    Displays cached connection context for current PowerShell session.

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
function Get-M365ToolkitContext {
    [CmdletBinding()]
    param()
    if ($script:M365ToolkitContext) { [pscustomobject]$script:M365ToolkitContext }
    else { Write-Warning 'No M365 Toolkit context found. Run Connect-M365Toolkit first.' }
}