<#
.SYNOPSIS
    Connect to SharePoint Online.

.DESCRIPTION
    Connects to SharePoint Online using PnP PowerShell.

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
function Connect-SharePointToolkit { [CmdletBinding()] param([Parameter(Mandatory)][string]$Url,[switch]$InstallModules) Test-RequiredModule -ModuleName PnP.PowerShell -InstallIfMissing:$InstallModules; Connect-PnPOnline -Url $Url -Interactive }