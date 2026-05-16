"""
.SYNOPSIS
    Generate security score.

.DESCRIPTION
    Calculates a simple security score from provided counts.

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
from m365toolkit.security.score_calculator import calculate_security_score

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--users-without-mfa", type=int, default=0)
    parser.add_argument("--risky-users", type=int, default=0)
    parser.add_argument("--privileged-users", type=int, default=0)
    parser.add_argument("--stale-devices", type=int, default=0)
    args = parser.parse_args()
    print(calculate_security_score(args.users_without_mfa, args.risky_users, args.privileged_users, args.stale_devices))
r