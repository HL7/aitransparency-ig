
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

The purpose of this project is to provide observability into the use of AI algorithms in the production or manipulation of health data. This is with the goal of making it possible for downstream systems to make informed decisions about the data and when/how to use it. It is not the intent of this project to endorse, validate, or invalidate the use of these AI algorithms or the resulting data.

Observability has multiple levels. At the highest level it just means tagging data that has been touched by an AI algorithm. Below that is a level of exposing the nature of the algorithm. Another level is exposing what specifically was done to the data. For example, what field within the data was touched and how. And then there is a level of understanding the overall process involved. For example, did a human review the output from the AI algorithm, often called human-in-the-loop. Each of these levels has sub-levels. For example, exposing the nature of the algorithm could be as high-level as saying simply if the algorithm is deterministic or non-deterministic, i.e. is there any randomness involved in the algorithm. It could then go further to identify the field, such as Generative AI, and even go to the name and version of the model used. This project will take an incremental approach to these levels, scoping first to the top level and working down over time.
As stated, validation or invalidation of AI or the results produced is not in scope for this project. This project only seeks to provide visibility. Further, validity of the data provided is not in scope. For example, this project will not attempt to define a method for digital signing the data to ensure that the AI model indicated is in fact the AI model used or a method to ensure the human-in-the-loop’s identity.

In this project, AI algorithm is defined broadly to include any computer-based logic that touches health data in a way that might change the understanding of the data downstream. Some examples include: an algorithm that attempts summarize clinical notes, an algorithm that attempts to interpret medical images, an algorithm that attempts to identify medical concepts within a clinical note, an algorithm used to generate synthetic health data, and so on. Again, the project will take an iterative approach and each use case may fall in different levels of observability for this project.


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