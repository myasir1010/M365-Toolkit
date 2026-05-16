<#
.SYNOPSIS
    Confirm potentially destructive actions.

.DESCRIPTION
    Provides a reusable confirmation helper.

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

function Confirm-ToolkitAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Message,
        [switch]$Force
    )
    if ($Force) { return $true }
    $Answer = Read-Host "$Message Type YES to continue"
    return ($Answer -eq 'YES')
}