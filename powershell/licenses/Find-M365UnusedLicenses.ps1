<#
.SYNOPSIS
    Find unused Microsoft 365 licenses.

.DESCRIPTION
    Shows SKU capacity, consumed, and available units.

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
function Find-M365UnusedLicenses { [CmdletBinding()] param()
    Get-M365LicenseOverview | Where-Object { $_.Available -gt 0 } | Sort-Object Available -Descending
}
r