"""
.SYNOPSIS
    Store simple token cache metadata.

.DESCRIPTION
    Provides a small placeholder for token cache extension.

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
from dataclasses import dataclass
from datetime import datetime

@dataclass
class TokenCacheInfo:
    created_at: datetime
    expires_in: int
    token_type: str = "Bearer"
r