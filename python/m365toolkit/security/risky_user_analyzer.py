"""
.SYNOPSIS
    Analyze risky users.

.DESCRIPTION
    Groups risky users by risk level.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
r
def group_by_risk_level(users):
    result = {}
    for user in users:
        result.setdefault(user.get("riskLevel", "unknown"), []).append(user)
    return result
r