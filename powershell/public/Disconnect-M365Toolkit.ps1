<#
.SYNOPSIS
    Disconnect Microsoft 365 sessions.

.DESCRIPTION
    Disconnects active toolkit sessions where supported.

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
function Disconnect-M365Toolkit {
    [CmdletBinding()]
    param()
    try { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null } catch {}
    try { Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } catch {}
    try { Disconnect-PnPOnline -ErrorAction SilentlyContinue } catch {}
    try { Disconnect-MicrosoftTeams -ErrorAction SilentlyContinue | Out-Null } catch {}
    $script:M365ToolkitContext = $null
    Write-Host 'M365 Toolkit sessions disconnected.' -ForegroundColor Green
}
r