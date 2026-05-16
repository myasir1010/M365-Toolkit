"""
.SYNOPSIS
    Graph reports helpers.

.DESCRIPTION
    Provides helper functions for Microsoft Graph reports.

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
from .graph_client import GraphClient

def list_items(client: GraphClient):
    return list(client.paged("/reports"))
r