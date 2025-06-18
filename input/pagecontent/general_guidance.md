### Observability Levels

Observability Factors for FHIR AI Representation

| 1: Tagging | 2: Model(s) | 3: Data sources | 4. Process (human-machine-interaction) |
|------------|-------------|-----------------|----------------------------------------|
| Tagging data influenced by AI<br><br>• resource-level<br>• field / element -level | Describing the characteristics of the model:<br><br>• Name and version of the AI algorithm / model<br>• algorithm deterministic vs. non-deterministic vs. hybrid<br><br>• Training set data<br>• Working memory | • Request input (to AI)<br>  ○ e.g.: Patient data<br><br>• Reference input<br>  ○ e.g.: clinical guidelines<br><br>• Operations<br>  ○ Model Context Protocol (MCP)<br>  ○ Agent to Agent (A2A)<br><br>• Data quality<br>• Data qualification | • Provenance - indicating<br>  ○ multiple actors, including the human<br>  ○ role<br><br>• Bias reduction strategies<br>  ○ e.g.: MCP to redirect to a controlled terminology corpus<br>  ○ tie back to Provenance |

#### Summary of Observability Factors

#### 1: Tagging
**Tagging data influenced by AI**: Marks healthcare data at resource or field level to identify AI involvement in generation or modification.

**Resource-level**: Tags entire FHIR resources (e.g., Patient, Observation) when AI contributed to their creation or content.

**Field/element-level**: Tags specific data elements within resources where AI influenced individual values or recommendations.

#### 2: Model(s)
**Describing the characteristics of the model**: Documents AI system properties including identification, algorithm type, and operational parameters.

**Name and version of AI algorithm/model**: Identifies specific AI system used, including version numbers for reproducibility and accountability.

**Algorithm deterministic vs. non-deterministic vs. hybrid**: Categorizes AI behavior predictability affecting consistency and reliability of outputs.

**Training set data**: Documents datasets used to train AI models, affecting bias, accuracy, and applicability.

**Working memory**: Describes AI system's active memory and context retention capabilities during operation.

#### 3: Data sources
**Request input (to AI)**: Patient-specific data provided to AI systems for processing, analysis, or decision support.

**Reference input**: External knowledge sources like clinical guidelines that inform AI decision-making processes.

**Operations**: Technical protocols governing AI system interactions, including Model Context Protocol and Agent-to-Agent communications.

**Data quality**: Assessment of input data completeness, accuracy, and reliability affecting AI system performance.

**Data qualification**: Validation and certification processes ensuring data meets standards for AI system use.

#### 4: Process (human-machine-interaction)
**Provenance - indicating multiple actors and role**: Tracks all contributors (human and AI) and their specific roles in data creation.

**Bias reduction strategies**: Methods to minimize AI bias, including controlled terminology and provenance linking for accountability.