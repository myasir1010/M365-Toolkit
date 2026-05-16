<#
.SYNOPSIS
    Export Conditional Access policies.

.DESCRIPTION
    Exports Conditional Access policies using Microsoft Graph.

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
function Get-ConditionalAccessPolicies { [CmdletBinding()] param([string]$OutputPath='./reports/json/conditional-access-policies.json') $Data=Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies'; $Data | ConvertTo-Json -Depth 20 | Set-Content $OutputPath -Encoding UTF8; Get-Item $OutputPath }