"""
.SYNOPSIS
    Load JSON config.

.DESCRIPTION
    Loads JSON configuration files.

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
import json
from pathlib import Path

def load_config(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))
r