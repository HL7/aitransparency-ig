
Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org


/* Note that FHIR R6 has a Provenance example of a MolecularSequence recorded by a Biocompute object
 https://build.fhir.org/provenance-example-biocompute-object.html
 Yet this example has an agent of Practitioner/f007, rather than a Device.
 I have taken that example and modified it to indicate that the Biocompute object was the AI system providing input to the MolecularSequence.
*/

Instance: AI-Authored-Element
InstanceOf: AIProvenance
Title: "Provenance of AI Authored Procedure.followup.text"
Description: """
A Provenance resource that documents the addition of followUp text in a Procedure by an AI system.
"""
Usage: #example
* target.extension.url = "http://hl7.org/fhir/StructureDefinition/targetPath"
* target.extension.valueString = "Procedure.followUp.text"
* target = Reference(Procedure/proc)
* recorded = "2021-12-08T16:54:24+11:00"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who.reference = "http://example.org/fhir/Practitioner/pract"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#informant "Informant"
* agent[=].who = Reference(Device/TheAI)

Instance: TheAI
InstanceOf: AIDevice
Title: "The AI System"
Description: """
An AI system that authored a resource.

TODO: Need codes in the device-type to indicate AI/LLM.
TODO: Need codes to identify the device version for the parts of an AI?
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type.text = "AI/LLM"
* type = http://snomed.info/sct#706689003 "Application programme software"
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"

Instance: AI-Contributed
InstanceOf: AIProvenance
Title: "Provenance of AI authored Lab Observation"
Description: """
A Provenance resource that documents the creation of a Lab result Observation resource by an AI (device), verified by a human.
The AI system is represented as a Device resource.
"""
Usage: #example
* target = Reference(Observation/f206)
* occurredPeriod.start = "2017-06-06"
* recorded = "2016-06-09T08:12:14+10:00"
* activity = http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE "create"
* activity.text = "antiviral resistance detection"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier "Verifier"
* agent[=].who.reference = "http://example.org/fhir/Practitioner/pract"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/TheAI)



// =================================== additional resources referenced =====================


Instance: proc
InstanceOf: Procedure
Title: "Appendectomy Procedure"
Description: "A Procedure resource that is created by an AI system and verified by a human."
Usage: #example
* meta.versionId = "1"
* status = #completed
* code = $sct#80146002 "Excision of appendix"
* code.text = "Appendectomy"
* subject.reference = "http://example.org/fhir/Patient/pat"
* performedDateTime = "2013-04-05"
* recorder.reference = "http://example.org/fhir/Practitioner/pract"
* performer.actor.reference = "http://example.org/fhir/Practitioner/pract"
* reasonCode.text = "Generalized abdominal pain 24 hours. Localized in RIF with rebound and guarding"
* followUp.text = "ROS 5 days  - 2013-04-10"
* note.text = "Routine Appendectomy. Appendix was inflamed and in retro-caecal position"

Instance: f206
InstanceOf: Observation
Title: "Blood Culture Result"
Description: "A lab result Observation resource that is created by an AI system and verified by a human."
Usage: #example
* status = #final
* code.coding[0] = http://example.org/codes/foobar#104177 "Blood culture"
* code.coding[+] = $loinc#600-7 "Bacteria identified in Blood by Culture"
* subject.reference = "http://example.org/fhir/Patient/f201"
* issued = "2013-03-11T10:28:00+01:00"
* effectiveDateTime = "2013-03-11T10:28:00+01:00"
* performer[+].reference = "http://example.org/fhir/Practitioner/pract"
* valueCodeableConcept = $sct#3092008 "Staphylococcus aureus"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#POS
* method = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"
