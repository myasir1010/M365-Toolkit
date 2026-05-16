<#
.SYNOPSIS
    Connect to Exchange Online.

.DESCRIPTION
    Connects to Exchange Online using ExchangeOnlineManagement.

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
function Connect-ExchangeToolkit { [CmdletBinding()] param([string]$UserPrincipalName,[switch]$InstallModules) Test-RequiredModule -ModuleName ExchangeOnlineManagement -InstallIfMissing:$InstallModules; if ($UserPrincipalName) { Connect-ExchangeOnline -UserPrincipalName $UserPrincipalName -ShowBanner:$false } else { Connect-ExchangeOnline -ShowBanner:$false } }