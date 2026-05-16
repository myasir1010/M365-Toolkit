"""
.SYNOPSIS
    Retry helper.

.DESCRIPTION
    Provides a simple retry wrapper.

.AUTHOR
    Muhammad Yasir

.CREATED
    2026-05-15

.COPYRIGHT
    Copyright (c) 2026 Muhammad Yasir. All rights reserved.

.NOTES
    Configure Azure app registration details in config/appsettings.sample.json or environment variables before use.
"""
import time

def retry(func, attempts=3, delay=1):
    last_error = None
    for attempt in range(attempts):
        try:
            return func()
        except Exception as exc:
            last_error = exc
            time.sleep(delay * (2 ** attempt))
    raise last_error