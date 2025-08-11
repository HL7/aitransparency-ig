
### Background

Transparency is necessary to establish standards for documenting and tracking the use of outputs from AI systems or inference algorithms, including generative Artificial Intelligence (AI) and Large Language Models (LLMs), within FHIR resources and operations.

AI represents amazing potential to improve outcomes in healthcare. However, it comes with a number of challenges, such as it is generally probabilistic in nature, can be influenced by bias, and can suffer from hallucinations. It is critical that we provide guidance for how to tag data coming from AI in a way that it can be used responsibly by downstream systems and users.

This FHIR Implementation Guide (IG) defines standard methods for representing the use of generative AI and LLMs in FHIR resources. <!-- The IG addresses two main areas: -->

<!-- #### AI Content Transparency -->

It defines guidance on representing inferences from AI within FHIR resources, including, but not limited to, use of existing fields, extensions, and recommended codes. Thus insuring consistent representations that downstream systems can rely on to utilize the data appropriately, including:

* Model identification and versioning to meet mandatory disclosure requirements
* Generation timestamps and context to support documentation of human oversight
* Confidence scores and uncertainty measures aligned with performance transparency requirements
* Human review status and modifications to demonstrate appropriate clinical oversight
* Model limitations and potential biases documentation to ensure safety
* Training data characteristics and demographic representation to address bias monitoring requirements
* Patient-accessible metadata supporting information access requirements

<!-- 
Note: the following is out of scope for now.

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
-->

### Scope

The purpose of this project is to enable observability for the use of AI algorithms in the production or manipulation of health data, thus enabling transparency for users of the data to determine the relevance, validity, applicability, and suitability of the data.

The purpose of the implementation guide is to provide a method for sharing data about the use of AI algorithms in the production or manipulation of health data. It is not the intent of this project to endorse, validate, or invalidate the use of these AI algorithms or the resulting data. Although the project intends to create infrastructure for reporting observability, it is not the intent of this project to provide the governance for transparency reporting expectations.

In this project, AI algorithm is defined broadly to include any computer-based logic that touches health data in a way that might change the understanding of the data downstream. Some examples include: an algorithm that attempts summarize clinical notes, an algorithm that attempts to interpret medical images, an algorithm that attempts to identify medical concepts within a clinical note, an algorithm used to generate synthetic health data, and so on. Some computer-based logic that touches health data, such as simple calculations and data transformations, may not be considered to be AI algorithms but observability of such events should also be supported by this implementation guide.


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