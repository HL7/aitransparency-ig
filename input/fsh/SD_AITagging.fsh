// Extension for tagging

// Extension: AIResourceTag
// Id: ai-resource-tag
// Title: "AI label - FHIR resource level"
// Description: "A tag or label that identifies whether the FHIR resource was generated using an AI algorithm or AI-driven logic."
// Context: Resource
// // TO DO: add constraint in Resource.meta
// * value[x] only code
// * value[x] 0..1 MS
// * value[x] from ProvenanceVS (required) 

// Extension: AIElementTag
// Id: ai-element-tag
// Title: "AI label - FHIR data element level"
// Description: "A tag or label that identifies whether the a specific data element within a FHIR resource was generated using an AI algorithm or AI-driven logic."
// Context: Element
// * value[x] only code
// * value[x] 0..1 MS
// * value[x] from ProvenanceVS (required) 