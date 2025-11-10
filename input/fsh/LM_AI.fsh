


Instance: Note-ModelCard
InstanceOf: AIDevice
Title: "Device with Model-Card in Device.note.text"
Description: """
A Device that has a Model-Card.
Given that it is understood that ModelCards are Markdown, this could simply go into the .note.
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = AIdeviceTypeCS#Artificial-Intelligence
* extension[aiKind].valueCodeableConcept = AIdeviceTypeCS#Large-Language-Models
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
Description: "This CodeSystem contains codes for the DocumentReference.type and DocumentReference.category that indicate that the DocumentReference is a Model-Card."
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #AIModelCard "AI Model-Card" "DocumentReference containing a Model-Card describing an AI system"
* #AIInputPrompt "AI Input Prompt" "Input Prompt for AI Model"
* #AImodelCardMarkdownFormat "Markdown Format" "Hugging Face Model-Card in Markdown format"
* #AImodelCardCHAIformat "CHAI Format" "Model-Card in CHAI format (Coalition for Health AI)"

// TODO: Should have an invariant to ensure that if type is AIModelCard, then at least one category is present indicating the format, and that the content agrees with that format.
//Invariant: mc-1
//Description: "A DocumentReference of type AI Model-Card must have at least one category that indicates the format of the Model-Card, and that must agree with the content."
//Expression: "type.coding.where(system='AImodelCardCS' and code='AIModelCard').exists()"
//Expression: "DocumentReference.type = 'AImodelCardCS#AIModelCard' implies (DocumentReference.category.exists(c | c = 'AImodelCardCS#AIInputPrompt') and (DocumentReference.content.exists(cnt | cnt.attachment.contentType = 'text/markdown') or DocumentReference.content.exists(cnt | cnt.attachment.contentType = 'application/xml')))"
//Severity: #warning // to support other Model-Cards in the future

Profile: AIModelCard
Parent: DocumentReference
Id: AI-ModelCard
Title: "AI Model-Card DocumentReference"
Description: "A DocumentReference that contains a Model-Card describing an AI system."
* type 1..1 MS
* type.coding ^slicing.discriminator.type = #value
* type.coding ^slicing.discriminator.path = "$this"
* type.coding ^slicing.rules = #closed
* type.coding contains AImodelCard 1..* MS
* type.coding[AImodelCard] = AImodelCardCS#AIModelCard "AI Model-Card"
//* obeys mc-1
* category 1..* MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "$this"
* category ^slicing.rules = #open
* category contains 
  AImodelCard 1..* MS and 
  AImodelCardMD 0..1 MS and 
  AImodelCardCHAI 0..1 MS
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* category[AImodelCardMD] = AImodelCardCS#AImodelCardMarkdownFormat "Markdown Format"
* category[AImodelCardCHAI] = AImodelCardCS#AImodelCardCHAIformat "CHAI Format"
* content ^slicing.discriminator.type = #value
* content ^slicing.discriminator.path = "attachment.contentType"
* content ^slicing.rules = #open
* content contains 
  MarkdownFormat 0..1 and 
  CHAIformat 0..1
* content[MarkdownFormat].attachment.contentType 1..1 MS
* content[MarkdownFormat].attachment.contentType = #text/markdown (exactly)
* content[MarkdownFormat].attachment.data 0..1 MS
  * ^comment = "The model-card in Markdown base64-encoded text format"
* content[MarkdownFormat].attachment.url 0..1 MS
  * ^comment = "The model-card in Markdown as a URL"
* content[CHAIformat].attachment.contentType 1..1 MS
* content[CHAIformat].attachment.contentType = #application/xml (exactly)
* content[CHAIformat].attachment.data 0..1 MS
  * ^comment = "The model-card in CHAI format base64-encoded"
* content[CHAIformat].attachment.url 0..1 MS
  * ^comment = "The model-card in CHAI as a URL"
* identifier 0..* MS
* description 0..1 MS 
  * ^comment = "The model-card in markdown format that is not base64-encoded for human readability"

Instance: ModelCard-sample-huggingface-attached
InstanceOf: AIModelCard
Title: "DocumentReference Model-Card in HuggingFace Markdown format attached"
Description: "An example of a Model-Card DocumentReference that contains the Model-Card in YAML and Markdown formats.Using an example from HuggingFace."
Usage: #example
* status = #current
/* would like to use the ig-loader, but it doesn't understand .md files
* content.attachment.id = "ig-loader-sample_datasetcard_simple.txt"
 note that ig-loader fills out the rest of the attachment.
*/
* content[MarkdownFormat].attachment.data =   "LS0tDQpsYW5ndWFnZToNCi0gZW4NCmxpY2Vuc2U6DQotIGJzZC0zLWNsYXVzZQ0KYW5ub3RhdGlvbnNfY3JlYXRvcnM6DQotIGNyb3dkc291cmNlZA0KLSBleHBlcnQtZ2VuZXJhdGVkDQpsYW5ndWFnZV9jcmVhdG9yczoNCi0gZm91bmQNCm11bHRpbGluZ3VhbGl0eToNCi0gbW9ub2xpbmd1YWwNCnNpemVfY2F0ZWdvcmllczoNCi0gbjwxSw0KdGFza19jYXRlZ29yaWVzOg0KLSBpbWFnZS1zZWdtZW50YXRpb24NCnRhc2tfaWRzOg0KLSBzZW1hbnRpYy1zZWdtZW50YXRpb24NCnByZXR0eV9uYW1lOiBTYW1wbGUgU2VnbWVudGF0aW9uDQotLS0NCg0KIyBEYXRhc2V0IENhcmQgZm9yIFNhbXBsZSBTZWdtZW50YXRpb24NCg0KVGhpcyBpcyBhIHNhbXBsZSBkYXRhc2V0IGNhcmQgZm9yIGEgc2VtYW50aWMgc2VnbWVudGF0aW9uIGRhdGFzZXQu"

* content[MarkdownFormat].attachment.contentType = #text/markdown
* type = AImodelCardCS#AIModelCard "AI Model-Card"
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* category[AImodelCardMD] = AImodelCardCS#AImodelCardMarkdownFormat "Markdown Format"
* identifier.system = "https://github.com/huggingface/huggingface_hub/tree/main/tests/fixtures/cards"
* identifier.value = "sample_datasetcard_simple.md"

Instance: ModelCard-sample-CHAI-web
InstanceOf: AIModelCard
Title: "DocumentReference Model-Card in CHAI format from web"
Description: "An example of a Model-Card DocumentReference that contains the Model-Card in CHAI format. Where the Model-Card is referenced from the CHAI GitHub repository."
Usage: #example
* status = #current
* content[CHAIformat].attachment.url = "https://github.com/coalition-for-health-ai/mc-schema/blob/main/v0.1/examples/Aidoc_ICH-02-RT.xml"
* content[CHAIformat].attachment.contentType = #application/xml
* content[+].attachment.url = "https://github.com/coalition-for-health-ai/mc-schema/blob/main/v0.1/examples/Aidoc_ICH-02-RT.pdf"
* content[=].attachment.contentType = #application/pdf
* type = AImodelCardCS#AIModelCard "AI Model-Card"
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* category[AImodelCardCHAI] = AImodelCardCS#AImodelCardCHAIformat "CHAI Format"
* identifier.system = "https://github.com/coalition-for-health-ai/mc-schema/blob/main/v0.1/examples/"
* identifier.value = "Aidoc_ICH-02-RT.xml"


Instance: ModelCard-sample-CHAI-attached
InstanceOf: AIModelCard
Title: "DocumentReference Model-Card in CHAI format attached"
Description: "An example of a Model-Card DocumentReference that contains the Model-Card in CHAI format. Where the Model-Card is attached.

Note: This is not functioning at this time due to problems with IG Publisher and attachments using the ig-loader where the contentType is specified. When it is specified the ig-loader will not work, but we need it to be specified to meet our profile and slicing requirements."
Usage: #example
* status = #current
* content[+].attachment.id = "ig-loader-Aidoc_ICH-02-RT.xml"
//* content[CHAIformat].attachment.contentType = #application/xml
* content[+].attachment.id = "ig-loader-Aidoc_ICH-02-RT.pdf"
//* content[=].attachment.contentType = #application/pdf
* type = AImodelCardCS#AIModelCard "AI Model-Card"
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* category[AImodelCardCHAI] = AImodelCardCS#AImodelCardCHAIformat "CHAI Format"
* identifier.system = "https://github.com/coalition-for-health-ai/mc-schema/blob/main/v0.1/examples/"
* identifier.value = "Aidoc_ICH-02-RT.xml"

Instance: ModelCard-sample-CHAI-binary
InstanceOf: AIModelCard
Title: "DocumentReference Model-Card in CHAI format binary"
Description: "An example of a Model-Card DocumentReference that contains the Model-Card in CHAI format. Where the Model-Card is attached using Binary resources."
Usage: #example
* status = #current
* content[CHAIformat].attachment.url = "Binary/ModelCard-sample-CHAI-binary-xml"
* content[CHAIformat].attachment.contentType = #application/xml
* content[+].attachment.url = "Binary/ModelCard-sample-CHAI-binary-pdf"
* content[=].attachment.contentType = #application/pdf
* type = AImodelCardCS#AIModelCard "AI Model-Card"
* category[AImodelCard] = AImodelCardCS#AIInputPrompt "AI Input Prompt"
* category[AImodelCardCHAI] = AImodelCardCS#AImodelCardCHAIformat "CHAI Format"
* identifier.system = "https://github.com/coalition-for-health-ai/mc-schema/blob/main/v0.1/examples/"
* identifier.value = "Aidoc_ICH-02-RT.xml"

Instance: ModelCard-sample-CHAI-binary-xml
InstanceOf: Binary
Title: "Binary example using Binary of xml"
Description: "Example of the CHAI example xml using Binary."
* contentType = #application/xml
* data = "ig-loader-Aidoc_ICH-02-RT.xml"

Instance: ModelCard-sample-CHAI-binary-pdf
InstanceOf: Binary
Title: "Binary example using Binary of pdf"
Description: "Example of the CHAI example pdf using Binary."
* contentType = #application/pdf
* data = "ig-loader-Aidoc_ICH-02-RT.pdf"

Extension: ModelCardDescription
Id: aitransparency.modelCardDescription
Title: "Model-Card"
Description: "When the Device is described by a Model-Card, this extension can be used to reference the Model-Card."
* ^context[+].type = #element
* ^context[=].expression = "Device"
* value[x] only Reference(AIModelCard) 
* valueReference 1..1

Instance: Attached-ModelCard
InstanceOf: AIDevice
Title: "Device with attached Model-Card"
Description: """
A Device that has an attached Model-Card.
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = AIdeviceTypeCS#Artificial-Intelligence
* extension[aiKind].valueCodeableConcept = AIdeviceTypeCS#Large-Language-Models
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"
* extension[modelCardDescription].valueReference = Reference(DocumentReference/ModelCard-sample-huggingface-attached)



