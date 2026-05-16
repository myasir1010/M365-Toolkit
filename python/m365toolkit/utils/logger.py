"""
.SYNOPSIS
    Create Python logger.

.DESCRIPTION
    Provides a reusable logger for Python scripts.

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
import logging

def get_logger(name="m365toolkit"):
    logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
    return logging.getLogger(name)
r