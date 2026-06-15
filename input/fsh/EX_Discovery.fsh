/*
Use Case 3 (discovery of output from a problematic AI model):
    To show that discovery can DISCRIMINATE between models, this file adds a second, unrelated
    AI system (Device/TheOtherAI) and an Observation it authored.

    When a reviewer later determines that Device/TheAI is problematic and searches for everything
    it produced (e.g. GET /Provenance?agent=Device/TheAI), the output below authored by
    Device/TheOtherAI is correctly NOT returned — only data tied to the problematic model is found.
*/

Alias: $loinc = http://loinc.org
Alias: $v3-ObservationValue = http://terminology.hl7.org/CodeSystem/v3-ObservationValue
Alias: $provenance-participant-type = http://terminology.hl7.org/CodeSystem/provenance-participant-type

Instance: TheOtherAI
InstanceOf: AIDevice
Title: "A Second, Unrelated AI System"
Description: """
A second AI system, from a different manufacturer, used alongside `Device/TheAI`.

This Device exists so the discovery examples can show that searching for output from one
(problematic) model does not return output produced by a different, unaffected model.
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "otherhealth"
* manufacturer = "Beta Diagnostics, Inc"
* type = AIdeviceTypeCS#Artificial-Intelligence
* extension[aiKind].valueCodeableConcept = AIdeviceTypeCS#Large-Language-Models
* version.value = "4.1-9981"
* contact.system = #url
* contact.value = "http://example.org/other-ai"

Instance: AI-Contributed-OtherModel
InstanceOf: AIProvenance
Title: "Provenance of an Observation authored by a different AI model"
Description: """
A Provenance resource documenting that an Observation was authored by `Device/TheOtherAI`
(a different model than `Device/TheAI`).

Used by Use Case 3 to demonstrate that a discovery search for output from `Device/TheAI`
does not return this Observation.
"""
Usage: #example
* target = Reference(Observation/other-model-result)
* recorded = "2026-01-15T11:00:00Z"
* reason[AIReason] = $v3-ObservationValue#AIAST
* agent[+].type = $provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/TheOtherAI)

Instance: other-model-result
InstanceOf: Observation
Title: "Observation authored by a different AI model"
Description: "A simple Observation authored by Device/TheOtherAI, used in the Use Case 3 discovery example."
Usage: #example
* meta.security = $v3-ObservationValue#AIAST "Artificial Intelligence asserted"
* status = #final
* code = $loinc#718-7 "Hemoglobin [Mass/volume] in Blood"
* subject.reference = "http://server.example.org/fhir/Patient/f201"
* effectiveDateTime = "2026-01-15T10:55:00Z"
* valueQuantity = 13.2 'g/dL' "g/dL"
* device = Reference(TheOtherAI)