Profile: AIDevice 
Parent: Device
Id: AI-device
Title: "AI Device"
Description: """
A Device that represents an AI system, such as a Large Language Model (LLM) or other AI model. This profile includes a recommended set of codes for Device.type to indicate the type of AI system. The extension AIKind is used to specify the more specific kind(s) of AI technology and techniques employed by the AI system. The extension ModelCardDescription is used to reference a Model-Card that is always used with the AI system.
"""
* identifier MS
  * ^comment = "Identifier for the AI system, such as a client ID from an EHR system"
* type 1..1
* type = AIdeviceTypeCS#Artificial-Intelligence
* extension contains AIKind named aiKind 0..*
* extension contains ModelCardDescription named modelCardDescription 0..*
  * ^comment = "Reference to a Model-Card that is always used"
* manufacturer MS
* manufactureDate MS
* deviceName MS
* modelNumber MS
* version MS
* owner MS
* contact MS
* url MS
* note MS
* safety MS

Extension: AIKind
Id: aitransparency.AIKind
Title: "Specific kind of AI technology"
Description: "Expresses the more specific kind(s) of AI technology and techniques."
* ^context[+].type = #element
* ^context[=].expression = "Device"
* value[x] only CodeableConcept
* valueCodeableConcept 1..1
* valueCodeableConcept from AIdeviceTypeVS (extensible)

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
* #AI-By-Scenario "Classification by Application Scenario" "This category classifies AI systems based on their application scenarios in the medical field."
  * #Intelligent-Diagnosis-and-Treatment "Intelligent Diagnosis and Treatment" "By analyzing massive volumes of medical data, these AI systems assist doctors in making more accurate diagnostic and treatment decisions."
  * #Medical-Image-Analysis "Medical Image Analysis" "Leveraging deep learning technologies, these AI tools automatically identify lesion areas in medical images."
  * #Personalized-Treatment "Personalized Treatment" "These AI systems create precise patient profiles to formulate personalized treatment plans."
  * #Drug-Discovery-and-Development "Drug Discovery and Development" "AI in this category accelerates the screening of candidate drugs and optimizes the design of clinical trials."
  * #Medical-Quality-Control "Medical Quality Control" "These AI tools are used to generate standardized medical document templates and detect defects in medical documents and images."
  * #Patient-Services "Patient Services" "AI systems here provide patients with services such as intelligent medical guidance, symptom self-assessment, and medical consultation."
