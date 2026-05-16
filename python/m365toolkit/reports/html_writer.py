"""
.SYNOPSIS
    Write HTML reports.

.DESCRIPTION
    Writes a simple HTML table report.

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
from pathlib import Path
import html

def write_html_table(path, title, rows):
    rows = list(rows)
    headers = list(rows[0].keys()) if rows else []
    thead = ''.join(f'<th>{html.escape(h)}</th>' for h in headers)
    body = ''.join('<tr>' + ''.join(f'<td>{html.escape(str(row.get(h, "")))}</td>' for h in headers) + '</tr>' for row in rows)
    doc = f"<html><head><title>{html.escape(title)}</title></head><body><h1>{html.escape(title)}</h1><table border='1'><thead><tr>{thead}</tr></thead><tbody>{body}</tbody></table></body></html>"
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_text(doc, encoding='utf-8')
    return path
r