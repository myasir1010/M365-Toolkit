"""
.SYNOPSIS
    Parse mailbox reports.

.DESCRIPTION
    Parses Exchange mailbox CSV exports for reporting.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
import csv
from pathlib import Path

def read_mailbox_report(path: str):
    with Path(path).open(newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))