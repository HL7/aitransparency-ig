# Analysis Report: Jira Tickets Missing "Related Artifact(s)" Field

**Analysis Date:** 2026-02-03
**Source File:** Jira 2026-01-26T11_11_56-0600.html
**Total Tickets Analyzed:** 90
**Tickets WITHOUT Related Artifact(s):** 55
**Tickets WITH Related Artifact(s):** 35

---

## Executive Summary

This analysis identified **14 unique tickets** that do NOT have the "Related Artifact(s)" field (customfield_11300) populated, but whose summary or description clearly indicates they are about specific FHIR artifacts/profiles. These tickets should have had an artifact specified but were entered incorrectly.

The tickets have been grouped by the FHIR artifact they should be associated with, along with confidence levels based on how clearly the ticket content references that artifact.

---

## Findings by Artifact

### 1. AI Device Profile
**Total Tickets:** 3 (2 High Confidence, 0 Medium, 1 Low)

#### High Confidence:

**FHIR-54527: Reduce variability on R4 AI device modeling**
- **Page:** General Guidance
- **Why it should have artifact:** The ticket specifically discusses AI Device modeling, Device.note, and Device profile implementation in R4
- **Key Content:** Discusses "AI device" modeling and "Device.note.text" element usage for Model-Card
- **Recommendation:** Should be linked to "AI Device Profile"

**FHIR-54267: DocumentReference, Device.note or Device.property**
- **Page:** General Guidance
- **Why it should have artifact:** Explicitly discusses Device.note, Device.property, and Device resource in context of Model-Card representation
- **Key Content:** "Device.note in R4 (but effectively also R5 and R6), Device.property in R5/R6"
- **Recommendation:** Should be linked to "AI Device Profile"

#### Low Confidence:

**FHIR-54262: Defining AI and Model Card is ambiguous**
- **Page:** General Guidance
- **Why it might need artifact:** Discusses "Device resource" in the context of AI definition
- **Key Content:** "An AI is defined using the Device resource"
- **Recommendation:** Consider linking to "AI Device Profile" (low priority due to general nature)

---

### 2. AI Model-Card DocumentReference Profile
**Total Tickets:** 5 (2 High Confidence, 2 Medium, 1 Low)

#### High Confidence:

**FHIR-54735: Define Model Card better**
- **Page:** General Guidance
- **Why it should have artifact:** Specifically about Model Card definition and structure
- **Key Content:** "A Model Card is a standard representation of the description and metadata about a specific AI model"
- **Recommendation:** Should be linked to "AI Model-Card DocumentReference Profile"

**FHIR-54262: Defining AI and Model Card is ambiguous**
- **Page:** General Guidance
- **Why it should have artifact:** Discusses Model Card concept and its definition
- **Key Content:** Addresses ambiguity in "An AI" vs "The AI System" and Model Card usage
- **Recommendation:** Should be linked to "AI Model-Card DocumentReference Profile"

#### Medium Confidence:

**FHIR-54267: DocumentReference, Device.note or Device.property**
- **Page:** General Guidance
- **Why it might need artifact:** Discusses Model-Card representation options including DocumentReference
- **Key Content:** "three ways to convey the Model-Card" including DocumentReference linked to Provenance
- **Recommendation:** Could be linked to "AI Model-Card DocumentReference Profile"

**FHIR-54527: Reduce variability on R4 AI device modeling**
- **Page:** General Guidance
- **Why it might need artifact:** Discusses Model-Card markdown representation
- **Key Content:** "put that Markdown Model-Card into the Device.note.text element"
- **Recommendation:** Could be linked to "AI Model-Card DocumentReference Profile"

#### Low Confidence:

**FHIR-54118: Describe the real world elements that are being encoded in the model**
- **Page:** Overview
- **Why it might need artifact:** Mentions "model card" in passing
- **Key Content:** General discussion about encoding elements in the model
- **Recommendation:** Review for potential link (very general discussion)

---

### 3. AI Provenance Profile
**Total Tickets:** 1 (1 High Confidence)

#### High Confidence:

**FHIR-54528: Describe how to exchange AI provenance via RESTful create**
- **Page:** General Guidance
- **Why it should have artifact:** Explicitly about AI provenance exchange and implementation
- **Key Content:** "how to describe AI created data" and "exchange AI provenance via the RESTful create interaction"
- **Recommendation:** Should be linked to "AI Provenance Profile"

---

### 4. AI Data (Observation) Profile
**Total Tickets:** 2 (0 High Confidence, 1 Medium, 1 Low)

#### Medium Confidence:

**FHIR-53967: Some clarifications**
- **Page:** General Guidance
- **Why it might need artifact:** Mentions "AI Data" in context of CodeSystem and observability factors
- **Key Content:** Discusses observability factors and includes "AI Data" terminology
- **Recommendation:** Consider linking to "AI Data (Observation) Profile"

