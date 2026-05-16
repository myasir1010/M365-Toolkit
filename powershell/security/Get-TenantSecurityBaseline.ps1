<#
.SYNOPSIS
    Generate tenant security baseline.

.DESCRIPTION
    Creates a high-level Microsoft 365 tenant security baseline report from
    MFA registration status, privileged role assignments, risky users, inactive
    devices, and mailbox forwarding checks where the related toolkit functions
    are available.

    The result is exported to a JSON file.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER OutputPath
    The path where the tenant security baseline JSON report will be saved.

.PARAMETER WorkingDirectory
    The temporary working directory used for intermediate CSV reports.

.EXAMPLE
    Get-TenantSecurityBaseline

.EXAMPLE
    Get-TenantSecurityBaseline `
        -OutputPath ".\reports\json\tenant-security-baseline.json"

.EXAMPLE
    Get-TenantSecurityBaseline `
        -OutputPath ".\reports\json\tenant-security-baseline.json" `
        -WorkingDirectory ".\reports\csv"

.NOTES
    Run PowerShell as Administrator when local or Microsoft 365 permissions are required.
    Configure Microsoft Graph, Exchange Online, and SharePoint permissions before running tenant-level automation.

    This function uses the following functions when available:
    - Get-MFAStatusReport
    - Find-UsersWithoutMFA
    - Export-PrivilegedUsers
    - Export-RiskyUsers
    - Get-InactiveDevices
    - Search-MailboxForwardingRules
#>

function Get-TenantSecurityBaseline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = ".\reports\json\tenant-security-baseline.json",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkingDirectory = ".\reports\csv"
    )

    begin {
        $ErrorActionPreference = "Stop"

        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $outputDirectory `
                -Force | Out-Null
        }

        if (-not (Test-Path -Path $WorkingDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $WorkingDirectory `
                -Force | Out-Null
        }

        function Get-ReportCount {
            param(
                [Parameter(Mandatory = $true)]
                [string]$Path
            )

            if (-not (Test-Path -Path $Path)) {
                return 0
            }

            $data = Import-Csv -Path $Path

            if (-not $data) {
                return 0
            }

            return @($data).Count
        }

        function Test-ToolkitFunction {
            param(
                [Parameter(Mandatory = $true)]
                [string]$Name
            )

            return [bool](Get-Command -Name $Name -CommandType Function -ErrorAction SilentlyContinue)
        }
    }

    process {
        try {
            Write-Host "Generating tenant security baseline..." -ForegroundColor Cyan

            $mfaStatusPath = Join-Path -Path $WorkingDirectory -ChildPath "baseline-mfa-status.csv"
            $usersWithoutMfaPath = Join-Path -Path $WorkingDirectory -ChildPath "baseline-users-without-mfa.csv"
            $privilegedUsersPath = Join-Path -Path $WorkingDirectory -ChildPath "baseline-privileged-users.csv"
            $riskyUsersPath = Join-Path -Path $WorkingDirectory -ChildPath "baseline-risky-users.csv"
            $inactiveDevicesPath = Join-Path -Path $WorkingDirectory -ChildPath "baseline-inactive-devices.csv"
            $mailboxForwardingPath = Join-Path -Path $WorkingDirectory -ChildPath "baseline-mailbox-forwarding.csv"

            $checks = [ordered]@{}

            if (Test-ToolkitFunction -Name "Get-MFAStatusReport") {
                Get-MFAStatusReport -OutputPath $mfaStatusPath | Out-Null
                $mfaUsers = Import-Csv -Path $mfaStatusPath

                $checks.MFAStatus = [ordered]@{
                    Status               = "Completed"
                    TotalUsers           = @($mfaUsers).Count
                    MFARegisteredUsers   = @($mfaUsers | Where-Object { $_.MfaRegistered -eq "True" }).Count
                    MFANotRegisteredUsers = @($mfaUsers | Where-Object { $_.MfaRegistered -eq "False" }).Count
                    ReportPath           = $mfaStatusPath
                }
            }
            else {
                $checks.MFAStatus = [ordered]@{
                    Status = "Skipped"
                    Reason = "Get-MFAStatusReport function is not available."
                }
            }

            if (Test-ToolkitFunction -Name "Find-UsersWithoutMFA") {
                Find-UsersWithoutMFA -OutputPath $usersWithoutMfaPath | Out-Null

                $checks.UsersWithoutMFA = [ordered]@{
                    Status     = "Completed"
                    Count      = Get-ReportCount -Path $usersWithoutMfaPath
                    ReportPath = $usersWithoutMfaPath
                }
            }
            else {
                $checks.UsersWithoutMFA = [ordered]@{
                    Status = "Skipped"
                    Reason = "Find-UsersWithoutMFA function is not available."
                }
            }

            if (Test-ToolkitFunction -Name "Export-PrivilegedUsers") {
                Export-PrivilegedUsers -OutputPath $privilegedUsersPath | Out-Null

                $checks.PrivilegedAssignments = [ordered]@{
                    Status     = "Completed"
                    Count      = Get-ReportCount -Path $privilegedUsersPath
                    ReportPath = $privilegedUsersPath
                }
            }
            else {
                $checks.PrivilegedAssignments = [ordered]@{
                    Status = "Skipped"
                    Reason = "Export-PrivilegedUsers function is not available."
                }
            }

            if (Test-ToolkitFunction -Name "Export-RiskyUsers") {
                Export-RiskyUsers -OutputPath $riskyUsersPath | Out-Null

                $checks.RiskyUsers = [ordered]@{
                    Status     = "Completed"
                    Count      = Get-ReportCount -Path $riskyUsersPath
                    ReportPath = $riskyUsersPath
                }
            }
            else {
                $checks.RiskyUsers = [ordered]@{
                    Status = "Skipped"
                    Reason = "Export-RiskyUsers function is not available."
                }
            }

            if (Test-ToolkitFunction -Name "Get-InactiveDevices") {
                Get-InactiveDevices `
                    -InactiveDays 90 `
                    -OutputPath $inactiveDevicesPath | Out-Null

                $checks.InactiveDevices = [ordered]@{
                    Status       = "Completed"
                    InactiveDays = 90
                    Count        = Get-ReportCount -Path $inactiveDevicesPath
                    ReportPath   = $inactiveDevicesPath
                }
            }
            else {
                $checks.InactiveDevices = [ordered]@{
                    Status = "Skipped"
                    Reason = "Get-InactiveDevices function is not available."
                }
            }

            if (Test-ToolkitFunction -Name "Search-MailboxForwardingRules") {
                Search-MailboxForwardingRules -OutputPath $mailboxForwardingPath | Out-Null

                $checks.MailboxForwarding = [ordered]@{
                    Status     = "Completed"
                    Count      = Get-ReportCount -Path $mailboxForwardingPath
                    ReportPath = $mailboxForwardingPath
                }
            }
            else {
                $checks.MailboxForwarding = [ordered]@{
                    Status = "Skipped"
                    Reason = "Search-MailboxForwardingRules function is not available."
                }
            }

            $score = 100

            if ($checks.UsersWithoutMFA.Status -eq "Completed") {
                $score -= [Math]::Min($checks.UsersWithoutMFA.Count * 2, 30)
            }

            if ($checks.PrivilegedAssignments.Status -eq "Completed") {
                $score -= [Math]::Min($checks.PrivilegedAssignments.Count, 15)
            }

            if ($checks.RiskyUsers.Status -eq "Completed") {
                $score -= [Math]::Min($checks.RiskyUsers.Count * 5, 25)
            }

            if ($checks.InactiveDevices.Status -eq "Completed") {
                $score -= [Math]::Min($checks.InactiveDevices.Count, 15)
            }

            if ($checks.MailboxForwarding.Status -eq "Completed") {
                $score -= [Math]::Min($checks.MailboxForwarding.Count * 3, 15)
            }

            if ($score -lt 0) {
                $score = 0
            }

            $riskLevel = switch ($score) {
                { $_ -ge 85 } { "Low"; break }
                { $_ -ge 70 } { "Medium"; break }
                { $_ -ge 50 } { "High"; break }
                default { "Critical" }
            }

            $baseline = [ordered]@{
                GeneratedAt = Get-Date
                Score       = $score
                RiskLevel   = $riskLevel
                Checks      = $checks
            }

            $baseline |
                ConvertTo-Json -Depth 20 |
                Set-Content `
                    -Path $OutputPath `
                    -Encoding UTF8

            Write-Host "Tenant security baseline generated successfully: $OutputPath" -ForegroundColor Green

            Get-Item -Path $OutputPath
        }
        catch {
            Write-Error "Failed to generate tenant security baseline. $($_.Exception.Message)"
        }
    }
}