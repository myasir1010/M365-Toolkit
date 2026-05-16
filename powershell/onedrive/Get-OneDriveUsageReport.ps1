<#
.SYNOPSIS
    Get OneDrive usage report.

.DESCRIPTION
    Exports OneDrive usage through Microsoft Graph reports API.

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
function Get-OneDriveUsageReport { [CmdletBinding()] param([ValidateSet('D7','D30','D90','D180')][string]$Period='D30',[string]$OutputPath='./reports/csv/onedrive-usage.csv') Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/reports/getOneDriveUsageAccountDetail(period='$Period')" -OutputFilePath $OutputPath; Get-Item $OutputPath }