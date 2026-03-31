# General Guidance Update — Ticket Impact Analysis

**Analyzed:** 2026-03-31
**Commit analyzed:** `83369f6` — "Working on FHIR-55022 I reorganized and rewrote much of the general_guidance.md"
**Total IG tickets:** 126
**Tickets potentially addressed by this update:** 47 unique tickets (37% of total)

## Summary of What Changed

The update to `general_guidance.md` made these major structural and content changes:

1. **Replaced the 4-level observability table** with a 2-level framework (Tagging + AI Observability Factors with 3 sub-categories: Model, Context, Process)
2. **Rewrote the tagging section** with clearer language and added an STU note explaining the tagging-vs-provenance relationship
3. **Renamed and rewrote "Defining the AI" / "Using Model-Card"** → "Defining the AI Model" — fixed the incorrect claim that "The Model-Card represents the request"
4. **Renamed and rewrote "Data Sources"** → "Context of AI Usage" — defined System Prompt and User Prompt, removed placeholder text
5. **Renamed and rewrote "Process Examples"** → "Process Utilizing AI" — added substantive content about human-in-the-loop, guardrails, MCP, A2A
6. **Reorganized heading hierarchy** — adjusted heading levels for better document structure
7. **Fixed several typos and grammar issues** throughout

---

## Tickets Directly Addressed (changes resolve or substantially address the concern)

### Observability Framework Restructuring

