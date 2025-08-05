
This markdown is just explaination of the examples. The audience for this page is the sub-committee members, and not the general reader.

## Tagging

Tagging is a gross level tagging. It does not attempt to include information on the AI, model, prompt, timestamp, or any detail on input given to the AI or how the AI output was used.

Tagging uses simple codeSystem vocabulary. There is one code defined already today in HL7 Terminology: `AIAST`

Discussion has indicated that a few more codes might be useful. For this we create a local [codeSystem](CodeSystem-AddedProvenanceCS.html) to allow us to experiment. Eventually useful codes would be proposed to HL7 Terminology (THO). For example `AIAST` does not indicate if a clinician was involved in the use of the AI, or reviewed the output of the AI. 

## Provenance

Provenance is a Resource in FHIR that is designed to support full concept of Provenance. In the case of AI, the Provenance can carry far more detail about how the AI was used, which AI was used, what input parameters it was given, what came out, and how was that used to create or update resources.

### Resource level

As with tagging, a Provenance can point at a whole Resource. In this way one can carry details in the Provenance, such as what AI was used and how.

- [Provenance of AI authored Lab Observation](Provenance-AI-Contributed.html)

### Element within a Resource

Provenance can be just about some elements within a Resource. This is a normal part of Provenance, but it is important for AI use-cases.

- [Provenance of AI Authored Procedure.followup.text](Provenance-AI-Authored-Element.html)

### Defining the AI

An AI is defined using the Device resource. The Device resource is defined in FHIR to be much broader than physical devices, and specifically includes software, and thus AI. Thus an AI would be identified by some kind of identifier, manufacture, type, version, web location, etc.

- [The AI System](Device-TheAI.html)

This example is not defined more than any software might be.

#### Using Model-Card

The AI community is defining standards for describing an AI model. This is a Model Card. The Model Card is a combination of YAML that defines in codeable terms the details, and a Markdown that describes it in narrative. Given that Markdown can carry YAML, the overall object is Markdown.

Example Model Card from https://github.com/huggingface/huggingface_hub/tree/main/tests/fixtures/cards

Here is an example given:

```markdown
---
language:
- en
license:
- bsd-3-clause
annotations_creators:
- crowdsourced
- expert-generated
language_creators:
- found
multilinguality:
- monolingual
size_categories:
- n<1K
task_categories:
- image-segmentation
task_ids:
- semantic-segmentation
pretty_name: Sample Segmentation
---

# Dataset Card for Sample Segmentation

This is a sample dataset card for a semantic segmentation dataset.
```

##### Simply put the Model-Card markdown into the note.text of the Device.

One choice is to just put that Markdown Model-Card into the Device.note.text element. This is not wrong from the definition of that element, but it may not be obvious to one looking at the Device resource that there is meaning to the markdown given.

- [Device with Model-Card in Device.note.text](Device-Note-ModelCard.html)

##### Attachment for the Model-Card

One could encode the Model-Card in a resource designed for carrying any mime-type, the DocumentReference. To make this more clear and searchable we define a [codeSystem](CodeSystem-AImodelCardCS.html) that has some codes to be used to identify that the DocumentReference is specifically an AI Model Card or an AI Input Prompt

- [DocumentReference Model-Card](DocumentReference-ModelCard-sample-datasetcard-simple.html)
- [Extension for including the Model-Card in a Device](StructureDefinition-aitransparency.modelCardDescription.html)
- [Device with attached Model-Card](Device-Attached-ModelCard.html)

### Using Input Prompt

One useful thing to record is the Input Prompt given to the AI. This input prompt can be very important to the output, and the interpretation of the output. The Input Prompt is recorded as an attachment, using the DocumentReference, and using a code as defined above

- [Input Prompt lorem ipsum](DocumentReference-Input-Prompt-lorem-ipsum.html)
- [Input Prompt to create a Patient](DocumentReference-Input-Prompt-create-patient.html)

The first example is just showing the encapsulating mechanism. The Second example is a prompt that might be used to have the AI create a given Patient resource that meets the input requirements.

- [Provenance of creating a Patient from Input Prompt](Provenance-AI-generated-patient-resource.html)
- [Patient resource created](Patient-a1b2c3d4-e5f6-7890-abcd-ef1234567890.html)

### Full Provenance example

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

Use Case: A provider receives a [PDF of lab result(s)](DocumentReference-Lab-Results-PDF.html) for a patient. This PDF is examined by an AI which generates a [Bundle with a Patient resource and Observation resource(s)](Bundle-b3c1f2d4-5c8e-4b0a-9f6d-7c8e1f2d4b5c.html).

In the attached example the patient's name is Alton Walsh and the lab test is an HbA1C. All the FHIR resources in the bundle have been created by the AI, so they should be tagged accordingly.

- [Provenance of AI Generated Lab Results](Provenance-AI-Generated-Lab-Results.html)

TODO: Note, the validator found some syntax and semantic errors in the json that I had to fix manually
