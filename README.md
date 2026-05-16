# M365 Toolkit

A modular Microsoft 365, Entra ID, Exchange Online, SharePoint Online, Active Directory, and Microsoft Graph automation toolkit built with PowerShell and Python.

## What this repository demonstrates

- Microsoft Graph PowerShell automation
- Exchange Online PowerShell automation
- PnP PowerShell automation for SharePoint and OneDrive
- Active Directory administration scripts
- Python Microsoft Graph REST API utilities
- Tenant inventory, security audit, onboarding, offboarding, and license optimization workflows
- Clean portfolio-grade repository structure

## Quick start

```powershell
Import-Module .\powershell\M365Toolkit.psd1 -Force
Connect-M365Toolkit -Scopes "User.Read.All","Group.ReadWrite.All","Directory.ReadWrite.All","AuditLog.Read.All"
Export-M365Users -OutputPath .\reports\csv\users.csv
```

```bash
cd python
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python scripts/export_users.py --config ../config/appsettings.sample.json --output ../reports/csv/users.csv
```

## Important

This toolkit is safe-by-default where possible. Destructive actions support `-WhatIf` or confirmation patterns when implemented. Test in a development tenant before production use.

## Author

Muhammad Yasir
r