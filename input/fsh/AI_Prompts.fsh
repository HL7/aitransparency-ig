/* assuming that the Provenance needs to include
- The resources provided to the AI
- The prompt provided to the AI
- The output of the AI
- The AI does have a model card
*/


Instance: AI-full-lorem-ipsum
InstanceOf: AIProvenance
Title: "Provenance for AI with Model Card, input, and output"
Description: """
A Provenance resource that captures the full AI process, including the model card, input, and output.

This is a full example of how to capture the AI process in FHIR.

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
"""
Usage: #example
* target[+].reference = "http://server.example.org/fhir/Observation/14"
* target[=].extension.url = "http://hl7.org/fhir/StructureDefinition/targetPath"
* target[=].extension.valueString = "Observation.interpretation"
* target[+].reference = "http://server.example.org/fhir/CarePlan/19"
* occurredDateTime = "2023-10-01T00:00:00Z"
* recorded = "2023-10-01T00:00:00Z"
* policy = "http://example.org/policies/ai-authorized-CDS"
* reason[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier "Verifier"
* agent[=].who.reference = "http://server.example.org/fhir/Practitioner/pract"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/Note-ModelCard)
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#source "Source"
* entity[=].what.reference = "http://server.example.org/fhir/documentreference/patient-cda-summary"
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#source "Source"
* entity[=].what.reference = "http://server.example.org/fhir/Observation/patient-lab-result"
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#derivation "Derivation"
* entity[=].what.reference = "http://server.example.org/fhir/PlanDefinition/plan-definition-example"
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#quotation "Quotation"
* contained[+] = Input-Prompt-lorem-ipsum
* entity[=].what = Reference(Input-Prompt-lorem-ipsum)
* entity[=].agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* entity[=].agent[=].who.reference = "http://server.example.org/fhir/Practitioner/pract"


Instance: Input-Prompt-lorem-ipsum
InstanceOf: AIModelCard
Title: "Input Prompt DocumentReference lorem ipsum"
Description: """
A DocumentReference that contains the input prompt provided to the AI system. -- Lorem ipsum text is used as a placeholder.

```
Generate a lorem ipsum text to serve as placeholder copy for use in design, development, and publishing. 

1. Specify the exact amount of text or the number of paragraphs required (e.g., 1 paragraph, 3 paragraphs, etc.). 
2. Create the lorem ipsum text using a classic style or introduce slight variations while keeping the nonsensical nature to suit the requested length. 

Ensure that the text maintains a good balance between readability and the traditional lorem ipsum style, giving a realistic impression of how the text will impact the overall layout and design.

# Output Format
- Provide a continuous block of lorem ipsum text corresponding to the specified amount needed.
```
"""
Usage: #example
* status = #current
* content.attachment.data =   "R2VuZXJhdGUgYSBsb3JlbSBpcHN1bSB0ZXh0IHRvIHNlcnZlIGFzIHBsYWNlaG9sZGVyIGNvcHkgZm9yIHVzZSBpbiBkZXNpZ24sIGRldmVsb3BtZW50LCBhbmQgcHVibGlzaGluZy4gCgoxLiBTcGVjaWZ5IHRoZSBleGFjdCBhbW91bnQgb2YgdGV4dCBvciB0aGUgbnVtYmVyIG9mIHBhcmFncmFwaHMgcmVxdWlyZWQgKGUuZy4sIDEgcGFyYWdyYXBoLCAzIHBhcmFncmFwaHMsIGV0Yy4pLiAKMi4gQ3JlYXRlIHRoZSBsb3JlbSBpcHN1bSB0ZXh0IHVzaW5nIGEgY2xhc3NpYyBzdHlsZSBvciBpbnRyb2R1Y2Ugc2xpZ2h0IHZhcmlhdGlvbnMgd2hpbGUga2VlcGluZyB0aGUgbm9uc2Vuc2ljYWwgbmF0dXJlIHRvIHN1aXQgdGhlIHJlcXVlc3RlZCBsZW5ndGguIAoKRW5zdXJlIHRoYXQgdGhlIHRleHQgbWFpbnRhaW5zIGEgZ29vZCBiYWxhbmNlIGJldHdlZW4gcmVhZGFiaWxpdHkgYW5kIHRoZSB0cmFkaXRpb25hbCBsb3JlbSBpcHN1bSBzdHlsZSwgZ2l2aW5nIGEgcmVhbGlzdGljIGltcHJlc3Npb24gb2YgaG93IHRoZSB0ZXh0IHdpbGwgaW1wYWN0IHRoZSBvdmVyYWxsIGxheW91dCBhbmQgZGVzaWduLgoKIyBPdXRwdXQgRm9ybWF0Ci0gUHJvdmlkZSBhIGNvbnRpbnVvdXMgYmxvY2sgb2YgbG9yZW0gaXBzdW0gdGV4dCBjb3JyZXNwb25kaW5nIHRvIHRoZSBzcGVjaWZpZWQgYW1vdW50IG5lZWRlZC4="

