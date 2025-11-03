
Alias: $sct = http://snomed.info/sct
Alias: $v2-0074 = http://terminology.hl7.org/CodeSystem/v2-0074
Alias: $loinc = http://loinc.org
Alias: $codes = http://example.org/codes
Alias: $v3-ObservationInterpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation
Alias: $organization-type = http://terminology.hl7.org/CodeSystem/organization-type
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v2-0131 = http://terminology.hl7.org/CodeSystem/v2-0131

/*
AIAST "Artificial Intelligence asserted" is a security label that indicates that the AI system has asserted the content of the resource or element. 
This means not just contributed to the resource, but also that the AI system has made a determination about the validity of the content.

This is different from an AI Contributed label, which would indicates that the AI system has contributed to the resource, but not claiming it is valid.

The distinction between Contribution and Assertion is not clear -- https://jira.hl7.org/browse/FHIR-51021

TODO: Might need to add AIRPT code to THO. 

*/

CodeSystem: AddedProvenanceCS
Title: "Added Provenance Codes"
Description: "This CodeSystem contains codes for the provenance indications used in .meta.security and elsewhere that indicate that the AI system has been involved."
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #AIRPT "AI Reported" "Indicates that the content was reported by an AI system."
* #CLINAST_AIRPT "Clinician Asserted from AI Reported" "Indicates that a clinician has reviewed and asserted the content that was originally reported by an AI system."
* #AIAST_CLINRPT "AI Asserted from Clinician Reported" "Indicates that the content was asserted by an AI system based on clinician reported information."

ValueSet: ProvenanceVS
Title: "Recommended provenance codes"
Description:  "Subset from HL7, plus those defined here"
* ^experimental = false
* codes from system AddedProvenanceCS
* http://terminology.hl7.org/CodeSystem/v3-ObservationValue|4.0.0#AIAST "Artificial Intelligence asserted"
* http://terminology.hl7.org/CodeSystem/v3-ObservationValue|4.0.0#CLINAST "clinician asserted"
* http://terminology.hl7.org/CodeSystem/v3-ObservationValue|4.0.0#CLINRPT "clinician reported"


// This profile can't be used in an IG, but could be used in validator checks -- https://chat.fhir.org/#narrow/channel/179166-implementers/topic/.E2.9C.94.20Profiling.20abstract.20.28Domain.29Resource.20.2F.20.20Profile.20inheritance/with/481901358
Profile: AIdata
Parent: DomainResource
Id: AI-data
Title: "AI Data"
Description: "A resource that captures the input and output data used by an AI model in generating or enhancing FHIR resources."
* meta.security ^slicing.discriminator.type = #value
* meta.security ^slicing.discriminator.path = "$this"
* meta.security ^slicing.rules = #open
* meta.security contains AItags 1..*
* meta.security[AItags] from ProvenanceVS

//========Example of Resource Level tagging ===  


