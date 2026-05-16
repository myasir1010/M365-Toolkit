"""
.SYNOPSIS
    Authenticate to Microsoft Graph.

.DESCRIPTION
    Provides client credential authentication using MSAL.

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
import os
from dataclasses import dataclass
import msal

@dataclass
class GraphAuthConfig:
    tenant_id: str
    client_id: str
    client_secret: str
    scope: str = "https://graph.microsoft.com/.default"

class GraphAuthenticator:
    def __init__(self, config: GraphAuthConfig):
        self.config = config
        self.authority = f"https://login.microsoftonline.com/{config.tenant_id}"

    @classmethod
    def from_environment(cls):
        return cls(GraphAuthConfig(
            tenant_id=os.environ["M365_TENANT_ID"],
            client_id=os.environ["M365_CLIENT_ID"],
            client_secret=os.environ["M365_CLIENT_SECRET"],
        ))

    def get_token(self) -> str:
        app = msal.ConfidentialClientApplication(
            client_id=self.config.client_id,
            client_credential=self.config.client_secret,
            authority=self.authority,
        )
        result = app.acquire_token_for_client(scopes=[self.config.scope])
        if "access_token" not in result:
            raise RuntimeError(f"Failed to acquire token: {result}")
        return result["access_token"]
r