* content.attachment.contentType = #text/markdown
* type = AImodelCardCS#AIModelCard "AI Model Card"
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* description = """
Generate a lorem ipsum text to serve as placeholder copy for use in design, development, and publishing. 

1. Specify the exact amount of text or the number of paragraphs required (e.g., 1 paragraph, 3 paragraphs, etc.). 
2. Create the lorem ipsum text using a classic style or introduce slight variations while keeping the nonsensical nature to suit the requested length. 

Ensure that the text maintains a good balance between readability and the traditional lorem ipsum style, giving a realistic impression of how the text will impact the overall layout and design.

# Output Format
- Provide a continuous block of lorem ipsum text corresponding to the specified amount needed.
"""



Instance: AI-generated-patient-resource
InstanceOf: AIProvenance
Title: "Provenance for AI created Patient resource"
Description: """
A Provenance resource that captures the full AI process, including the model card, input, and output.

This is a full example of how to capture the AI process in FHIR.

- One output that this Provenance resource is documenting:
    - an Patient resource 
- Two agents
    - a verifier (human) who verifies the AI output
    - an author (AI system) who generated the output
- One entity that is the AI Input Prompt
    - Where the Input Prompt is a DocumentReference resource that contains the input prompt provided to the AI system.
    - Where the Input Prompt is a contained resource in the Provenance resource.
    - Where the Input Prompt is associated with the clinician which provided it
"""
Usage: #example
* target[+] = Reference(Patient/a1b2c3d4-e5f6-7890-abcd-ef1234567890)
* occurredDateTime = "2025-06-18T00:00:00Z"
* recorded = "2025-06-18T00:00:00Z"
* policy = "http://example.org/policies/ai-authorized-patient-generation"
* reason[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier "Verifier"
* agent[=].who.reference = "http://server.example.org/fhir/Practitioner/pract"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/Note-ModelCard)
* contained[+] = Input-Prompt-create-patient
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#quotation "Quotation"
* entity[=].what = Reference(Input-Prompt-create-patient)
* entity[=].agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* entity[=].agent[=].who.reference = "http://server.example.org/fhir/Practitioner/pract"





