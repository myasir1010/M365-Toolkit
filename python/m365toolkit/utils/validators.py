"""
.SYNOPSIS
    Validation helpers.

.DESCRIPTION
    Provides simple input validation.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
def require(value, name):
    if value in (None, ""):
        raise ValueError(f"{name} is required")
    return value