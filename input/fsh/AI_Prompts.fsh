/* assuming that the Provenance needs to include
- The resources provided to the AI
- The prompt provided to the AI
- The output of the AI
- The AI does have a model card
*/


Instance: Provenance-AI-full
InstanceOf: Provenance
Title: "Provenance for AI with Model Card, input, and output"
Description: """
A Provenance resource that captures the full AI process, including the model card, input, and output.

This is a full example of how to capture the AI process in FHIR.

- Two outputs that this Provenance resource is documenting:
    - an Observation resource (e.g., lab result)
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
    - Where the Input Prompt is associated with the AI Device to which it was provided
"""
Usage: #example
* target[+].reference = "http://example.org/fhir/Observation/14"
* target[+].reference = "http://example.org/fhir/CarePlan/19"
* occurredDateTime = "2023-10-01T00:00:00Z"
* recorded = "2023-10-01T00:00:00Z"
* policy = "http://example.org/policies/ai-authorized-CDS"
* reason[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier "Verifier"
* agent[=].who.reference = "http://example.org/fhir/Practitioner/pract"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/Device-ModelCard)
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#source "Source"
* entity[=].what.reference = "http://example.org/fhir/documentreference/patient-cda-summary"
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#source "Source"
* entity[=].what.reference = "http://example.org/fhir/Observation/patient-lab-result"
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#derivation "Derivation"
* entity[=].what.reference = "http://example.org/fhir/PlanDefinition/plan-definition-example"
* entity[+].role = http://terminology.hl7.org/CodeSystem/provenance-entity-role#quotation "Quotation"
* contained[+] = Input-Prompt
* entity[=].what = Reference(Input-Prompt)
* entity[=].agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* entity[=].agent[=].who = Reference(Device/Device-ModelCard)


Instance: Input-Prompt
InstanceOf: DocumentReference
Title: "Input Prompt DocumentReference"
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
Usage: #inline 
* status = #current
* content.attachment.data =   "R2VuZXJhdGUgYSBsb3JlbSBpcHN1bSB0ZXh0IHRvIHNlcnZlIGFzIHBsYWNlaG9sZGVyIGNvcHkgZm9yIHVzZSBpbiBkZXNpZ24sIGRldmVsb3BtZW50LCBhbmQgcHVibGlzaGluZy4gCgoxLiBTcGVjaWZ5IHRoZSBleGFjdCBhbW91bnQgb2YgdGV4dCBvciB0aGUgbnVtYmVyIG9mIHBhcmFncmFwaHMgcmVxdWlyZWQgKGUuZy4sIDEgcGFyYWdyYXBoLCAzIHBhcmFncmFwaHMsIGV0Yy4pLiAKMi4gQ3JlYXRlIHRoZSBsb3JlbSBpcHN1bSB0ZXh0IHVzaW5nIGEgY2xhc3NpYyBzdHlsZSBvciBpbnRyb2R1Y2Ugc2xpZ2h0IHZhcmlhdGlvbnMgd2hpbGUga2VlcGluZyB0aGUgbm9uc2Vuc2ljYWwgbmF0dXJlIHRvIHN1aXQgdGhlIHJlcXVlc3RlZCBsZW5ndGguIAoKRW5zdXJlIHRoYXQgdGhlIHRleHQgbWFpbnRhaW5zIGEgZ29vZCBiYWxhbmNlIGJldHdlZW4gcmVhZGFiaWxpdHkgYW5kIHRoZSB0cmFkaXRpb25hbCBsb3JlbSBpcHN1bSBzdHlsZSwgZ2l2aW5nIGEgcmVhbGlzdGljIGltcHJlc3Npb24gb2YgaG93IHRoZSB0ZXh0IHdpbGwgaW1wYWN0IHRoZSBvdmVyYWxsIGxheW91dCBhbmQgZGVzaWduLgoKIyBPdXRwdXQgRm9ybWF0Ci0gUHJvdmlkZSBhIGNvbnRpbnVvdXMgYmxvY2sgb2YgbG9yZW0gaXBzdW0gdGV4dCBjb3JyZXNwb25kaW5nIHRvIHRoZSBzcGVjaWZpZWQgYW1vdW50IG5lZWRlZC4="

* content.attachment.contentType = #text/plain
* type = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* category = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* description = """
Generate a lorem ipsum text to serve as placeholder copy for use in design, development, and publishing. 

1. Specify the exact amount of text or the number of paragraphs required (e.g., 1 paragraph, 3 paragraphs, etc.). 
2. Create the lorem ipsum text using a classic style or introduce slight variations while keeping the nonsensical nature to suit the requested length. 

Ensure that the text maintains a good balance between readability and the traditional lorem ipsum style, giving a realistic impression of how the text will impact the overall layout and design.

# Output Format
- Provide a continuous block of lorem ipsum text corresponding to the specified amount needed.
"""
