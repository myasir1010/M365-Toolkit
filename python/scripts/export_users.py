"""
.SYNOPSIS
    Export Microsoft 365 users.

.DESCRIPTION
    Export Microsoft 365 users. Uses Microsoft Graph REST API.

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
import argparse
from m365toolkit.auth.graph_auth import GraphAuthenticator
from m365toolkit.graph.graph_client import GraphClient
from m365toolkit.reports.csv_writer import write_csv
from m365toolkit.utils.config_loader import load_config

ENDPOINT = "/users"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="../config/appsettings.sample.json")
    parser.add_argument("--output", default="../reports/csv/users.csv")
    args = parser.parse_args()
    cfg = load_config(args.config)
    auth = GraphAuthenticator.from_environment() if cfg.get("client_secret") == "USE_ENVIRONMENT_VARIABLE_IN_PRODUCTION" else GraphAuthenticator(__import__('m365toolkit.auth.graph_auth', fromlist=['GraphAuthConfig']).GraphAuthConfig(cfg['tenant_id'], cfg['client_id'], cfg['client_secret']))
    client = GraphClient(auth.get_token(), cfg.get("graph_base_url", "https://graph.microsoft.com/v1.0"))
    rows = list(client.paged(ENDPOINT))
    write_csv(args.output, rows)
    print(f"Exported {len(rows)} rows to {args.output}")

if __name__ == "__main__":
    main()
r