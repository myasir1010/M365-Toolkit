<#
.SYNOPSIS
    Import toolkit JSON configuration.

.DESCRIPTION
    Loads a JSON configuration file as a PowerShell object.

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
function Import-ToolkitConfig {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path $Path)) { throw "Config file not found: $Path" }
    Get-Content -Path $Path -Raw -Encoding UTF8 | ConvertFrom-Json
}