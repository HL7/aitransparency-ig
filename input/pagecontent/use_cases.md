
Observability of the use of AI in the production or manipulation of health data matters for many reasons. This guide organizes those reasons into **four general use cases**. Each is a broad category that covers many more specific scenarios, and each is illustrated below with concrete examples drawn from the artifacts in this guide.

All four use cases rest on the two mechanisms described in the [Requirements](requirements.html): lightweight **labeling** (a `meta.security` label that signals AI was involved) and the **Provenance** resource (which carries the details — the AI model, the inputs, and the process). Labeling answers *"was AI involved?"* cheaply; Provenance answers *"how, by what, and with what oversight?"* authoritatively.

<style>
table {
    border-collapse: collapse;
    width: 100%;
}

table, th, td {
    border: 1px solid #999999;
}

th, td {
    padding: 8px;
    text-align: left;
}

th {
    background-color: #f5f5f5;
}
</style>

### Use Case 1: AI Attribution in Documentation Review

Anyone reviewing health data may want to know whether AI was involved in producing or manipulating that data, to what degree, and whether a human reviewed the result. This is the most common use case, and it applies far beyond the clinician at the bedside — it applies to **any actor reviewing FHIR data**, including researchers, payers and other administrators, quality and safety reviewers, and legal teams.

The need parallels long-standing practice: just as a reviewer expects to know which human authored a note, their role, and their qualifications, they increasingly need to distinguish content produced by AI, assisted by AI, and produced without any AI involvement.

```mermaid
flowchart LR
    DATA["📄<br/>Data"]
    AI["🤖<br/>AI"]
    AI_DATA["📄🤖<br/>(AI) Data"]
    VIEW["🖥️ 👀<br/>Reviewer"]

    DATA --> AI
    AI --> AI_DATA
    AI_DATA --> VIEW
```

The same use case takes a different shape depending on who is reviewing the data and why. The table below illustrates a few of the actors and the questions AI attribution helps them answer:

**Data Review Questions by Actor**

| When this Actor is reviewing data | The key questions may be... |
|--------------------------------|----------------------------|
| Clinician | What is happening (to modify)? Why is it happening? Was the AI output reviewed by a human? |
| Researcher | Is this data suitable for my study, or need AI-influenced data be excluded or stratified? |
| Payer | What matches prior-authorization criteria, and was the determination drafted by AI? |
| Quality Improvement | What matches the desired outcomes, or desired approach to care? |
| Safety Board | Multiple questions for root-cause analysis |
| Legal | Who — or what — is responsible? |
{: .grid}

#### Examples

**A whole resource produced by AI.** The [Observation with AI-asserted security labels](Observation-glasgow.html) carries the `AIAST` label on `meta.security`, signaling to any reviewer that the entire Observation was AI-asserted.

**Only part of a resource produced by AI.** The [DiagnosticReport with inline AI security labels](DiagnosticReport-f202.html) tags only the `conclusion` and `conclusionCode` elements. A reviewer can see that AI asserted the interpretation while the rest of the report was not AI-influenced.

**Seeing the degree of involvement and human oversight.** Tags signal that AI was involved; the [Provenance of an AI-authored Lab Observation](Provenance-AI-Contributed.html) shows the detail — the AI `Device` that authored it *and* the human verifier who reviewed it (human-in-the-loop).

**A non-clinical, administrative reviewer (prior authorization).** A health plan uses AI to draft a prior-authorization determination, which a human utilization reviewer verifies before release. The [Prior Authorization Determination drafted by AI](ClaimResponse-AI-PriorAuth-Determination.html) carries the `AIAST` label, and its [Provenance](Provenance-AI-PriorAuth-Provenance.html) records the AI author, the human verifier, and the original request as input. This is the same attribution need as the clinician's, applied to administrative data.

### Use Case 2: Filtering Content Produced or Manipulated by AI

A downstream system often needs to **include or exclude AI-influenced data based on its own risk tolerance**. The right decision differs by consumer: some workflows cannot tolerate AI-influenced inputs, while others can. Because each resource (or element) signals AI involvement through labeling, a consumer can filter accordingly.

Some illustrative consumers and their tolerances:

- **Training another AI model** — *low tolerance.* Training a model primarily on AI-generated content risks uncontrolled feedback loops and model degradation. The training pipeline filters out AI-influenced data.
- **Clinical decision support for medication recommendations** — *low tolerance.* A CDS system may need to reason only over human-asserted data and exclude AI-influenced inputs.
- **Population-health query** — *higher tolerance.* An aggregate query across a population can often tolerate AI-influenced data, and may choose to include it.

```mermaid
flowchart LR
    DATA["📄<br/>Data"]
    AI_DATA["📄🤖<br/>(AI) Data"]
    ML(("⚙️<br/>Process"))
    AI["👤<br/>Usage"]

    DATA --> ML
    AI_DATA  -.->|"🚫"| ML
    ML --> AI

    linkStyle 1 stroke:#c00,stroke-width:2px
```

