
### Background

Artificial Intelligence (AI) has amazing potential to improve outcomes in healthcare. However, it comes with a number of challenges, such as bias, hallucinations, and non-determinism. In order to support responsible usage of AI, it is necessary to establish standards for documenting and tracking when health data has been created, updated, or otherwise produced or manipulated by AI. In particular, it is useful to know when a Fast Healthcare Interoperability Resources (FHIR) has been produced or manipulated, in whole or part, by an AI, such as Generative AI / Large Language Model (LLM).

This FHIR Implementation Guide (IG) provides guidance for representing the usage of AI in influencing FHIR resources. Starting with how to tag FHIR resources, and expanding into how to use Provenance, Device, and other data elements, this FHIR IG provides standards that enable downstream use cases to identify such resources. This allows the informed usage of AI produced or manipulated health data.

### Scope

The purpose of the implementation guide is to enable observability for the use of AI in the production or manipulation of health data represented in FHIR. It provides a method for sharing data about the use of AI algorithms in the production or manipulation of health data represented in FHIR, thus enabling transparency for users of the data to determine the relevance, validity, applicability, and suitability of the data. It is not the intent of this project to endorse, validate, or invalidate the use of these AI algorithms or the resulting data. Although the project intends to create infrastructure for reporting observability, it is not the intent of this project to provide the governance for transparency reporting expectations, or the detection or inference of AI involvement.

In this project, AI algorithm is defined broadly to include any computer-based logic that touches health data in a way that might impact the confidence in the data downstream. This IG does not make a strict distinction between clearly AI, and non-AI algorithms. It is up to those that use this guide to make that distinction relative to their use of algorithms / AI. Some examples include: an algorithm that attempts to summarize clinical notes, an algorithm that attempts to interpret medical images, an algorithm that attempts to identify medical concepts within a clinical note, an algorithm used to generate synthetic health data, and so on. Some computer-based logic that touches health data, such as simple calculations and data transformations, may not be considered to be AI algorithms but observability of such events should also be supported by this implementation guide.

### Assumptions and Caveats

This IG assumes that health data are being represented in FHIR. While it is recognized that other standards, such as HL7 CDA and HL7 v2, may be used, this IG does not yet support them. Future work may seek to apply the Use-Cases and Observability Factors to these other standards.

This guide does not define how AI use is determined. Determination of AI involvement is assumed to be made by the system or application producing or modifying the FHIR resource. Assertions of AI involvement expressed using this guide are declarative statements made by the producing system.
