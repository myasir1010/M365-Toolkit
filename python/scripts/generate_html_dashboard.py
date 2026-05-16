"""
.SYNOPSIS
    Generate HTML dashboard.

.DESCRIPTION
    Converts a CSV report into an HTML dashboard.

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
import argparse, csv
from m365toolkit.reports.html_writer import write_html_table

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", default="../reports/html/dashboard.html")
    parser.add_argument("--title", default="M365 Toolkit Dashboard")
    args = parser.parse_args()
    with open(args.input, newline='', encoding='utf-8') as f:
        rows = list(csv.DictReader(f))
    write_html_table(args.output, args.title, rows)
    print(f"Dashboard written to {args.output}")
r