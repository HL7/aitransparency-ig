"""Parse IG source content — FSH files, markdown pages, and sushi-config.yaml.

Returns a structured dict describing every artifact, page, and section in the
IG so that tickets can be mapped to specific content areas.
"""

import re
from pathlib import Path

import yaml


# FSH declaration patterns — each captures the artifact name.
FSH_PATTERNS = {
    "Profile": re.compile(r"^Profile:\s+(\S+)", re.MULTILINE),
    "Extension": re.compile(r"^Extension:\s+(\S+)", re.MULTILINE),
    "CodeSystem": re.compile(r"^CodeSystem:\s+(\S+)", re.MULTILINE),
    "ValueSet": re.compile(r"^ValueSet:\s+(\S+)", re.MULTILINE),
    "Instance": re.compile(r"^Instance:\s+(\S+)", re.MULTILINE),
    "Logical": re.compile(r"^Logical:\s+(\S+)", re.MULTILINE),
    "Invariant": re.compile(r"^Invariant:\s+(\S+)", re.MULTILINE),
}

# Capture the Title and Description lines that follow a declaration.
TITLE_PATTERN = re.compile(r'^Title:\s+"([^"]+)"', re.MULTILINE)
DESC_PATTERN = re.compile(r'^Description:\s+"([^"]+)', re.MULTILINE)

# Markdown heading pattern (##, ###, ####, etc.)
HEADING_PATTERN = re.compile(r"^(#{1,6})\s+(.+)$", re.MULTILINE)


def parse_ig(ig_root, fsh_dir="input/fsh", pagecontent_dir="input/pagecontent",
             sushi_config="sushi-config.yaml"):
    """Parse all IG source content and return a structured dict.

    Args:
        ig_root: Path to the IG repository root.
        fsh_dir: Relative path to FSH source files.
        pagecontent_dir: Relative path to markdown page content.
        sushi_config: Relative path to the SUSHI config file.

    Returns:
        Dict with keys: "config", "artifacts", "pages".
    """
    root = Path(ig_root)
    result = {
        "config": parse_sushi_config(root / sushi_config),
        "artifacts": parse_fsh_directory(root / fsh_dir),
        "pages": parse_pagecontent(root / pagecontent_dir),
    }
    return result


def parse_sushi_config(config_path):
    """Extract key metadata from sushi-config.yaml.

    Returns a dict with: id, name, title, version, status, pages, resources.
    """
    with open(config_path) as f:
        cfg = yaml.safe_load(f)

    pages = {}
    raw_pages = cfg.get("pages", {})
    if raw_pages:
        for filename, props in raw_pages.items():
            title = props.get("title", filename) if isinstance(props, dict) else filename
            pages[filename] = title

    resources = {}
    raw_resources = cfg.get("resources", {})
    if raw_resources:
        for ref, props in raw_resources.items():
            name = props.get("name", ref) if isinstance(props, dict) else ref
            resources[ref] = name

    return {
        "id": cfg.get("id", ""),
        "name": cfg.get("name", ""),
        "title": cfg.get("title", ""),
        "version": cfg.get("version", ""),
        "status": cfg.get("status", ""),
        "release_label": cfg.get("releaseLabel", ""),
        "fhir_version": cfg.get("fhirVersion", ""),
        "pages": pages,
        "resources": resources,
    }


def parse_fsh_directory(fsh_dir):
    """Parse all .fsh files and extract declared artifacts.

    Returns a list of dicts, each with:
      type, name, title, description, file, line
    """
    artifacts = []
    fsh_path = Path(fsh_dir)

    if not fsh_path.exists():
        return artifacts

    for fsh_file in sorted(fsh_path.glob("*.fsh")):
        text = fsh_file.read_text(errors="replace")
        artifacts.extend(_parse_fsh_text(text, fsh_file.name))

    return artifacts


def _parse_fsh_text(text, filename):
    """Parse a single FSH file's text for artifact declarations."""
    artifacts = []
    lines = text.split("\n")

    for artifact_type, pattern in FSH_PATTERNS.items():
        for match in pattern.finditer(text):
            name = match.group(1)
            line_num = text[:match.start()].count("\n") + 1

            # Look for Title and Description in the lines after the declaration
            # (within the next 5 lines, before the next declaration or rule)
            after_text = text[match.end():match.end() + 500]
            title_match = TITLE_PATTERN.search(after_text)
            desc_match = DESC_PATTERN.search(after_text)

            title = title_match.group(1) if title_match else ""
            description = desc_match.group(1) if desc_match else ""

            artifacts.append({
                "type": artifact_type,
                "name": name,
                "title": title,
                "description": description,
                "file": filename,
                "line": line_num,
            })

    return artifacts


def parse_pagecontent(pagecontent_dir):
    """Parse markdown pages for headings and key terms.

    Returns a list of dicts, each with:
      file, title, headings (list of {level, text, line})
    """
    pages = []
    pc_path = Path(pagecontent_dir)

    if not pc_path.exists():
        return pages

    for md_file in sorted(pc_path.glob("*.md")):
        text = md_file.read_text(errors="replace")

        headings = []
        for match in HEADING_PATTERN.finditer(text):
            level = len(match.group(1))
            heading_text = match.group(2).strip()
            line_num = text[:match.start()].count("\n") + 1
            headings.append({
                "level": level,
                "text": heading_text,
                "line": line_num,
            })

        pages.append({
            "file": md_file.name,
            "headings": headings,
        })

    return pages
