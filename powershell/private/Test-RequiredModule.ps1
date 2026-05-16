<#
.SYNOPSIS
    Install and import required PowerShell modules.

.DESCRIPTION
    Checks if a module exists, installs it when requested, and imports it.

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
function Test-RequiredModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ModuleName,
        [switch]$InstallIfMissing
    )
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        if ($InstallIfMissing) { Install-Module -Name $ModuleName -Scope CurrentUser -Force -AllowClobber }
        else { throw "Required module not found: $ModuleName" }
    }
    Import-Module $ModuleName -Force -ErrorAction Stop
}
r