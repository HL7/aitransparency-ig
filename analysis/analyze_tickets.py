#!/usr/bin/env python3
"""Analyze cached Jira tickets against IG content.

Loads tickets from data/tickets.json, parses the IG source, maps tickets
to IG content areas, computes statistics, and saves the analysis to
data/analysis.json.

Usage:
    python analyze_tickets.py
"""

import json
import logging
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

import yaml

from lib.ig_parser import parse_ig
from lib.ticket_mapper import compute_coverage, map_tickets_to_content

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


def load_config():
    """Load config.yaml."""
    config_path = Path(__file__).parent / "config.yaml"
    with open(config_path) as f:
        return yaml.safe_load(f)


def load_tickets(data_dir):
    """Load cached tickets from data/tickets.json."""
    cache_path = Path(data_dir) / "tickets.json"
    if not cache_path.exists():
        logger.error(
            "No cached tickets found at %s. Run fetch_tickets.py first.",
            cache_path,
        )
        sys.exit(1)

    with open(cache_path) as f:
        cache = json.load(f)

    logger.info(
        "Loaded %d tickets (fetched %s)",
        cache["metadata"]["total_count"],
        cache["metadata"]["fetched_at"],
    )
    return cache


def compute_stats(issues):
    """Compute summary statistics from issue data."""
    status_counts = Counter()
    type_counts = Counter()
    priority_counts = Counter()
    resolution_counts = Counter()
    dates = []

    for issue in issues:
        fields = issue.get("fields", {})
        status = fields.get("status", {}).get("name", "Unknown")
        issuetype = fields.get("issuetype", {}).get("name", "Unknown")
        priority = fields.get("priority", {})
        priority_name = priority.get("name", "Unknown") if priority else "Unknown"
        resolution = fields.get("resolution")
        resolution_name = resolution.get("name", "Unresolved") if resolution else "Unresolved"

        status_counts[status] += 1
        type_counts[issuetype] += 1
        priority_counts[priority_name] += 1
        resolution_counts[resolution_name] += 1

        created = fields.get("created", "")
        if created:
            dates.append(created[:10])  # YYYY-MM-DD

    dates.sort()

    return {
        "total": len(issues),
        "by_status": dict(status_counts.most_common()),
        "by_type": dict(type_counts.most_common()),
        "by_priority": dict(priority_counts.most_common()),
        "by_resolution": dict(resolution_counts.most_common()),
        "date_range": {
            "earliest": dates[0] if dates else None,
            "latest": dates[-1] if dates else None,
        },
    }


def main():
    config = load_config()
    script_dir = Path(__file__).parent
    data_dir = script_dir / config["output"]["data_dir"]

    # Load tickets.
    cache = load_tickets(data_dir)
    issues = cache["issues"]

    # Parse IG content.
    ig_root = (script_dir / config["ig"]["root"]).resolve()
    ig_content = parse_ig(
        ig_root,
        fsh_dir=config["ig"]["fsh_dir"],
        pagecontent_dir=config["ig"]["pagecontent_dir"],
        sushi_config=config["ig"]["sushi_config"],
    )
    logger.info(
        "Parsed IG: %d artifacts, %d pages",
        len(ig_content["artifacts"]),
        len(ig_content["pages"]),
    )

    # Map tickets to IG content.
    mappings = map_tickets_to_content(issues, ig_content)

    # Compute coverage.
    coverage = compute_coverage(mappings, ig_content)

    # Compute stats.
    stats = compute_stats(issues)

    # Build the full analysis.
    analysis = {
        "metadata": {
            "analyzed_at": datetime.now(timezone.utc).isoformat(),
            "ticket_source": cache["metadata"],
            "ig_title": ig_content["config"].get("title", ""),
            "ig_version": ig_content["config"].get("version", ""),
        },
        "stats": stats,
        "ig_content": {
            "config": ig_content["config"],
            "artifact_count": len(ig_content["artifacts"]),
            "artifacts": ig_content["artifacts"],
            "page_count": len(ig_content["pages"]),
            "pages": ig_content["pages"],
        },
        "mappings": mappings,
        "coverage": coverage,
    }

    # Save.
    output_path = data_dir / "analysis.json"
    with open(output_path, "w") as f:
        json.dump(analysis, f, indent=2)
    logger.info("Analysis saved to %s", output_path)

    # Print summary.
    print(f"\n{'='*50}")
    print(f"  Analysis Complete")
    print(f"{'='*50}")
    print(f"  Tickets:    {stats['total']}")
    print(f"  Artifacts:  {len(ig_content['artifacts'])}")
    print(f"  Pages:      {len(ig_content['pages'])}")
    print(f"  Coverage:   {coverage['coverage_ratio']:.0%}")
    if coverage["uncovered"]:
        print(f"\n  Uncovered IG areas:")
        for area in coverage["uncovered"]:
            print(f"    - {area}")
    print()


if __name__ == "__main__":
    main()