Instance: glasgow
InstanceOf: Observation
Title: "Example Observation with AI Assisted security labels"
Description: """
This observation is derived from FHIR Core R4 Observation id **glasgow**. 
This use contains a Glasgow Coma Scale observation with **Artificial Intelligence asserted** security labels for the whole Resource.

Note that the example I took, I assumed was a good one for AIAST. But I am not sure that it is, especially since the outcome is not well coded, using ucum score values.

Note that there is no .performer as that element can't hold a Device, and we are modeling this as being wholely authored by the AI. Thus I use the extension alternate-reference.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST "Artificial Intelligence asserted"
* status = #final
* code = $loinc#9269-2 "Glasgow coma score total"
* code.text = "Glasgow Coma Scale , (GCS)"
* subject.reference = "http://server.example.org/fhir/Patient/example"
* effectiveDateTime = "2014-12-11T04:44:16Z"
* valueQuantity = 13 '{score}'
* referenceRange[0].high = 8 '{score}'
* referenceRange[=].type.text = "Severe TBI"
* referenceRange[+].low = 9 '{score}'
* referenceRange[=].high = 12 '{score}'
* referenceRange[=].type.text = "Moderate TBI"
* referenceRange[+].low = 13 '{score}'
* referenceRange[=].type.text = "Mild TBI"
* component[0].code = $loinc#9268-4 "Glasgow coma score motor"
* component[=].code.text = "GCS Motor"
* component[=].valueCodeableConcept.coding[0] = $codes#5 "Localizes painful stimuli"
* component[=].valueCodeableConcept.coding[+].extension.url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
* component[=].valueCodeableConcept.coding[=].extension.valueDecimal = 5
* component[=].valueCodeableConcept.coding[=] = $loinc#LA6566-9 "Localizing pain"
* component[=].valueCodeableConcept.text = "5 (Localizes painful stimuli)"
* component[+].code = $loinc#9270-0 "Glasgow coma score verbal"
* component[=].code.text = "GSC Verbal"
* component[=].valueCodeableConcept.coding[0] = $codes#4 "Confused, disoriented"
* component[=].valueCodeableConcept.coding[+].extension.url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
* component[=].valueCodeableConcept.coding[=].extension.valueDecimal = 4
* component[=].valueCodeableConcept.coding[=] = $loinc#LA6560-2 "Confused"
* component[=].valueCodeableConcept.text = "4 (Confused, disoriented)"
* component[+].code = $loinc#9267-6 "Glasgow coma score eye opening"
* component[=].code.text = "Eyes"
* component[=].valueCodeableConcept.coding[0] = $codes#4 "Opens eyes spontaneously"
* component[=].valueCodeableConcept.coding[+].extension.url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
* component[=].valueCodeableConcept.coding[=].extension.valueDecimal = 4
* component[=].valueCodeableConcept.coding[=] = $loinc#LA6556-0 "Eyes open spontaneously"
* component[=].valueCodeableConcept.text = "4 (Opens eyes spontaneously)"
* performer.extension[0].url = "http://hl7.org/fhir/StructureDefinition/alternate-reference"
* performer.extension[0].valueReference = Reference(Device/TheAI)
* performer.display = "AI System (TheAI)"

//==================================== Example of Element Level tagging 

Instance: DiagnosticeReport-Instance-for-f202-1
InstanceOf: DiagnosticReport
Title: "DiagnosticReport with Inline AI Security Labels"
Description: """
This DiagnosticeReport is derived from FHIR Core R4 DiagnosticReport id **f202**. 
This use contains a DiagnosticReport with inline Artificial Intelligence asserted security labels for the conclusion and conclusionCode, 
as well as a ServiceRequest.

- The DiagnosticReport is tagged with the security label `PROCESSINLINELABEL`, to indicate that there is inline security labeling.
- The `DiagnosticReport.conclusion` and `DiagnosticReport.conclusionCode` elements are tagged with the Artificial Intelligence asserted security label `AIAST`.
"""
Usage: #example
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#PROCESSINLINELABEL "process inline security label"
* id = "f202"
* basedOn.reference = "http://server.example.org/fhir/ServiceRequest/req"
* status = #final
* category.coding[0] = $sct#15220000 "Laboratory test"
* category.coding[+] = $v2-0074#LAB
* code = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"
* subject.reference = "http://server.example.org/fhir/Patient/example"
* issued = "2013-03-11T10:28:00+01:00"
* performer.reference = "http://server.example.org/fhir/Organization/f201"
* result.reference = "http://server.example.org/fhir/Observation/f206"
* conclusion = "Blood culture tested positive on staphylococcus aureus"
* conclusion.extension[0].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-inline-sec-label"
* conclusion.extension[0].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST "Artificial Intelligence asserted"
* conclusionCode = $sct#428763004 "Staphylococcus aureus bacteraemia"
* conclusionCode.extension[0].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-inline-sec-label"
* conclusionCode.extension[0].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST "Artificial Intelligence asserted"