Instance: Input-Prompt-create-patient
InstanceOf: AIModelCard
Title: "Input Prompt DocumentReference to create a patient"
Description: """
A DocumentReference that contains the input prompt provided to the AI system. -- to generate a Patient resource.

```
System Prompt

You are a healthcare data specialist that converts natural language patient information into valid FHIR Patient resources. Your task is to extract relevant patient demographics and create a well-formed FHIR Patient resource that is fully conformant with FHIR US Core 6.1.0 specifications.

Requirements:

- Generate valid JSON that conforms to FHIR R4 Patient resource structure
- Ensure compliance with US Core Patient Profile (US Core 6.1.0)
- Include all required US Core elements when data is available
- Use appropriate FHIR data types and value sets
- Generate a unique resource ID using UUID format
- Apply proper FHIR coding systems and terminologies
- Handle missing data appropriately (omit optional fields when data unavailable)
- Use standard US address formatting
- Apply proper date formatting (YYYY-MM-DD)
- Include appropriate extensions when necessary for US Core compliance

US Core 6.1.0 Patient Profile Requirements:

- Must include: identifier, name, gender, birthDate
- Should include: address, telecom, race, ethnicity when available
- Use US Core extensions for race and ethnicity
- Follow US postal address conventions
- Use appropriate terminologies (e.g., HL7 AdministrativeGender, OMB race categories)

Data Mapping Guidelines:

- Extract patient name and structure as HumanName with family/given components
- Map gender terms to FHIR AdministrativeGender codes (male, female, other, unknown)
- Convert birth dates to FHIR date format
- Structure addresses using Address data type with appropriate use codes
- Map race/ethnicity information using US Core extensions with appropriate OMB codes
- Generate medical record number as primary identifier when not provided
- Include meta.profile reference to US Core Patient profile

Output Format:

- Provide only the valid FHIR JSON resource without additional commentary or explanation.

User Prompt

- Convert the following patient information into a FHIR Patient resource conformant with US Core 6.1.0:

`Jane Doe is a white female born on November 15, 1950. She lives at 123 Main Street, Anytown, Michigan, zipcode 12345.`
```
"""
Usage: #example 
* status = #current
* content.attachment.data =   "R2VuZXJhdGUgYSBsb3JlbSBpcHN1bSB0ZXh0IHRvIHNlcnZlIGFzIHBsYWNlaG9sZGVyIGNvcHkgZm9yIHVzZSBpbiBkZXNpZ24sIGRldmVsb3BtZW50LCBhbmQgcHVibGlzaGluZy4gCgoxLiBTcGVjaWZ5IHRoZSBleGFjdCBhbW91bnQgb2YgdGV4dCBvciB0aGUgbnVtYmVyIG9mIHBhcmFncmFwaHMgcmVxdWlyZWQgKGUuZy4sIDEgcGFyYWdyYXBoLCAzIHBhcmFncmFwaHMsIGV0Yy4pLiAKMi4gQ3JlYXRlIHRoZSBsb3JlbSBpcHN1bSB0ZXh0IHVzaW5nIGEgY2xhc3NpYyBzdHlsZSBvciBpbnRyb2R1Y2Ugc2xpZ2h0IHZhcmlhdGlvbnMgd2hpbGUga2VlcGluZyB0aGUgbm9uc2Vuc2ljYWwgbmF0dXJlIHRvIHN1aXQgdGhlIHJlcXVlc3RlZCBsZW5ndGguIAoKRW5zdXJlIHRoYXQgdGhlIHRleHQgbWFpbnRhaW5zIGEgZ29vZCBiYWxhbmNlIGJldHdlZW4gcmVhZGFiaWxpdHkgYW5kIHRoZSB0cmFkaXRpb25hbCBsb3JlbSBpcHN1bSBzdHlsZSwgZ2l2aW5nIGEgcmVhbGlzdGljIGltcHJlc3Npb24gb2YgaG93IHRoZSB0ZXh0IHdpbGwgaW1wYWN0IHRoZSBvdmVyYWxsIGxheW91dCBhbmQgZGVzaWduLgoKIyBPdXRwdXQgRm9ybWF0Ci0gUHJvdmlkZSBhIGNvbnRpbnVvdXMgYmxvY2sgb2YgbG9yZW0gaXBzdW0gdGV4dCBjb3JyZXNwb25kaW5nIHRvIHRoZSBzcGVjaWZpZWQgYW1vdW50IG5lZWRlZC4="

* content.attachment.contentType = #text/markdown
* type = AImodelCardCS#AIModelCard "AI Model Card"
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* description = """
System Prompt

You are a healthcare data specialist that converts natural language patient information into valid FHIR Patient resources. Your task is to extract relevant patient demographics and create a well-formed FHIR Patient resource that is fully conformant with FHIR US Core 6.1.0 specifications.

Requirements:

- Generate valid JSON that conforms to FHIR R4 Patient resource structure
- Ensure compliance with US Core Patient Profile (US Core 6.1.0)
- Include all required US Core elements when data is available
- Use appropriate FHIR data types and value sets
- Generate a unique resource ID using UUID format
- Apply proper FHIR coding systems and terminologies
- Handle missing data appropriately (omit optional fields when data unavailable)
- Use standard US address formatting
- Apply proper date formatting (YYYY-MM-DD)
- Include appropriate extensions when necessary for US Core compliance

US Core 6.1.0 Patient Profile Requirements:

- Must include: identifier, name, gender, birthDate
- Should include: address, telecom, race, ethnicity when available
- Use US Core extensions for race and ethnicity
- Follow US postal address conventions
- Use appropriate terminologies (e.g., HL7 AdministrativeGender, OMB race categories)

Data Mapping Guidelines:

- Extract patient name and structure as HumanName with family/given components
- Map gender terms to FHIR AdministrativeGender codes (male, female, other, unknown)
- Convert birth dates to FHIR date format
- Structure addresses using Address data type with appropriate use codes
- Map race/ethnicity information using US Core extensions with appropriate OMB codes
- Generate medical record number as primary identifier when not provided
- Include meta.profile reference to US Core Patient profile

Output Format:

- Provide only the valid FHIR JSON resource without additional commentary or explanation.

User Prompt

- Convert the following patient information into a FHIR Patient resource conformant with US Core 6.1.0:

`Jane Doe is a white female born on November 15, 1950. She lives at 123 Main Street, Anytown, Michigan, zipcode 12345.`
"""


