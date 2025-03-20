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