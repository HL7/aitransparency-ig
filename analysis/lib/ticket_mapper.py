"""Map Jira tickets to IG content areas via keyword matching.

Takes parsed ticket data and parsed IG content, then scores each ticket
against IG artifacts and pages to find likely content areas.
"""

import re
from collections import defaultdict


# FHIR-specific terms that get a scoring boost when matched.
FHIR_BOOST_TERMS = {
    "provenance", "device", "documentreference", "bundle", "patient",
    "extension", "profile", "codesystem", "valueset", "security",
    "label", "tag", "meta", "binary", "observation",
    "model card", "modelcard", "model-card",
    "ai", "artificial intelligence", "transparency",
}

# Words to ignore when extracting keywords.
STOP_WORDS = {
    "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for",
    "of", "with", "by", "from", "is", "are", "was", "were", "be", "been",
    "has", "have", "had", "do", "does", "did", "will", "would", "could",
    "should", "may", "might", "can", "shall", "not", "no", "this", "that",
    "it", "its", "as", "if", "so", "than", "when", "where", "which", "who",
    "how", "what", "all", "each", "every", "any", "some", "into", "about",
    "up", "out", "then", "more", "also", "very", "just", "only", "own",
    "same", "other", "new", "need", "needs", "use", "used", "using",
    "fhir", "hl7", "ig", "spec", "specification",
}

# Split on non-alphanumeric characters.
TOKEN_PATTERN = re.compile(r"[a-zA-Z][a-zA-Z0-9-]*")


def map_tickets_to_content(tickets, ig_content):
    """Map each ticket to IG content areas.

    Args:
        tickets: List of Jira issue dicts (from the API).
        ig_content: Parsed IG dict from ig_parser.parse_ig().

    Returns:
        List of dicts, one per ticket, with keys:
          key, summary, matches (list of {area, type, score, detail})
    """
    # Build a searchable index of IG content.
    ig_index = _build_ig_index(ig_content)

    mappings = []
    for ticket in tickets:
        fields = ticket.get("fields", {})
        key = ticket.get("key", "UNKNOWN")
        summary = fields.get("summary", "")
        description = fields.get("description", "") or ""

        ticket_keywords = _extract_keywords(f"{summary} {description}")
        matches = _find_matches(ticket_keywords, ig_index)

        mappings.append({
            "key": key,
            "summary": summary,
            "matches": matches,
        })

    return mappings


def _build_ig_index(ig_content):
    """Build a list of searchable IG content entries.

    Each entry has: area (display name), type, keywords, detail.
    """
    index = []

    # Add FSH artifacts.
    for artifact in ig_content.get("artifacts", []):
        name = artifact["name"]
        title = artifact.get("title", "")
        desc = artifact.get("description", "")
        atype = artifact["type"]
        keywords = _extract_keywords(f"{name} {title} {desc}")

        index.append({
            "area": f"{atype}: {name}",
            "type": "artifact",
            "keywords": keywords,
            "detail": f"{artifact['file']}:{artifact['line']}",
        })

    # Add markdown pages and their headings.
    for page in ig_content.get("pages", []):
        filename = page["file"]
        page_keywords = set()

        for heading in page.get("headings", []):
            heading_text = heading["text"]
            heading_kw = _extract_keywords(heading_text)
            page_keywords.update(heading_kw)

            index.append({
                "area": f"Page: {filename} > {heading_text}",
                "type": "section",
                "keywords": heading_kw,
                "detail": f"{filename}:{heading['line']}",
            })

        # Also add the page as a whole.
        index.append({
            "area": f"Page: {filename}",
            "type": "page",
            "keywords": page_keywords,
            "detail": filename,
        })

    # Add config-listed pages.
    config = ig_content.get("config", {})
    for page_file, page_title in config.get("pages", {}).items():
        kw = _extract_keywords(page_title)
        index.append({
            "area": f"Config Page: {page_title} ({page_file})",
            "type": "config_page",
            "keywords": kw,
            "detail": page_file,
        })

    return index


def _extract_keywords(text):
    """Extract meaningful lowercase keywords from text."""
    if not text:
        return set()
    tokens = TOKEN_PATTERN.findall(text.lower())
    return {t for t in tokens if t not in STOP_WORDS and len(t) > 1}


def _find_matches(ticket_keywords, ig_index, min_score=1):
    """Score ticket keywords against each IG index entry.

    Returns matches sorted by score (descending), filtered by min_score.
    """
    matches = []

    for entry in ig_index:
        overlap = ticket_keywords & entry["keywords"]
        if not overlap:
            continue

        # Base score is the number of overlapping keywords.
        score = len(overlap)

        # Boost for FHIR-specific terms.
        fhir_overlap = overlap & FHIR_BOOST_TERMS
        score += len(fhir_overlap) * 2

        # Boost for artifact matches (more specific).
        if entry["type"] == "artifact":
            score += 1

        if score >= min_score:
            matches.append({
                "area": entry["area"],
                "type": entry["type"],
                "score": score,
                "detail": entry["detail"],
                "matched_terms": sorted(overlap),
            })

    # Sort by score descending, then area alphabetically.
    matches.sort(key=lambda m: (-m["score"], m["area"]))
    return matches


def compute_coverage(mappings, ig_content):
    """Compute which IG areas are covered by tickets and which have gaps.

    Args:
        mappings: Output of map_tickets_to_content().
        ig_content: Parsed IG dict from ig_parser.parse_ig().

    Returns:
        Dict with: covered (set of areas), uncovered (set of areas),
        coverage_ratio (float).
    """
    # Collect all known IG areas.
    all_areas = set()
    for artifact in ig_content.get("artifacts", []):
        all_areas.add(f"{artifact['type']}: {artifact['name']}")
    for page in ig_content.get("pages", []):
        all_areas.add(f"Page: {page['file']}")

    # Collect areas referenced by tickets.
    covered = set()
    for mapping in mappings:
        for match in mapping.get("matches", []):
            # Normalize to just the top-level area.
            area = match["area"]
            if " > " in area:
                area = area.split(" > ")[0]
            covered.add(area)

    uncovered = all_areas - covered
    covered_in_scope = covered & all_areas
    total = len(all_areas) if all_areas else 1
    return {
        "covered": sorted(covered_in_scope),
        "uncovered": sorted(uncovered),
        "coverage_ratio": len(covered_in_scope) / total,
    }
