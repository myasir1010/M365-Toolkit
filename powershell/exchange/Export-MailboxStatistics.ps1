<#
.SYNOPSIS
    Export mailbox statistics.

.DESCRIPTION
    Exports mailbox size and item count statistics.

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
function Export-MailboxStatistics { [CmdletBinding()] param([string]$OutputPath='./reports/csv/mailbox-statistics.csv') $Data=Get-EXOMailbox -ResultSize Unlimited | ForEach-Object { Get-EXOMailboxStatistics -Identity $_.UserPrincipalName | Select-Object DisplayName,ItemCount,TotalItemSize,LastLogonTime }; $Data | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8; Get-Item $OutputPath }