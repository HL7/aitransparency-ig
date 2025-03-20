
### Background

Transparency is necessary to establish standards for documenting and tracking the use of outputs from AI systems or inference algorithms, including generative Artificial Intelligence (AI) and Large Language Models (LLMs), within FHIR resources and operations.

AI represents amazing potential to improve outcomes in healthcare. However, it comes with a number of challenges, such as it is generally probabilistic in nature, can be influence by bias, and can suffer from hallucinations. It is critical that we provide guidance for how to tag data coming from AI in a way that it can be used responsibly by downstream systems and users.

This FHIR Implementation Guide (IG) aims to define standard methods for representing the use of generative AI and LLMs in FHIR resources and operations. The IG will address two main areas:

#### AI Content Transparency

Define guidance on representing inferences from AI within FHIR resources, including, but not limited to, use of existing fields, extensions, and recommended codes. Thus insuring consistent representations that downstream systems can rely on to utilize the data appropriately, including:

* Model identification and versioning to meet mandatory disclosure requirements
* Generation timestamps and context to support documentation of human oversight
* Confidence scores and uncertainty measures aligned with performance transparency requirements
* Human review status and modifications to demonstrate appropriate clinical oversight
* Model limitations and potential biases documentation to ensure safety
* Training data characteristics and demographic representation to address bias monitoring requirements
* Patient-accessible metadata supporting information access requirements

#### AI Operations Framework

Define standard patterns for representing FHIR operations that use AI/LLMs, including:

* Operation definitions and parameters that enable standardized API access to AI. 
* Traceability to source data used to make the inference, for example the specific clinical note used as input for the model.
* Input validation requirements supporting safety and effectiveness monitoring
* Output formatting and metadata aligned with transparency and documentation requirements
* Error handling and confidence thresholds to support real-world performance monitoring
* Audit trail requirements enabling oversight and monitoring
* Integration patterns for existing patient access mechanisms required by information blocking rules
* Real-world performance monitoring capabilities supporting safety surveillance requirements
* Guidance for filtering resources based on risk tolerance of the downstream use case


### Scope

* Examples

### Assumptions and Caveats

* TBD

### Credits

* TBD

### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Intellectual Property Considerations

{% include ip-statements.xhtml %}

### Globals Profiles

{% include globals-table.xhtml %}

### Dependencies

{% include dependency-table.xhtml %}