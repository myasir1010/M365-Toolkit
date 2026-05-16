"""
.SYNOPSIS
    Analyze MFA status.

.DESCRIPTION
    Finds users without MFA registration.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
def users_without_mfa(rows):
    return [row for row in rows if str(row.get("MfaRegistered", "False")).lower() == "false" and str(row.get("AccountEnabled", "True")).lower() == "true"]