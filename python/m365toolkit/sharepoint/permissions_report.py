"""
.SYNOPSIS
    Analyze SharePoint permissions.

.DESCRIPTION
    Provides helpers for SharePoint permissions reports.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
def group_permissions_by_site(rows):
    result = {}
    for row in rows:
        result.setdefault(row.get("SiteUrl", "Unknown"), []).append(row)
    return result