#### Low Confidence:

**FHIR-54644: flesh out AI training on clinical data**
- **Page:** Use Cases
- **Why it might need artifact:** Discusses data principles and AI training data
- **Key Content:** "transparency in training content" and data labeling (data provenance, size, timeframes, diversity)
- **Recommendation:** Review - may be more about general guidance than specific profile

---

### 5. CodeSystem
**Total Tickets:** 1 (0 High Confidence, 1 Medium)

#### Medium Confidence:

**FHIR-53967: Some clarifications**
- **Page:** General Guidance
- **Why it might need artifact:** References CodeSystem in context of observability factors
- **Key Content:** Discusses terminology and mentions "CodeSystem" for AI Data
- **Recommendation:** Consider linking to relevant CodeSystem artifact if one exists

---

### 6. Extensions
**Total Tickets:** 2 (0 High Confidence, 0 Medium, 2 Low)

#### Low Confidence:

**FHIR-53967: Some clarifications**
- **Page:** General Guidance
- **Why it might need artifact:** Mentions "extension" in passing
- **Recommendation:** Low priority - likely not specific to an extension artifact

**FHIR-54527: Reduce variability on R4 AI device modeling**
- **Page:** General Guidance
- **Why it might need artifact:** Mentions "extension" as an alternative approach
- **Recommendation:** Low priority - likely not specific to an extension artifact

---

## Priority Recommendations

### Immediate Action (High Confidence - 5 tickets):
1. **FHIR-54527** → AI Device Profile
2. **FHIR-54267** → AI Device Profile (also possibly AI Model-Card DocumentReference Profile)
3. **FHIR-54735** → AI Model-Card DocumentReference Profile
4. **FHIR-54262** → AI Model-Card DocumentReference Profile (also possibly AI Device Profile)
5. **FHIR-54528** → AI Provenance Profile

### Review and Consider (Medium Confidence - 4 tickets):
1. **FHIR-54267** → AI Model-Card DocumentReference Profile
2. **FHIR-54527** → AI Model-Card DocumentReference Profile
3. **FHIR-53967** → AI Data (Observation) Profile or CodeSystem
4. **FHIR-53967** → CodeSystem

### Low Priority (Low Confidence - 5 tickets):
These tickets mention artifacts but may not require the field to be populated as the references are tangential.

---

## Observations

1. **FHIR-54267 and FHIR-54527** appear to be relevant to multiple artifacts (both AI Device and AI Model-Card DocumentReference), suggesting they may need multiple artifact associations.

2. **FHIR-54262** also appears relevant to both AI Device Profile and AI Model-Card DocumentReference Profile, as it discusses both the Device resource and Model Card concept.

3. **FHIR-53967** appears multiple times across different artifact categories (AI Data, CodeSystem, Extensions), suggesting it's a broad clarification ticket that touches on multiple artifacts.

4. Many tickets reference the "General Guidance" page, suggesting documentation issues rather than profile-specific technical issues.

5. The most common misclassification pattern is tickets about Model Cards not being linked to the AI Model-Card DocumentReference Profile.

---

## Statistics Summary

| Artifact Type | Total | High | Medium | Low |
|--------------|-------|------|--------|-----|
| AI Device Profile | 3 | 2 | 0 | 1 |
| AI Model-Card DocumentReference Profile | 5 | 2 | 2 | 1 |
| AI Provenance Profile | 1 | 1 | 0 | 0 |
| AI Data (Observation) Profile | 2 | 0 | 1 | 1 |
| CodeSystem | 1 | 0 | 1 | 0 |
| Extensions | 2 | 0 | 0 | 2 |
| **TOTAL** | **14** | **5** | **4** | **5** |

---

## Unique Tickets (Deduplicated)

The following unique ticket keys were identified as potentially misclassified:

1. FHIR-54527
2. FHIR-54267
3. FHIR-54735
4. FHIR-54262
5. FHIR-54528
6. FHIR-53967
7. FHIR-54644
8. FHIR-54118

**Total Unique Tickets: 8** (some appear in multiple artifact categories)

---

## Conclusion

A significant portion of the tickets (55 out of 90, or 61%) do not have the "Related Artifact(s)" field populated. Among these, at least 8 unique tickets clearly discuss specific FHIR artifacts and should have this field populated. 

The most critical corrections involve:
- AI Device Profile (3 tickets)
- AI Model-Card DocumentReference Profile (5 ticket instances, but some overlap with Device)
- AI Provenance Profile (1 ticket)

Recommend reviewing and updating the "Related Artifact(s)" field for at minimum the 5 high-confidence tickets identified in this analysis.
