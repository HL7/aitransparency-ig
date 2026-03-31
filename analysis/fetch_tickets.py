#!/usr/bin/env python3
"""Fetch Jira tickets for the IG specification and cache them locally.

Usage:
    python fetch_tickets.py              # fetch if no cache exists
    python fetch_tickets.py --force      # re-fetch even if cache exists
    python fetch_tickets.py --spec NAME  # override specification name
"""

import argparse
import json
import logging
import os
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

import yaml
from dotenv import load_dotenv

from lib.jira_client import JiraClient, JiraError

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


def load_config():
    """Load config.yaml from the same directory as this script."""
    config_path = Path(__file__).parent / "config.yaml"
    with open(config_path) as f:
        return yaml.safe_load(f)


def get_pat():
    """Resolve the Jira PAT from environment or .env file.

    Checks (in order):
      1. HL7_JIRA environment variable
      2. JIRA_PAT from .env file / environment
    """
    # Load .env if it exists (does not override existing env vars)
    env_path = Path(__file__).parent / ".env"
    if env_path.exists():
        load_dotenv(env_path)

    pat = os.environ.get("HL7_JIRA") or os.environ.get("JIRA_PAT")
    if not pat:
        logger.error(
            "No Jira PAT found. Set the HL7_JIRA environment variable "
            "or create analysis/.env with JIRA_PAT=<your-token>."
        )
        sys.exit(1)
    return pat


def build_jql(config, spec_override=None):
    """Build the JQL query string from config, substituting the spec name."""
    spec = spec_override or config["jira"]["specification"]
    jql = config["jira"]["jql_template"].format(specification=spec)
    logger.info("JQL: %s", jql)
    return jql


def save_cache(issues, jql, output_path):
    """Save issues to a JSON cache file with metadata."""
    cache = {
        "metadata": {
            "fetched_at": datetime.now(timezone.utc).isoformat(),
            "jql": jql,
            "total_count": len(issues),
        },
        "issues": issues,
    }
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(cache, f, indent=2)
    logger.info("Cached %d issues to %s", len(issues), output_path)


def print_summary(issues):
    """Print a breakdown of fetched issues by status and type."""
    status_counts = Counter()
    type_counts = Counter()
    for issue in issues:
        fields = issue.get("fields", {})
        status = fields.get("status", {}).get("name", "Unknown")
        issuetype = fields.get("issuetype", {}).get("name", "Unknown")
        status_counts[status] += 1
        type_counts[issuetype] += 1

    print(f"\n{'='*50}")
    print(f"  Fetched {len(issues)} tickets")
    print(f"{'='*50}")

    print("\n  By Status:")
    for status, count in status_counts.most_common():
        print(f"    {status:.<30} {count}")

    print("\n  By Type:")
    for issuetype, count in type_counts.most_common():
        print(f"    {issuetype:.<30} {count}")

    print()


def main():
    parser = argparse.ArgumentParser(description="Fetch Jira tickets for the IG")
    parser.add_argument(
        "--force", action="store_true", help="Re-fetch even if cache exists"
    )
    parser.add_argument(
        "--spec", type=str, default=None, help="Override specification name"
    )
    args = parser.parse_args()

    config = load_config()
    data_dir = Path(__file__).parent / config["output"]["data_dir"]
    cache_path = data_dir / "tickets.json"

    # Check cache
    if cache_path.exists() and not args.force:
        logger.info("Cache exists at %s. Use --force to re-fetch.", cache_path)
        with open(cache_path) as f:
            cached = json.load(f)
        print_summary(cached["issues"])
        return

    # Fetch
    pat = get_pat()
    client = JiraClient(
        base_url=config["jira"]["base_url"],
        pat=pat,
        page_size=config["jira"]["page_size"],
    )

    # Discover the Specification custom field so we can include it in results
    try:
        spec_field_id = client.find_specification_field()
        logger.info("Specification field id: %s", spec_field_id)
    except JiraError as exc:
        logger.warning("Could not discover Specification field: %s", exc)
        spec_field_id = None

    jql = build_jql(config, spec_override=args.spec)

    # Build field list — include the Specification custom field if found
    fields = [
        "summary", "status", "issuetype", "priority",
        "resolution", "created", "updated", "description",
        "labels", "comment",
    ]
    if spec_field_id:
        fields.append(spec_field_id)

    try:
        issues = client.search_issues(jql, fields=fields)
    except JiraError as exc:
        logger.error("Failed to fetch tickets: %s", exc)
        sys.exit(1)

    save_cache(issues, jql, cache_path)
    print_summary(issues)


if __name__ == "__main__":
    main()
