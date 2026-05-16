<#
.SYNOPSIS
    Connect to Microsoft 365 services.

.DESCRIPTION
    Connects to Microsoft Graph, Exchange Online, SharePoint Online, Teams, or Active Directory module depending on selected switches.

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
function Connect-M365Toolkit {
    [CmdletBinding()]
    param(
        [string[]]$Scopes = @('User.Read.All','Group.Read.All','Directory.Read.All','AuditLog.Read.All'),
        [switch]$Graph,
        [switch]$ExchangeOnline,
        [string]$ExchangeUserPrincipalName,
        [switch]$SharePoint,
        [string]$SharePointUrl,
        [switch]$Teams,
        [switch]$ActiveDirectory,
        [switch]$InstallModules
    )
    if (-not ($Graph -or $ExchangeOnline -or $SharePoint -or $Teams -or $ActiveDirectory)) { $Graph = $true }
    if ($Graph) {
        Test-RequiredModule -ModuleName Microsoft.Graph.Authentication -InstallIfMissing:$InstallModules
        Connect-MgGraph -Scopes $Scopes -NoWelcome
        $script:M365ToolkitContext = [ordered]@{ Graph = $true; Scopes = $Scopes; ConnectedAt = Get-Date }
    }
    if ($ExchangeOnline) {
        Test-RequiredModule -ModuleName ExchangeOnlineManagement -InstallIfMissing:$InstallModules
        if ($ExchangeUserPrincipalName) { Connect-ExchangeOnline -UserPrincipalName $ExchangeUserPrincipalName -ShowBanner:$false }
        else { Connect-ExchangeOnline -ShowBanner:$false }
        $script:M365ToolkitContext.ExchangeOnline = $true
    }
    if ($SharePoint) {
        if (-not $SharePointUrl) { throw 'SharePointUrl is required when using -SharePoint.' }
        Test-RequiredModule -ModuleName PnP.PowerShell -InstallIfMissing:$InstallModules
        Connect-PnPOnline -Url $SharePointUrl -Interactive
        $script:M365ToolkitContext.SharePointUrl = $SharePointUrl
    }
    if ($Teams) {
        Test-RequiredModule -ModuleName MicrosoftTeams -InstallIfMissing:$InstallModules
        Connect-MicrosoftTeams | Out-Null
        $script:M365ToolkitContext.Teams = $true
    }
    if ($ActiveDirectory) {
        Test-RequiredModule -ModuleName ActiveDirectory -InstallIfMissing:$false
        $script:M365ToolkitContext.ActiveDirectory = $true
    }
    [pscustomobject]$script:M365ToolkitContext
}
r