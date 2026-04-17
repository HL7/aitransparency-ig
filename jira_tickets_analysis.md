# Jira Tickets Analysis: AI Transparency IG

**Date:** 2026-01-26
**Total Tickets:** 90

---

## Table of Contents

1. [(NA)](#na) (4 tickets)
2. [(many)](#many) (2 tickets)
3. [General Guidance](#general-guidance) (30 tickets)
4. [Overview](#overview) (16 tickets)
5. [Use Cases](#use-cases) (11 tickets)
6. [(No Page Specified)](#no-page-specified) (27 tickets)

---

## (NA)

**Total tickets for this page:** 4

### Assumptions and Caveats

*1 ticket*

- **FHIR-54895**: Strengthen realism of assumptions for distributed AI pipelines.

### Background

*1 ticket*

- **FHIR-54894**: Clarify observability

### Dependencies

*1 ticket*

- **FHIR-54899**: Improve clarity and readability of dependency rationale

### Guidance

*1 ticket*

- **FHIR-54898**: See ballot comment.

---

## (many)

**Total tickets for this page:** 2

### (No Section Specified)

*2 tickets*

- **FHIR-54351**: navigation
- **FHIR-54642**: AI ingesting info

---

## General Guidance

**Total tickets for this page:** 30

### 2 and 2.1

*1 ticket*

- **FHIR-54181**: Align bullet point text with table headers

### 2.1

*5 tickets*

- **FHIR-54210**: Context observability factor categories are not represented in the model
- **FHIR-54211**: Provide model to capture human in the loop
- **FHIR-54215**: Process/how was it recorded
- **FHIR-54233**: elaborate the Operation section
- **FHIR-54740**: Mismatched headings in table and sub-headings

### 2.1 and 2.2

*1 ticket*

- **FHIR-54240**: Reorder of the General Guidance page

### 2.1.1

*1 ticket*

- **FHIR-54236**: Unclear sentence

### 2.1.3

*3 tickets*

- **FHIR-54235**: Data quality / data qualification
- **FHIR-54239**: Request / refernece input
- **FHIR-54438**: Clarify "Operations" in Data Sources (scope is unclear; examples focus only on protocols)

### 2.2-4

*1 ticket*

- **FHIR-54365**: Suggest to demote sections 2.3 and 2.4

### 2.3

*3 tickets*

- **FHIR-54241**: AI deletion of resources
- **FHIR-54242**: Correct meta.security.code in diagram
- **FHIR-54255**: Add UML diagram for inline tagging

### 2.6

*2 tickets*

- **FHIR-54421**: Clarify Model-Card semantics: Model-Card describes the AI model/system, not the request/prompt
- **FHIR-54735**: Define Model Card better

### 2.6.4

*1 ticket*

- **FHIR-54527**: Reduce variability on R4 AI device modeling

### 2.7.1

*1 ticket*

- **FHIR-54433**: Clarify privacy and access control for Input Prompt artifacts (PHI/IP risk) and avoid prompt duplication

### Data Source Examples

*1 ticket*

- **FHIR-54137**: Placeholder instruction text not replaced with content

### Observability Factors for iterative IG development

*2 tickets*

- **FHIR-55022**: Inconsistent references to four levels of Observability Factors
- **FHIR-55024**: Description of algorithm deterministic/non-deterministic/hybrid

### (No Section Specified)

*8 tickets*

- **FHIR-53770**: Does the row represent 4 levels?
- **FHIR-53967**: Some clarifications
- **FHIR-54262**: Defining AI and Model Card is ambiguous
- **FHIR-54264**: Conflicting Model-Card definitions.
- **FHIR-54267**: DocumentReference, Device.note or Device.property
- **FHIR-54528**: Describe how to exchange AI provenance via RESTful create
- **FHIR-54641**: rephrase for clarity
- **FHIR-54707**: Refrain from using Tag or define it

---

## Overview

**Total tickets for this page:** 16

### 1.1 Background

*3 tickets*

- **FHIR-54114**: Differenciate the AI inference of information vs. a FHIR resource
- **FHIR-54116**: Clarify sentence about the aim of the IG
- **FHIR-54118**: Describe the real world elements that are being encoded in the model

### 1.2 Scope

*3 tickets*

- **FHIR-54158**: Replace users by consumers
- **FHIR-54179**: rule-based systems inclusion in scope
- **FHIR-54726**: Scope needs some refinement

### 1.5

*1 ticket*

- **FHIR-54180**: Describe plans for R5/R6

### 2.1

*1 ticket*

- **FHIR-54275**: Table in Observability Factors for iterative IG development

### 2.3

*1 ticket*

- **FHIR-54276**: Tagging

### IP

*1 ticket*

- **FHIR-54640**: add CPT to IP section

### Overview

*1 ticket*

- **FHIR-54729**: Missing plain language summary

### Scope

*1 ticket*

- **FHIR-54893**: Clarify AI vs non-AI scope to avoid inconsistent observability implementations.

### Scope 1.2

*1 ticket*

- **FHIR-54274**: IG Scope simplification

### (No Section Specified)

*3 tickets*

- **FHIR-54112**: Clarify the definition of the AI that is scoped
- **FHIR-54638**: Add to background section
- **FHIR-54885**: Please add some clarifying text to the Scope section

---

## Use Cases

**Total tickets for this page:** 11

### General Guidance and Use Cases

*1 ticket*

- **FHIR-54734**: For better readability, switch section 2 and 3

### Section 3

*1 ticket*

- **FHIR-54278**: Use case improvement

### Use Case 2

*1 ticket*

- **FHIR-54732**: Use case is unclear - suggest rewording

### (No Section Specified)

*8 tickets*

- **FHIR-53814**: Improved use-case
- **FHIR-53937**: All Use Cases should have diagrams
- **FHIR-54578**: Add use case about traceability of LLM agent-made API calls
- **FHIR-54583**: Use cases consider adding
- **FHIR-54643**: Add a PA use case
- **FHIR-54644**: flesh out AI training on clinical data
- **FHIR-54706**: Expand and elaborate further on use cases
- **FHIR-54731**: Data Viewing Questions - were these confirmed by actors

---

## (No Page Specified)

**Total tickets for this page:** 27

### 5.2.1

*1 ticket*

- **FHIR-54757**: AI capabilities of a e.g., a smart watch or smart BP meter device should be codeable

### Large Language Models definition

*1 ticket*

- **FHIR-54151**: LLM examples will become outdated

### Title and name

*1 ticket*

- **FHIR-54150**: CodeSystem title inconsistent with computable name

### meta.security:AItags binding

*1 ticket*

- **FHIR-54141**: Binding strength conflicts with ValueSet name "Recommended"

### (No Section Specified)

*23 tickets*

- **FHIR-53622**: RedHat AI System Card
- **FHIR-53969**: AI Data parent
- **FHIR-53970**: usages in the FHIR IG Statistics link not working
- **FHIR-53973**: Clarification on input data
- **FHIR-53974**: Relationship between Device and Model-Card
- **FHIR-53975**: Order of Relationship between Device and Model-Card
- **FHIR-53976**: Slicing can be translated to assignment
- **FHIR-54244**: Include an extension to capture the certainty of an AI inference
- **FHIR-54245**: Evaluate the need for a modifier extension on AI generated data
- **FHIR-54259**: Separate the input prompt modeling from the model card profile
- **FHIR-54260**: Clarify AI Data profile
- **FHIR-54279**: 1)	Add explicit guidance that, "AI attribution is asserted via Provenance, not embedded in clinical resources
- **FHIR-54280**: 3)	Security labels are discovery hints, not authoritative evidence of AI authorship
- **FHIR-54281**: Provide complete examples
- **FHIR-54368**: revise codes in AIdeviceTypeVS
- **FHIR-54371**: AI Device representation and it's elements
- **FHIR-54577**: Extend the use of AI input prompt to agentic multi turn conversation thread
- **FHIR-54580**: Example missing the AI tag
- **FHIR-54582**: Consider reference model card from device and not DocumentReference
- **FHIR-54723**: AI device conflicting type binding and property fixed values and extension
- **FHIR-54725**: AI Data profile missing example(s)
- **FHIR-54801**: Clarification of meaning of "reported" in code AIRPT
- **FHIR-54932**: AI Device .type for AI/LLM

---

## Summary Statistics

- **Total Pages:** 6
- **Total Tickets:** 90

### Tickets per Page

- **(NA):** 4 tickets
- **(many):** 2 tickets
- **General Guidance:** 30 tickets
- **Overview:** 16 tickets
- **Use Cases:** 11 tickets
- **(No Page Specified):** 27 tickets

### Section Breakdown

#### (NA)

- **Assumptions and Caveats:** 1 ticket
- **Background:** 1 ticket
- **Dependencies:** 1 ticket
- **Guidance:** 1 ticket

#### (many)

- **(No Section Specified):** 2 tickets

#### General Guidance

- **2 and 2.1:** 1 ticket
- **2.1:** 5 tickets
- **2.1 and 2.2:** 1 ticket
- **2.1.1:** 1 ticket
- **2.1.3:** 3 tickets
- **2.2-4:** 1 ticket
- **2.3:** 3 tickets
- **2.6:** 2 tickets
- **2.6.4:** 1 ticket
- **2.7.1:** 1 ticket
- **Data Source Examples:** 1 ticket
- **Observability Factors for iterative IG development:** 2 tickets
- **(No Section Specified):** 8 tickets

#### Overview

- **1.1 Background:** 3 tickets
- **1.2 Scope:** 3 tickets
- **1.5:** 1 ticket
- **2.1:** 1 ticket
- **2.3:** 1 ticket
- **IP:** 1 ticket
- **Overview:** 1 ticket
- **Scope:** 1 ticket
- **Scope 1.2:** 1 ticket
- **(No Section Specified):** 3 tickets

#### Use Cases

- **General Guidance and Use Cases:** 1 ticket
- **Section 3:** 1 ticket
- **Use Case 2:** 1 ticket
- **(No Section Specified):** 8 tickets

#### (No Page Specified)

- **5.2.1:** 1 ticket
- **Large Language Models definition:** 1 ticket
- **Title and name:** 1 ticket
- **meta.security:AItags binding:** 1 ticket
- **(No Section Specified):** 23 tickets

