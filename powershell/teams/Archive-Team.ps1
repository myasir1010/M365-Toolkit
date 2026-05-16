<#
.SYNOPSIS
    Archive a Microsoft Team.

.DESCRIPTION
    Archives a Team using Microsoft Teams PowerShell.

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
function Archive-TeamToolkit { [CmdletBinding(SupportsShouldProcess)] param([Parameter(Mandatory)][string]$GroupId) if($PSCmdlet.ShouldProcess($GroupId,'Archive Team')){ Set-TeamArchivedState -GroupId $GroupId -Archived:$true } }