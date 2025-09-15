Logical: ModelCard
Parent: Base
Id: ModelCard
Characteristics: #can-be-target
Title: "AI Model Card"
Description: "An AI model card is a document that provides a standardized overview of an artificial intelligence model's purpose, performance, intended usage, and limitations. `ModelCard` could be a subset of the HuggingFace model card specification: https://huggingface.co/docs/hub/model-card-annotated."

* id 0..1 SU string "model card identifier"
* name 0..1 SU string "model card title"
* description 0..1 string "Basic details about the model." "This includes the architecture, version, if it was introduced in a paper, if an original implementation is available, and the creators. Any copyright should be attributed here. General information about training procedures, parameters, and important disclaimers can also be mentioned in this section."
* type 0..1 code "model type" "You can name the “type” as: 1 = Supervision/Learning Method, 2 = Machine Learning Type, 3 = Modality"
* appliedIn 0..* Reference(Resource) "FHIR resource where the model was used if it was AI-generated"



/* John Comments

- Why would we not just save the Model Card YAML as YAML, and the Model Card Markdown as Markdown?  We are a standards organization, we should use the standards defined by that community. 
- Or recognize that the Model Card is a mashup of the yaml format inside the markdown format with horizontal rules demarking the yaml, thus only needing one as markdown.
  - for this we would profile DocumentReference. 
  - DocumentReference.content[0].contentType = "text/yaml" for the YAML, and 
  - DocumentReference.content[1].contentType = "text/markdown" for the Markdown.
  - The other core elements of DocumentReference would need to be profiled as well to enable discovery and retrieval of the Model Card.
  - DocumentReference.identifier would be used to identify the Model Card model_id.
  - DocumentReference .type and .category would identify this as a Model Card.
  - DocumentReference.author could be the Developed by
  - ...etc
  - Most of the other details we should not replicate, as the DocumentReference would contain the Model Card, and their format should be preferred.
- The appliedIn element is not in the direction for RESTful references. Those data would point at this Model Card, not the other way around. These reverse references are just as possible to traverse as forward references, so they are not needed. And updating the Model Card for all the data that is generated would not be scalable.
- unclear what type element is identifying.


Example Model Card from https://github.com/huggingface/huggingface_hub/tree/main/tests/fixtures/cards

-- see the attachment folder ---

I do find other examples that are PDF, and not in markdown or having yaml in them. (like the CHAI Applied Model Card)

*/


Instance: Note-ModelCard
InstanceOf: AIdevice
Title: "Device with Model-Card in Device.note.text"
Description: """
A Device that has a Model Card.
Given that it is understood that ModelCards are Markdown, this could simply go into the .note.
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = AIdeviceTypeCS#Large-Language-Models
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"
* note.time = "2023-10-01T00:00:00Z"
* note.text = """
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
"""

CodeSystem: AImodelCardCS
Title: "Added DocumentReference.code for AI ModelCard"
Description: "This CodeSystem contains codes for the DocumentReference.type and DocumentReference.category that indicate that the DocumentReference is a Model Card."
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #AIModelCard "AI Model Card"
* #AIInputPrompt "AI Input Prompt"


Instance: ModelCard-sample-datasetcard-simple
InstanceOf: DocumentReference
Title: "DocumentReference Model-Card"
Description: "An example of a Model Card DocumentReference that contains the model card in YAML and Markdown formats.

using example from HuggingFace.
"
Usage: #example
* status = #current
/* would like to use the ig-loader, but it doesn't understand .md files
* content.attachment.id = "ig-loader-sample_datasetcard_simple.txt"
 note that ig-loader fills out the rest of the attachment.
*/
* content.attachment.data =   "LS0tDQpsYW5ndWFnZToNCi0gZW4NCmxpY2Vuc2U6DQotIGJzZC0zLWNsYXVzZQ0KYW5ub3RhdGlvbnNfY3JlYXRvcnM6DQotIGNyb3dkc291cmNlZA0KLSBleHBlcnQtZ2VuZXJhdGVkDQpsYW5ndWFnZV9jcmVhdG9yczoNCi0gZm91bmQNCm11bHRpbGluZ3VhbGl0eToNCi0gbW9ub2xpbmd1YWwNCnNpemVfY2F0ZWdvcmllczoNCi0gbjwxSw0KdGFza19jYXRlZ29yaWVzOg0KLSBpbWFnZS1zZWdtZW50YXRpb24NCnRhc2tfaWRzOg0KLSBzZW1hbnRpYy1zZWdtZW50YXRpb24NCnByZXR0eV9uYW1lOiBTYW1wbGUgU2VnbWVudGF0aW9uDQotLS0NCg0KIyBEYXRhc2V0IENhcmQgZm9yIFNhbXBsZSBTZWdtZW50YXRpb24NCg0KVGhpcyBpcyBhIHNhbXBsZSBkYXRhc2V0IGNhcmQgZm9yIGEgc2VtYW50aWMgc2VnbWVudGF0aW9uIGRhdGFzZXQu"

* content.attachment.contentType = #text/markdown
* type = AImodelCardCS#AIModelCard "AI Model Card"
* category = AImodelCardCS#AIModelCard "AI Model Card"
* identifier.system = "https://github.com/huggingface/huggingface_hub/tree/main/tests/fixtures/cards"
* identifier.value = "sample_datasetcard_simple.md"

Extension: ModelCardDescription
Id: aitransparency.modelCardDescription
Title: "Model Card"
Description: "When the Device is described by a Model Card, this extension can be used to reference the Model Card."
* ^context[+].type = #element
* ^context[=].expression = "Device"
* value[x] only Reference(DocumentReference) 
* valueReference 1..1

Instance: Attached-ModelCard
InstanceOf: AIdevice
Title: "Device with attached Model-Card"
Description: """
A Device that has an attached Model Card.
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = AIdeviceTypeCS#Large-Language-Models
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"
* extension[+].url = Canonical(aitransparency.modelCardDescription)
* extension[=].valueReference.reference = "DocumentReference/ModelCard-sample-datasetcard-simple"



