<#
.SYNOPSIS
    Write a structured toolkit log entry.

.DESCRIPTION
    Creates a log directory when required and writes timestamped log entries.

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
function Write-ToolkitLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet('INFO','SUCCESS','WARNING','ERROR','DEBUG')][string]$Level = 'INFO',
        [string]$LogPath = './logs/m365-toolkit.log'
    )
    $ResolvedLogPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LogPath)
    $Directory = Split-Path -Path $ResolvedLogPath -Parent
    if (-not (Test-Path $Directory)) { New-Item -ItemType Directory -Path $Directory -Force | Out-Null }
    $Line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    Add-Content -Path $ResolvedLogPath -Value $Line -Encoding UTF8
    if ($Level -eq 'ERROR') { Write-Error $Message -ErrorAction Continue }
    elseif ($Level -eq 'WARNING') { Write-Warning $Message }
    else { Write-Verbose $Message }
}
r