| Ticket | Summary | How Addressed |
|--------|---------|---------------|
| [FHIR-55022](https://jira.hl7.org/browse/FHIR-55022) | Inconsistent references to four levels of Observability Factors | **Directly targeted by this commit.** The 4-level table was replaced with a clearer 2-level framework. |
| [FHIR-53770](https://jira.hl7.org/browse/FHIR-53770) | Does the row represent 4 levels? | The confusing table with ambiguous rows was removed entirely and replaced with a clear bulleted list. |
| [FHIR-54275](https://jira.hl7.org/browse/FHIR-54275) | Table in Observability Factors for iterative IG development | The table was removed and content reorganized into prose with clear categories. |
| [FHIR-54181](https://jira.hl7.org/browse/FHIR-54181) | Align bullet point text with table headers | The table/bullet mismatch is eliminated because the table was removed and replaced with aligned content. |
| [FHIR-54740](https://jira.hl7.org/browse/FHIR-54740) | Mismatched headings in table and sub-headings | Headings now consistently match the 3-category structure (Model, Context, Process). |
| [FHIR-54236](https://jira.hl7.org/browse/FHIR-54236) | Unclear sentence | The unclear sentence ("simply a need to distinguishes where AI was used") was removed in the rewrite. |

### Model-Card Clarification

| Ticket | Summary | How Addressed |
|--------|---------|---------------|
| [FHIR-54421](https://jira.hl7.org/browse/FHIR-54421) | Clarify Model-Card semantics: Model-Card describes the AI model/system, not the request/prompt | **Directly fixed.** The incorrect statement "The Model-Card represents the request that was made of the AI" was removed and replaced with accurate language about Model-Cards describing AI models. |
| [FHIR-54264](https://jira.hl7.org/browse/FHIR-54264) | Conflicting Model-Card definitions | The guidance now consistently describes Model-Cards as standards for describing AI models, not requests. |
| [FHIR-54735](https://jira.hl7.org/browse/FHIR-54735) | Define Model Card better | The rewrite provides clearer context about what Model-Cards are and references Hugging Face and CHAI as examples. |
| [FHIR-54256](https://jira.hl7.org/browse/FHIR-54256) | Fix repetition of word Model | The "Model(s) Examples Model documentation" heading was rewritten. |

### Context/Data Sources Rewrite

| Ticket | Summary | How Addressed |
|--------|---------|---------------|
| [FHIR-54135](https://jira.hl7.org/browse/FHIR-54135) | Incomplete sentence with placeholder text | **Fixed.** The "[convey, produce, other?]" draft text was removed in the rewrite. |
| [FHIR-54137](https://jira.hl7.org/browse/FHIR-54137) | Placeholder instruction text not replaced with content | **Fixed.** "Insert example scenarios for using data source documentation" was removed and replaced with actual content. |
| [FHIR-54576](https://jira.hl7.org/browse/FHIR-54576) | Forgotten placeholder | **Fixed.** Same placeholder removed. |
| [FHIR-54238](https://jira.hl7.org/browse/FHIR-54238) | Fix draft sentence | **Fixed.** The draft sentence about "convey, produce, other?" was removed. |
| [FHIR-54239](https://jira.hl7.org/browse/FHIR-54239) | Request / reference input distinction seems arbitrary | The rewrite reframes inputs as "prompts" (System Prompt, User Prompt) rather than the old request/reference input split. |

### Process Section

| Ticket | Summary | How Addressed |
|--------|---------|---------------|
| [FHIR-54211](https://jira.hl7.org/browse/FHIR-54211) | Provide model to capture human in the loop | The rewrite adds explicit text about human-in-the-loop as a named process element with guidance on capturing it in Provenance. |
| [FHIR-54215](https://jira.hl7.org/browse/FHIR-54215) | Process/how was it recorded | "How was it recorded" was vague — replaced with concrete categories (human-in-the-loop, guardrails, other AI/systems). |

### Typos and Grammar (confirmed fixed in current text)

| Ticket | Summary | How Addressed |
|--------|---------|---------------|
| [FHIR-54143](https://jira.hl7.org/browse/FHIR-54143) | "distinguishes" should be "distinguish" | **Fixed.** The sentence containing this error was removed in the rewrite. |
| [FHIR-54237](https://jira.hl7.org/browse/FHIR-54237) | Typo "compressive" | **Fixed.** The sentence with "compressive" was removed in the rewrite. |

### Heading/Structure

| Ticket | Summary | How Addressed |
|--------|---------|---------------|
| [FHIR-54240](https://jira.hl7.org/browse/FHIR-54240) | Reorder of the General Guidance page | The page was substantially reorganized with a clearer flow: Tagging → Model → Context → Process. |
| [FHIR-54365](https://jira.hl7.org/browse/FHIR-54365) | Suggest to demote sections 2.3 and 2.4 | Heading levels were adjusted — R5/R6 and R4 sections demoted from h3 to h4. |

---

## Tickets Partially Addressed (changes help but don't fully resolve)

| Ticket | Summary | What's Addressed | What Remains |
|--------|---------|------------------|--------------|
| [FHIR-53967](https://jira.hl7.org/browse/FHIR-53967) | Some clarifications | The table structure was clarified, observability factors harmonized. | May need to review if all specific clarification requests in the ticket are met. |
| [FHIR-54210](https://jira.hl7.org/browse/FHIR-54210) | Context observability factor categories not represented in model | Context section was rewritten, but some sub-categories (data quality, data qualification, operations) were simplified rather than fully modeled. | The ticket asks for FHIR modeling of these categories, not just text changes. |
| [FHIR-54233](https://jira.hl7.org/browse/FHIR-54233) | Elaborate the Operation section | MCP and A2A are now mentioned in the Process section with more context. | The ticket asks for clearer modeling of how they enter the FHIR representation. |
| [FHIR-54262](https://jira.hl7.org/browse/FHIR-54262) | Defining AI and Model Card is ambiguous | Section renamed and clarified, but may still need sharper distinction between "an AI" (Device) and "the AI System". | Review whether the current text resolves the ambiguity. |
| [FHIR-54438](https://jira.hl7.org/browse/FHIR-54438) | Clarify "Operations" in Data Sources | Operations (MCP, A2A) moved to Process section, which is a better fit. | The ticket asks for deeper clarification of scope. |
| [FHIR-54734](https://jira.hl7.org/browse/FHIR-54734) | For better readability, switch section 2 and 3 | The guidance page was reorganized for better flow. | The ticket asks to move Use Cases before Guidance — that's a cross-page change not addressed here. |
| [FHIR-54280](https://jira.hl7.org/browse/FHIR-54280) | Security labels are discovery hints, not authoritative evidence | The STU note now explains the relationship between tags and Provenance, and notes that tagging is not enforced. | Could be more explicit that tags are hints, not authoritative. |

---

## Tickets NOT Addressed by This Update

These tickets reference `general_guidance.md` but are not resolved by the rewrite:

| Ticket | Summary | Why Not Addressed |
|--------|---------|-------------------|
| [FHIR-54136](https://jira.hl7.org/browse/FHIR-54136) | AIAIST vs AIAST inconsistency | **AIAIST still appears** on lines 55 and 153 in mermaid diagrams. |
| [FHIR-54144](https://jira.hl7.org/browse/FHIR-54144) | Typo: "invovled" should be "involved" | **Still present** on line 77. |
| [FHIR-54145](https://jira.hl7.org/browse/FHIR-54145) | Typo: "infuence" should be "influence" | **Still present** on line 48. |
| [FHIR-54148](https://jira.hl7.org/browse/FHIR-54148) | "strongly clear" is not standard English | **Still present** on line 242 ("that is not strongly clear"). |
| [FHIR-54242](https://jira.hl7.org/browse/FHIR-54242) | Correct meta.security.code in diagram | The mermaid diagram still shows `meta.security = AIAIST` (should be AIAST and should show the path correctly). |
| [FHIR-54255](https://jira.hl7.org/browse/FHIR-54255) | Add UML diagram for inline tagging | No diagram was added for inline tagging. |
| [FHIR-54235](https://jira.hl7.org/browse/FHIR-54235) | Data quality / data qualification | These sub-categories were dropped from the rewrite rather than clarified. |
| [FHIR-54241](https://jira.hl7.org/browse/FHIR-54241) | AI deletion of resources | Not addressed — guidance only covers creation/updating. |
| [FHIR-54276](https://jira.hl7.org/browse/FHIR-54276) | Tagging definition conflicts with FHIR labeling | The rewrite uses "Tagging" but doesn't address the terminology conflict with FHIR's use of "label". |
| [FHIR-54707](https://jira.hl7.org/browse/FHIR-54707) | Refrain from using Tag or define it | Related to above — "Tag/Tagging" still used without defining the distinction from FHIR labels. |
| [FHIR-54433](https://jira.hl7.org/browse/FHIR-54433) | Clarify privacy/access control for Input Prompt artifacts | Not addressed — no PHI/IP guidance added. |
| [FHIR-54577](https://jira.hl7.org/browse/FHIR-54577) | Extend input prompt to agentic multi-turn conversations | Not addressed — only single-turn prompts are discussed. |
| [FHIR-54578](https://jira.hl7.org/browse/FHIR-54578) | Add use case about traceability of LLM agent-made API calls | Not addressed — agentic workflows mentioned but not modeled. |

---

## New Typos Introduced by the Rewrite

The following typos exist in the current text that were **introduced** (or carried forward) by the rewrite:

| Line | Issue |
|------|-------|
| 22 | "Ogranization" → should be "Organization" |
| 138 | "Cheif" → should be "Chief" |
| 138 | "algorythm" → should be "algorithm" |
| 305 | "varified" → should be "verified" (appears twice) |
| 313 | "conformaty" → should be "conformity" |
| 55, 153 | "AIAIST" → should be "AIAST" (in mermaid diagrams) |
| 48 | "infuence" → should be "influence" (carried forward) |
| 77 | "invovled" → should be "involved" (carried forward) |

---

*Generated by analysis tooling. See analysis/README.md for details.*
