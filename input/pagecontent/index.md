
### Background

Artificial Intelligence (AI) has amazing potential to improve outcomes in healthcare. However, it comes with a number of challenges, such as bias, hallucinations, and non-determinism. In order to support responsible usage of AI, it is necessary to establish standards for documenting and tracking when health data has been created, updated, or otherwise influenced by AI. In particular, it is useful to know when a Fast Healthcare Interoperable Resource (FHIR) resource has been inferred, in whole or part, by an AI, such as Generative AI / Large Language Model (LLM).  

This FHIR Implementation Guide (IG) provides guidance for representing the usage of AI in influencing FHIR resources. Starting with how to tag FHIR resources, and expanding into how to use Provenance, Device, and other data elements, this FHIR IG provides standards that enable downstream use cases to identify such resources. This allows the informed usage of AI-inferred health data.

### Scope

The purpose of this project is to enable observability for the use of AI algorithms in the production or manipulation of health data, thus enabling transparency for users of the data to determine the relevance, validity, applicability, and suitability of the data.

The purpose of the implementation guide is to provide a method for sharing data about the use of AI algorithms in the production or manipulation of health data. It is not the intent of this project to endorse, validate, or invalidate the use of these AI algorithms or the resulting data. Although the project intends to create infrastructure for reporting observability, it is not the intent of this project to provide the governance for transparency reporting expectations.

In this project, AI algorithm is defined broadly to include any computer-based logic that touches health data in a way that might change the understanding of the data downstream. Some examples include: an algorithm that attempts summarize clinical notes, an algorithm that attempts to interpret medical images, an algorithm that attempts to identify medical concepts within a clinical note, an algorithm used to generate synthetic health data, and so on. Some computer-based logic that touches health data, such as simple calculations and data transformations, may not be considered to be AI algorithms but observability of such events should also be supported by this implementation guide.

### Assumptions and Caveats

This IG assumes that health data are being represented in FHIR. While it is recognized that other standards, such as HL7 CDA and HL7 v2, may be used, this IG does not yet support them. Future work may seek to applying the Use-Cases and Observability Factors to these other standards.

### Credits

* Sam Schifman (Vantiq)
* John Moehrke (Moehrke Research LLC)
* May Terry (MITRE)
* Brian Alper (Computable Publishing)
* Michael Faughn (NIST)
* Gregory Shemancik (CHAI)
* Reynalda Davis (CMS)
* Gail Winters
* Mark Kramer (MITRE)

### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Intellectual Property Considerations

{% include ip-statements.xhtml %}

### Globals Profiles

{% include globals-table.xhtml %}

### Dependencies

{% include dependency-table.xhtml %}