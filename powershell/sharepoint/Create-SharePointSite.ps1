<#
.SYNOPSIS
    Create a SharePoint site.

.DESCRIPTION
    Creates a modern SharePoint team site.

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
function Create-SharePointSite { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$Title,[Parameter(Mandatory)][string]$Alias,[string]$Owner) if($PSCmdlet.ShouldProcess($Title,'Create SharePoint site')){ New-PnPSite -Type TeamSite -Title $Title -Alias $Alias -Owner $Owner } }