Profile: AIdevice 
Parent: Device
Id: AI-device
Title: "AI Device"
Description: "A Device that represents an AI system, such as a Large Language Model (LL
M) or other AI model. This profile includes a recommended set of codes for Device.type to indicate the type of AI system."
* type from AIdeviceTypeVS



ValueSet: AIdeviceTypeVS
Title: "Recommended Device.type codes for AI/LLM"
Description:  "Subset from HL7, plus those defined here"
* ^experimental = false
* codes from system AIdeviceTypeCS


CodeSystem: AIdeviceTypeCS
Title: "Added Device.type for AI/LLM"
Description: "This CodeSystem contains codes for the Device.type that indicate that the Device is an AI/LLM."
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* ^hierarchyMeaning = #grouped-by
* #AI-By-Scenario "Classification by Application Scenario"
  * #Intelligent-Diagnosis-and-Treatment "Intelligent Diagnosis and Treatment" "By analyzing massive volumes of medical data, these AI systems assist doctors in making more accurate diagnostic and treatment decisions."
  * #Medical-Image-Analysis "Medical Image Analysis" "Leveraging deep learning technologies, these AI tools automatically identify lesion areas in medical images."
  * #Personalized-Treatment "Personalized Treatment" "These AI systems create precise patient profiles to formulate personalized treatment plans."
  * #Drug-Discovery-and-Development "Drug Discovery and Development" "AI in this category accelerates the screening of candidate drugs and optimizes the design of clinical trials."
  * #Medical-Quality-Control "Medical Quality Control" "These AI tools are used to generate standardized medical document templates and detect defects in medical documents and images."
  * #Patient-Services "Patient Services" "AI systems here provide patients with services such as intelligent medical guidance, symptom self-assessment, and medical consultation."
* #AI-By-DataType "Classification by Processed Data Type"
  * #AI-for-Medical-Imaging-Data "AI for Medical Imaging Data" "It mainly processes medical imaging data such as X-rays, MRIs, and CT scans."
  * #AI-for-Physiological-Signal-Data "AI for Physiological Signal Data" "This type of AI deals with physiological signal data like electrocardiograms (ECG) and electroencephalograms (EEG)."
  * #AI-for-Medical-Text-Data "AI for Medical Text Data" "It processes text data such as electronic health records (EHRs) and medical abstracts."
* #AI-By-Model "Classification by Technical Model"
  * #Machine-Learning-Models "Machine Learning Models" "They include supervised learning models (e.g., Support Vector Machines (SVM), Random Forests (RF)), which can be used for disease classification and risk prediction; unsupervised learning models (e.g., K-means clustering), which can discover hidden characteristics of patient subgroups; and reinforcement learning models, which can be applied in dynamic treatment plan management."
  * #Deep-Learning-Models "Deep Learning Models" "Examples include Convolutional Neural Networks (CNNs), which perform excellently in medical image analysis; Recurrent Neural Networks (RNNs) and their variant LSTMs, which are suitable for processing time-series physiological signal data; Generative Adversarial Networks (GANs), which can be used to synthesize training data and alleviate the scarcity of medical data; and Transformer models, which are widely used in multiple tasks such as medical imaging, text analysis, and physiological signal prediction."
  * #Large-Language-Models "Large Language Models" "These models, such as GPT-4 and PaLM, are trained on massive text datasets and can perform various natural language processing tasks, including medical text understanding, generation, and question answering."
  * #Hybrid-Models "Hybrid Models" "These models combine multiple AI techniques to leverage their respective strengths. For instance, combining CNNs and RNNs can effectively process medical image sequences; integrating machine learning and deep learning models can enhance disease prediction accuracy; and combining rule-based systems with machine learning can improve interpretability and reliability in clinical decision support."
  * #Other-AI-Models "Other AI Models" "This category includes other AI models not covered above, such as graph neural networks (GNNs) for modeling complex relationships in medical data, and evolutionary algorithms for optimizing treatment plans."
