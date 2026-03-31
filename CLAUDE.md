# AI Transparency on FHIR — CLAUDE.md

## Project Overview
HL7 FHIR Implementation Guide (hl7.fhir.uv.aitransparency) providing standards for representing AI usage in FHIR resources. Enables downstream identification and informed usage of AI-inferred health data.

## FHIR IG Structure
- `input/` — IG source content (pages, resources, profiles, examples)
- `sushi-config.yaml` — SUSHI/FSH configuration
- `fsh-generated/` — Generated output from SUSHI
- `ig.ini` — IG Publisher configuration

## UADF
This project uses UADF for session continuity and decision tracking.
- `JOURNAL.md` — Session handoffs and project log
- `docs/adr/` — Architecture Decision Records
