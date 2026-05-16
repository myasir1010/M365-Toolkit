"""
.SYNOPSIS
    Microsoft Graph REST API client.

.DESCRIPTION
    HTTP client with pagination, retry support, and JSON helpers.

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
from __future__ import annotations
import time
from typing import Any, Dict, Iterable, Optional
import requests

class GraphClient:
    def __init__(self, token: str, base_url: str = "https://graph.microsoft.com/v1.0", timeout: int = 60):
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update({"Authorization": f"Bearer {token}", "Content-Type": "application/json"})

    def request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        url = endpoint if endpoint.startswith("http") else f"{self.base_url}/{endpoint.lstrip('/')}"
        for attempt in range(5):
            response = self.session.request(method, url, timeout=self.timeout, **kwargs)
            if response.status_code in (429, 500, 502, 503, 504):
                time.sleep(int(response.headers.get("Retry-After", 2 ** attempt)))
                continue
            if not response.ok:
                raise RuntimeError(f"Graph request failed {response.status_code}: {response.text}")
            if response.text:
                return response.json()
            return {}
        raise RuntimeError(f"Graph request failed after retries: {method} {url}")

    def get(self, endpoint: str, **kwargs) -> Dict[str, Any]:
        return self.request("GET", endpoint, **kwargs)

    def post(self, endpoint: str, payload: Dict[str, Any]) -> Dict[str, Any]:
        return self.request("POST", endpoint, json=payload)

    def patch(self, endpoint: str, payload: Dict[str, Any]) -> Dict[str, Any]:
        return self.request("PATCH", endpoint, json=payload)

    def paged(self, endpoint: str) -> Iterable[Dict[str, Any]]:
        data = self.get(endpoint)
        while True:
            for item in data.get("value", []):
                yield item
            next_link = data.get("@odata.nextLink")
            if not next_link:
                break
            data = self.get(next_link)
r