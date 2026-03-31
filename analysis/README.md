# Jira Ticket Analysis Tooling for FHIR IGs

Analyze and map Jira ballot/tracker tickets to IG content areas. Built for the [AI Transparency on FHIR](http://hl7.org/fhir/uv/aitransparency) IG, but designed to be adapted for any HL7 FHIR IG.

## What It Does

1. **Fetches** all Jira tickets for a specification from jira.hl7.org
2. **Parses** the IG source content (FSH profiles, markdown pages, sushi-config)
3. **Maps** tickets to IG content areas via keyword matching
4. **Generates** a markdown report with statistics, inventory, and coverage gaps

## Prerequisites

- Python 3.9+
- A Jira Personal Access Token (PAT) for [jira.hl7.org](https://jira.hl7.org)

## Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Set your Jira PAT (choose one method)
#    Option A: Environment variable
export HL7_JIRA="your-jira-pat-here"
#    Option B: .env file
cp .env.example .env
#    Then edit .env and add your token

# 3. Fetch tickets from Jira
python fetch_tickets.py

# 4. Analyze tickets against IG content
python analyze_tickets.py

# 5. Generate the report
python generate_report.py
```

The report will be saved to `reports/ticket_analysis_YYYY-MM-DD.md`.

## Adapting for Another IG

Edit `config.yaml` to match your IG:

```yaml
jira:
  specification: YOUR-SPEC-NAME   # e.g. FHIR-us-core
  # The JQL template usually doesn't need changes

ig:
  root: ..                        # relative path to your IG repo root
  fsh_dir: input/fsh              # adjust if your FSH files are elsewhere
  pagecontent_dir: input/pagecontent
  sushi_config: sushi-config.yaml
```

The specification name must match exactly what appears in Jira's "Specification" field for your project.

## How the Pipeline Works

```
fetch_tickets.py          analyze_tickets.py          generate_report.py
     |                          |                            |
     v                          v                            v
Jira REST API     +-->  lib/ig_parser.py          data/analysis.json
     |            |     (FSH, MD, config)                    |
     v            |           |                              v
data/tickets.json +-->  lib/ticket_mapper.py       reports/ticket_analysis_
                        (keyword matching)          YYYY-MM-DD.md
                              |
                              v
                       data/analysis.json
```

### Scripts

| Script | Purpose |
|--------|---------|
| `fetch_tickets.py` | Fetch tickets from Jira and cache locally |
| `analyze_tickets.py` | Parse IG content and map tickets to it |
| `generate_report.py` | Generate a markdown report from the analysis |

### Libraries

| Module | Purpose |
|--------|---------|
| `lib/jira_client.py` | Jira REST API client (auth, search, pagination) |
| `lib/ig_parser.py` | Parse FSH files, markdown pages, sushi-config |
| `lib/ticket_mapper.py` | Map tickets to IG sections via keyword matching |

### Flags

`fetch_tickets.py` supports:
- `--force` — Re-fetch even if a local cache exists
- `--spec NAME` — Override the specification name from config

## File Layout

```
analysis/
├── README.md              # This file
├── requirements.txt       # Python dependencies
├── .env.example           # Template for Jira PAT
├── config.yaml            # IG-specific configuration
├── fetch_tickets.py       # Step 1: Fetch tickets
├── analyze_tickets.py     # Step 2: Analyze
├── generate_report.py     # Step 3: Report
├── lib/
│   ├── __init__.py
│   ├── jira_client.py     # Jira API client
│   ├── ig_parser.py       # IG content parser
│   └── ticket_mapper.py   # Ticket-to-content mapper
├── data/                  # Cached data (gitignored)
│   └── .gitkeep
└── reports/               # Generated reports (gitignored)
    └── .gitkeep
```

## Troubleshooting

### HTTP 403 from AWS WAF (SignalNonBrowserUserAgent)
HL7's Jira (jira.hl7.org) sits behind an AWS WAF with the
`AWS-AWSManagedRulesBotControlRuleSet` enabled. This includes a
`SignalNonBrowserUserAgent` rule that blocks any request whose `User-Agent`
header doesn't look like a real browser.

A custom string like `MyScript/1.0` will be blocked. The User-Agent **must**
start with `Mozilla/5.0` to pass the rule. This tooling uses:

```
Mozilla/5.0 (compatible; HL7-IG-Analysis/1.0; +https://github.com/HL7/fhir-ai-transparency)
```

If you're adapting this for another tool or language, make sure your HTTP
client sends a `Mozilla/5.0`-prefixed User-Agent or you'll get a bare
`403 Forbidden` HTML response from the `awselb/2.0` layer before your request
ever reaches Jira.

Note: HL7's Confluence (confluence.hl7.org) does **not** have this restriction
as of March 2026.

### "Authentication failed (HTTP 401)"
Your PAT is invalid or expired. Generate a new one at:
jira.hl7.org → Profile → Personal Access Tokens

### "Could not find a field named 'Specification'"
The script auto-discovers Jira custom fields. If this fails, it may indicate
a permissions issue with your PAT.

### "No cached tickets found"
Run `fetch_tickets.py` before `analyze_tickets.py` or `generate_report.py`.

### PEP 668 / "externally-managed-environment"
In some Python environments, you may need:
```bash
pip install --break-system-packages -r requirements.txt
```
Or use a virtual environment:
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

## Scope

- **Read-only** — never writes back to Jira
- **No IG building** — does not run SUSHI or IG Publisher
- **Deterministic** — no LLM or AI analysis; keyword matching only
- **Local caching** — Jira data is cached in `data/` so you don't re-fetch on every analysis run
