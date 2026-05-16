"""
.SYNOPSIS
    Calculate tenant security score.

.DESCRIPTION
    Calculates a simple portfolio-friendly tenant security score.

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
def calculate_security_score(users_without_mfa_count=0, risky_users_count=0, privileged_users_count=0, stale_devices_count=0):
    score = 100
    score -= min(users_without_mfa_count * 2, 30)
    score -= min(risky_users_count * 5, 25)
    score -= min(privileged_users_count, 15)
    score -= min(stale_devices_count, 20)
    return max(score, 0)
r