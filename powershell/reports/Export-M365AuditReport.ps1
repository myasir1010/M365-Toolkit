<#
.SYNOPSIS
    Export Microsoft 365 audit report.

.DESCRIPTION
    Exports directory audit logs using Microsoft Graph.

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
function Export-M365AuditReport { [CmdletBinding()] param([string]$OutputPath='./reports/csv/audit-logs.csv') $Data=Get-MgAuditLogDirectoryAudit -All | Select-Object ActivityDateTime,ActivityDisplayName,Category,Result,LoggedByService; $Data|Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }<#
.SYNOPSIS
    Export Microsoft 365 audit report.

.DESCRIPTION
    Exports Microsoft Entra ID directory audit logs using Microsoft Graph
    and saves the result to a CSV file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the exported CSV file will be saved.

.PARAMETER Top
    Optional maximum number of audit records to export.
    If omitted, all available records returned by Microsoft Graph are exported.

.EXAMPLE
    Export-M365AuditReport

.EXAMPLE
    Export-M365AuditReport -OutputPath ".\reports\csv\audit-logs.csv"

.EXAMPLE
    Export-M365AuditReport -OutputPath ".\reports\csv\audit-logs.csv" -Top 500

.NOTES
    Run PowerShell as Administrator when local or Microsoft Graph permissions are required.
    Configure Microsoft Graph permissions before running tenant-level automation.

    Required Microsoft Graph permission:
    - AuditLog.Read.All
#>

function Export-M365AuditReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\csv\audit-logs.csv",

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 999999)]
        [int]$Top
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Reports)) {
            throw "The Microsoft.Graph.Reports module is not installed. Install Microsoft Graph PowerShell SDK and try again."
        }

        Import-Module Microsoft.Graph.Reports -ErrorAction Stop

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
    }

    process {
        try {
            $auditLogs = if ($PSBoundParameters.ContainsKey("Top")) {
                Get-MgAuditLogDirectoryAudit `
                    -Top $Top `
                    -ErrorAction Stop
            }
            else {
                Get-MgAuditLogDirectoryAudit `
                    -All `
                    -ErrorAction Stop
            }

            $auditLogs |
                Select-Object `
                    Id,
                    ActivityDateTime,
                    ActivityDisplayName,
                    Category,
                    Result,
                    ResultReason,
                    LoggedByService,
                    OperationType,
                    InitiatedBy,
                    TargetResources |
                Export-Csv `
                    -Path $OutputPath `
                    -NoTypeInformation `
                    -Encoding UTF8

            Write-Host "Microsoft 365 audit report exported successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to export Microsoft 365 audit report. $($_.Exception.Message)"
        }
    }
}