* #AI-By-DataType "Classification by Processed Data Type" "This category classifies AI systems based on the types of medical data they primarily process."
  * #AI-for-Medical-Imaging-Data "AI for Medical Imaging Data" "It mainly processes medical imaging data such as X-rays, MRIs, and CT scans."
  * #AI-for-Physiological-Signal-Data "AI for Physiological Signal Data" "This type of AI deals with physiological signal data like electrocardiograms (ECG) and electroencephalograms (EEG)."
  * #AI-for-Medical-Text-Data "AI for Medical Text Data" "It processes text data such as electronic health records (EHRs) and medical abstracts."
* #AI-By-Model "Classification by Technical Model" "This category classifies AI systems based on the underlying technical models they employ."
  * #Machine-Learning-Models "c Learning Models" "They include supervised learning models (e.g., Support Vector Machines (SVM), Random Forests (RF)), which can be used for disease classification and risk prediction; unsupervised learning models (e.g., K-means clustering), which can discover hidden characteristics of patient subgroups; and reinforcement learning models, which can be applied in dynamic treatment plan management."
  * #Deep-Learning-Models "Deep Learning Models" "Examples include Convolutional Neural Networks (CNNs), which perform excellently in medical image analysis; Recurrent Neural Networks (RNNs) and their variant LSTMs, which are suitable for processing time-series physiological signal data; Generative Adversarial Networks (GANs), which can be used to synthesize training data and alleviate the scarcity of medical data; and Transformer models, which are widely used in multiple tasks such as medical imaging, text analysis, and physiological signal prediction."
  * #Large-Language-Models "Large Language Models" "These models, such as GPT-4 and PaLM, are trained on massive text datasets and can perform various natural language processing tasks, including medical text understanding, generation, and question answering."
  * #Hybrid-Models "Hybrid Models" "These models combine multiple AI techniques to leverage their respective strengths. For instance, combining CNNs and RNNs can effectively process medical image sequences; integrating machine learning and deep learning models can enhance disease prediction accuracy; and combining rule-based systems with machine learning can improve interpretability and reliability in clinical decision support."
  * #Other-AI-Models "Other AI Models" "This category includes other AI models not covered above, such as graph neural networks (GNNs) for modeling complex relationships in medical data, and evolutionary algorithms for optimizing treatment plans."
* #Artificial-Intelligence "All kinds of Artificial Intelligence" "Any type of Artificial Intelligence system, undifferentiated."