Model training is one specific instance of this general pattern:

```mermaid
flowchart LR
    DATA["📄<br/>Data"]
    AI_DATA["📄🤖<br/>(AI) Data"]
    ML(("🧑‍💻<br/>ML Training"))
    AI["🤖<br/>AI Model"]

    DATA --> ML
    AI_DATA  -.->|"🚫"| ML
    ML --> AI

    linkStyle 1 stroke:#c00,stroke-width:2px
```

#### Examples

**Filtering whole resources.** The [Observation with AI-asserted security labels](Observation-glasgow.html) carries the `AIAST` label at the resource level. A consumer that cannot tolerate AI-influenced data filters it out by inspecting `meta.security`; a consumer that can tolerate it keeps it.

**Filtering at element granularity.** The [DiagnosticReport with inline AI security labels](DiagnosticReport-f202.html) tags only the AI-asserted elements. A consumer can drop the AI-asserted `conclusion` while still using the rest of the report, rather than discarding the whole resource.

> **Tags are hints, not proof.** Because `meta.security` is optional, the absence of a label does not guarantee that AI was not involved. For authoritative filtering, a consumer would also check for a [Provenance](#process-utilizing-ai) on the resource. Labeling makes the common case cheap; Provenance makes it certain.

### Use Case 3: Discovery of output from an AI model determined to be problematic

While an AI model is in use, it may later be determined to be producing poor or unsafe output. When that happens, one needs to **find every resource that model touched** so those resources can be reviewed.

Because AI-influenced data links back to the AI through `Provenance.agent.who` (a reference to the AI `Device`) — and may also reference the `Device` directly (e.g. `Observation.device`) — the problematic model becomes a single point from which all of its output can be traced.

> **Discovery makes no judgment about the data.** Identifying data produced by a model that was *later* found to be problematic does **not** mean that data is wrong. It only identifies the data that may warrant review.

```mermaid
sequenceDiagram
    participant AI as AI Model<br/>(Device/TheAI)
    participant S as FHIR Server
    actor R as Reviewer / QA

    Note over AI,S: Production — over time the model writes output to the server
    AI->>S: Create resource + AIProvenance (agent = Device/TheAI)
    AI->>S: Create resource + AIProvenance (agent = Device/TheAI)
    AI->>S: ... more outputs over time

    Note over AI,R: ⚠️ Device/TheAI is later determined to be problematic

    Note over AI,R: Discovery
    R->>S: GET /Provenance?agent=Device/TheAI
    S-->>R: Provenance records authored by Device/TheAI
    R->>S: Resolve each Provenance.target
    S-->>R: Suspect resources (Observation, Procedure, ClaimResponse, ...)
    Note over R: Resources flagged for review — not judged invalid
```

#### Example

Suppose [the AI System](Device-TheAI.html) (`Device/TheAI`) is found to be problematic. Several artifacts in this guide reference it, so a single search surfaces them all:

- `GET /Provenance?agent=Device/TheAI` returns the Provenance records that name it as an agent — including the [AI-authored Lab Observation](Provenance-AI-Contributed.html), the [AI-authored Procedure element](Provenance-AI-Authored-Element.html), the [AI-generated Lab Results](Provenance-AI-Generated-Lab-Results.html), and the [prior-authorization determination](Provenance-AI-PriorAuth-Provenance.html). Resolving each `Provenance.target` yields the suspect resources.
- `GET /Observation?device=Device/TheAI` finds resources that reference the Device directly, even where a Provenance is not present.

Discovery also **discriminates between models**. A separate [second AI system](Device-TheOtherAI.html) (`Device/TheOtherAI`) authored [its own Observation](Observation-other-model-result.html); because that work is tied to a different `Device`, the search for `Device/TheAI` correctly does *not* return it. Only data tied to the problematic model is flagged.

### Use Case 4: Discovery of output resulting from inputs determined to be problematic

Just as a model can later be found problematic, so can an **input**. Inputs — the [context](requirements.html#context-of-ai-usage) provided to the AI, such as a prompt or a source document — are recorded as `Provenance.entity`. If an input is later determined to be flawed, every output derived from it can be traced and reviewed.

> As with Use Case 3, this discovery **makes no judgment about the validity** of the outputs. It only identifies the data that may warrant review.

```mermaid
sequenceDiagram
    participant C as Input / Context<br/>(e.g. DocumentReference)
    participant AI as AI Model
    participant S as FHIR Server
    actor R as Reviewer / QA

    Note over C,S: Production — the input drives AI output written to the server
    C->>AI: Provide context (source document / prompt)
    AI->>S: Create output + AIProvenance (entity = the input)
    C->>AI: Input reused on another request
    AI->>S: Create output + AIProvenance (entity = the input)

    Note over C,R: ⚠️ The input is later determined to be flawed

    Note over C,R: Discovery
    R->>S: GET /Provenance?entity=DocumentReference/Lab-Results-PDF
    S-->>R: Provenance records that used the flawed input
    R->>S: Resolve each Provenance.target
    S-->>R: Suspect outputs (Bundle, Patient, Observation, ...)
    Note over R: Outputs flagged for review — not judged invalid
```

#### Examples

**A flawed source document.** The [Lab Results PDF](DocumentReference-Lab-Results-PDF.html) is the source input recorded by the [Provenance of the AI-generated Lab Results](Provenance-AI-Generated-Lab-Results.html). If that source is later found to be unreliable, `GET /Provenance?entity=DocumentReference/Lab-Results-PDF` surfaces the Provenance, whose `target` is the generated Bundle of Patient and Observation resources. Because the input is recorded as a shared, externally referenced resource, the search finds every Provenance — and therefore every output — that used it.

**A flawed prompt.** The same pattern applies when the flawed input is a prompt. The [Input Prompt to create a Patient](DocumentReference-Input-Prompt-create-patient.html) is recorded as an entity by the [Provenance of creating a Patient from that prompt](Provenance-AI-generated-patient-resource.html); resolving that Provenance's `target` yields the Patient the AI generated. In this particular example the prompt is carried *inline* (a contained resource within the Provenance), so it is discovered while examining the Provenance rather than by an independent reference search — recording a prompt as a shared, externally referenced DocumentReference makes it directly searchable like the source document above.



TODO

### Process Utilizing AI

AI Models do not exist in a vacuum, in addition to the context / inputs, there needs to be a system that calls the AI, supplies the inputs, and gets the result. This result may then be used as-is, supplied to another AI, verified by an automated system, verified by a human, or any number of other activities. Understanding this process may be very important to end users and downstream systems. For example, if the results of the AI were verified by a human (human-in-the-loop) then an end user may be able to rely on the results with less scrutiny.

>💡 Tip
>
> Use when all possible factors are important to record. This level of Observability Factor is very comprehensive, and as such is very verbose. This level of Observability Factor capturing may not be justified beyond initial model use, while shaking out the use.

Some of the process elements that may be captured are:

- **Human-in-the-loop:** This is when a human verifies the results of an AI output. This can add validity to those results. It can be captured in Provenance as that person is another author of the resulting resource or element.
- **Guardrails:** An automated system is engaged to check the results of the AI. This system can take many different forms. It is often intended to reduce bias, ensure more equitable healthcare outcomes, catch unacceptable outputs, such as inappropriate word usage, or do general validation, such as running a FHIR validator on the resource to ensure conformity. This can be captured as additional Devices as authors on the Provenance.  
- **Other AI or Systems:** Sometimes the AI may call subroutines called tools. These tools may do things like simple math, API calls, or web searches. This is often done using MCP. Additional, multiple AI systems maybe involved. Agenetic systems often involve multiple AI Agents who call each other using protocols like A2A. These workflows are complex to capture, but one suggestion is to use BPMN contained in DocumentReferences linked to the Provenance (example coming...).

#### Process Examples


##### Full Process example

[This is a full example](Provenance-AI-full-lorem-ipsum.html) of how to capture the AI process in FHIR.

- Two outputs that this Provenance resource is documenting:
  - an Observation resource (e.g., lab result)
    - with Observation.interpretation being attributed to this Provenance
  - a CarePlan resource (e.g., follow-up care plan)
- Two agents
  - a verifier (human) who verifies the AI output
  - an author (AI system) who generated the output
- Two entities that were clinical resources provided to the AI system
  - a DocumentReference resource (e.g., patient summary)
  - an Observation resource (e.g., lab result)
- One entity that is a PlanDefinition resource (e.g., care plan definition)
- One entity that is the AI Input Prompt
  - Where the Input Prompt is a DocumentReference resource that contains the input prompt provided to the AI system.
  - Where the Input Prompt is a contained resource in the Provenance resource.
  - Where the Input Prompt is associated with the clinician which provided it

### PDF interpreted by AI into FHIR

This is an additional example provided that shows how this IG can be applied.

Use Case: A provider receives a [PDF of lab result(s)](DocumentReference-Lab-Results-PDF.html) for a patient. This PDF is examined by an AI which generates a [Bundle with a Patient resource and Observation resource(s)](Bundle-b3c1f2d4-5c8e-4b0a-9f6d-7c8e1f2d4b5c.html).

In the attached example the patient's name is Alton Walsh and the lab test is an HbA1C. All the FHIR resources in the bundle have been created by the AI, so they would be tagged accordingly.

- [Provenance of AI Generated Lab Results](Provenance-AI-Generated-Lab-Results.html)
- 