<#
.SYNOPSIS
    Connect to Exchange Online.

.DESCRIPTION
    Connects to Exchange Online using the ExchangeOnlineManagement PowerShell module.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.PARAMETER UserPrincipalName
    Optional administrator user principal name used for interactive sign-in.

.PARAMETER InstallModules
    Installs the required ExchangeOnlineManagement module if it is missing.

.EXAMPLE
    Connect-ExchangeToolkit

.EXAMPLE
    Connect-ExchangeToolkit -UserPrincipalName "admin@contoso.com"

.EXAMPLE
    Connect-ExchangeToolkit -UserPrincipalName "admin@contoso.com" -InstallModules

.NOTES
    Run PowerShell as Administrator when module installation is required.
    Requires Exchange administrator permissions.
    Requires the ExchangeOnlineManagement PowerShell module.
#>

function Connect-ExchangeToolkit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $false)]
        [switch]$InstallModules
    )

    begin {
        $ErrorActionPreference = "Stop"

        if (Get-Command -Name Test-RequiredModule -CommandType Function -ErrorAction SilentlyContinue) {
            Test-RequiredModule `
                -ModuleName "ExchangeOnlineManagement" `
                -InstallIfMissing:$InstallModules
        }
        else {
            if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
                if ($InstallModules) {
                    Install-Module `
                        -Name ExchangeOnlineManagement `
                        -Scope CurrentUser `
                        -Force `
                        -AllowClobber `
                        -ErrorAction Stop
                }
                else {
                    throw "The ExchangeOnlineManagement module is not installed. Run with -InstallModules or install it manually."
                }
            }

            Import-Module ExchangeOnlineManagement -ErrorAction Stop
        }
    }

    process {
        try {
            $connectionParameters = @{
                ShowBanner  = $false
                ErrorAction = "Stop"
            }

            if ($UserPrincipalName) {
                $connectionParameters.UserPrincipalName = $UserPrincipalName
            }

            Connect-ExchangeOnline @connectionParameters

            Write-Host "Connected to Exchange Online successfully." -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to connect to Exchange Online. $($_.Exception.Message)"
        }
    }
}