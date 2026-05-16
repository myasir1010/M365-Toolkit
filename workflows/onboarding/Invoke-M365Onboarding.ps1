<#
.SYNOPSIS
    Run onboarding workflow.

.DESCRIPTION
    Runs the onboarding workflow for the M365 Toolkit.

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
function Invoke-M365Onboarding { [CmdletBinding()] param([Parameter(Mandatory)][string]$CsvPath) Import-Csv $CsvPath | ForEach-Object { New-M365User -UserPrincipalName $_.UserPrincipalName -DisplayName $_.DisplayName -GivenName $_.GivenName -Surname $_.Surname -Password 'ChangeMe-12345!' -UsageLocation $_.UsageLocation } }