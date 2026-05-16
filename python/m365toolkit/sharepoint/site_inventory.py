"""
.SYNOPSIS
    Analyze SharePoint site inventory.

.DESCRIPTION
    Provides helpers for SharePoint site inventory exports.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
def find_external_sharing_sites(sites):
    return [site for site in sites if site.get("SharingCapability") not in (None, "Disabled")]