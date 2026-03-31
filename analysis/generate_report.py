#!/usr/bin/env python3
"""Generate a markdown report from the analysis data.

Reads data/analysis.json and produces a human-readable markdown report
saved to reports/ticket_analysis_YYYY-MM-DD.md.

Usage:
    python generate_report.py
"""

import json
import logging
import sys
from datetime import datetime, timezone
from pathlib import Path

import yaml

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


def load_analysis(data_dir):
    """Load analysis.json."""
    path = Path(data_dir) / "analysis.json"
    if not path.exists():
        logger.error(
            "No analysis found at %s. Run analyze_tickets.py first.", path
        )
        sys.exit(1)
    with open(path) as f:
        return json.load(f)


def generate_markdown(analysis):
    """Build the markdown report as a string."""
    meta = analysis["metadata"]
    stats = analysis["stats"]
    ig = analysis["ig_content"]
    mappings = analysis["mappings"]
    coverage = analysis["coverage"]

    lines = []

    def add(text=""):
        lines.append(text)

    # Title
    ig_title = meta.get("ig_title", "IG")
    add(f"# Jira Ticket Analysis: {ig_title}")
    add()
    add(f"**Generated:** {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}")
    add(f"**IG Version:** {meta.get('ig_version', 'N/A')}")
    add(f"**Tickets fetched:** {meta['ticket_source'].get('fetched_at', 'N/A')}")
    add(f"**JQL:** `{meta['ticket_source'].get('jql', 'N/A')}`")
    add()

    # Summary stats
    add("## Summary")
    add()
    add(f"| Metric | Count |")
    add(f"|--------|-------|")
    add(f"| Total tickets | {stats['total']} |")
    add(f"| IG artifacts | {ig['artifact_count']} |")
    add(f"| IG pages | {ig['page_count']} |")
    add(f"| Coverage | {coverage['coverage_ratio']:.0%} |")
    add()

    date_range = stats.get("date_range", {})
    if date_range.get("earliest"):
        add(f"**Date range:** {date_range['earliest']} to {date_range['latest']}")
        add()

    # Status breakdown
    add("## Tickets by Status")
    add()
    add("| Status | Count |")
    add("|--------|-------|")
    for status, count in stats.get("by_status", {}).items():
        add(f"| {status} | {count} |")
    add()

    # Type breakdown
    add("## Tickets by Type")
    add()
    add("| Type | Count |")
    add("|------|-------|")
    for issuetype, count in stats.get("by_type", {}).items():
        add(f"| {issuetype} | {count} |")
    add()

    # Priority breakdown
    add("## Tickets by Priority")
    add()
    add("| Priority | Count |")
    add("|----------|-------|")
    for priority, count in stats.get("by_priority", {}).items():
        add(f"| {priority} | {count} |")
    add()

    # Resolution breakdown
    add("## Tickets by Resolution")
    add()
    add("| Resolution | Count |")
    add("|------------|-------|")
    for resolution, count in stats.get("by_resolution", {}).items():
        add(f"| {resolution} | {count} |")
    add()

    # Ticket inventory
    add("## Ticket Inventory")
    add()
    add("| Key | Summary | Status | Type | Priority |")
    add("|-----|---------|--------|------|----------|")
    for mapping in mappings:
        key = mapping["key"]
        summary = mapping["summary"][:80]
        # Find the original ticket to get status/type/priority
        issue = _find_issue(analysis, key)
        if issue:
            fields = issue.get("fields", {})
            status = fields.get("status", {}).get("name", "")
            issuetype = fields.get("issuetype", {}).get("name", "")
            priority = fields.get("priority", {})
            priority_name = priority.get("name", "") if priority else ""
        else:
            status = issuetype = priority_name = ""

        jira_url = f"https://jira.hl7.org/browse/{key}"
        add(f"| [{key}]({jira_url}) | {summary} | {status} | {issuetype} | {priority_name} |")
    add()

    # IG content map
    add("## IG Content Map")
    add()
    add("### Artifacts")
    add()
    add("| Type | Name | Title | File |")
    add("|------|------|-------|------|")
    for artifact in ig.get("artifacts", []):
        add(f"| {artifact['type']} | {artifact['name']} | {artifact.get('title', '')} | {artifact['file']}:{artifact['line']} |")
    add()

    add("### Pages")
    add()
    for page in ig.get("pages", []):
        add(f"#### {page['file']}")
        for heading in page.get("headings", []):
            indent = "  " * (heading["level"] - 1)
            add(f"{indent}- {heading['text']} (line {heading['line']})")
        add()

    # Ticket-to-IG mapping
    add("## Ticket-to-IG Content Mapping")
    add()
    for mapping in mappings:
        key = mapping["key"]
        summary = mapping["summary"]
        matches = mapping.get("matches", [])

        add(f"### [{key}](https://jira.hl7.org/browse/{key}): {summary}")
        add()
        if matches:
            # Show top 5 matches
            add("| Score | Area | Matched Terms |")
            add("|-------|------|---------------|")
            for match in matches[:5]:
                terms = ", ".join(match.get("matched_terms", []))
                add(f"| {match['score']} | {match['area']} | {terms} |")
        else:
            add("*No IG content matches found.*")
        add()

    # Coverage gaps
    add("## Coverage Analysis")
    add()
    add(f"**Coverage:** {coverage['coverage_ratio']:.0%} of IG areas have at least one ticket reference.")
    add()

    if coverage.get("covered"):
        add("### Covered Areas")
        add()
        for area in coverage["covered"]:
            add(f"- {area}")
        add()

    if coverage.get("uncovered"):
        add("### Uncovered Areas (no ticket matches)")
        add()
        for area in coverage["uncovered"]:
            add(f"- {area}")
        add()

    add("---")
    add("*Report generated by analysis tooling. See analysis/README.md for details.*")

    return "\n".join(lines)


def _find_issue(analysis, key):
    """Find the original issue dict by key from the ticket source metadata."""
    # Issues are embedded in the analysis via the mappings, but the original
    # issue data lives in tickets.json. We load it separately if needed.
    # For now, try to get it from the analysis metadata.
    # Since we don't store full issues in analysis.json, load from tickets.json.
    data_dir = Path(__file__).parent / "data"
    tickets_path = data_dir / "tickets.json"
    if not hasattr(_find_issue, "_cache"):
        if tickets_path.exists():
            with open(tickets_path) as f:
                cache = json.load(f)
            _find_issue._cache = {
                issue["key"]: issue for issue in cache.get("issues", [])
            }
        else:
            _find_issue._cache = {}
    return _find_issue._cache.get(key)


def main():
    config = load_config()
    script_dir = Path(__file__).parent
    data_dir = script_dir / config["output"]["data_dir"]
    reports_dir = script_dir / config["output"]["reports_dir"]

    analysis = load_analysis(data_dir)

    report_md = generate_markdown(analysis)

    # Save with dated filename.
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    report_path = reports_dir / f"ticket_analysis_{today}.md"
    reports_dir.mkdir(parents=True, exist_ok=True)
    with open(report_path, "w") as f:
        f.write(report_md)

    logger.info("Report saved to %s", report_path)
    print(f"\nReport written to: {report_path}")
    print(f"Total lines: {len(report_md.splitlines())}")


if __name__ == "__main__":
    main()
