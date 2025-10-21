
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
A Provenance resource that documents the addition of followUp text in a Procedure by an AI system. No Model-Card was used.
"""
Usage: #example
* target.extension.url = "http://hl7.org/fhir/StructureDefinition/targetPath"
* target.extension.valueString = "Procedure.followUp.text"
* target = Reference(Procedure/proc)
* recorded = "2021-12-08T16:54:24+11:00"
* reason[+] = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who.reference = "http://server.example.org/fhir/Practitioner/pract"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#informant "Informant"
* agent[=].who = Reference(Device/TheAI)

Instance: TheAI
InstanceOf: AIDevice
Title: "The AI System"
Description: """
An AI system that authored a resource.
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

Instance: AI-Contributed
InstanceOf: AIProvenance
Title: "Provenance of AI authored Lab Observation"
Description: """
A Provenance resource that documents the creation of a Lab result Observation resource by an AI (device), verified by a human.
- The AI system is represented as a Device resource.
- No Model-Card was used.
"""
Usage: #example
* target = Reference(Observation/f206)
* occurredPeriod.start = "2017-06-06"
* recorded = "2016-06-09T08:12:14+10:00"
* activity = http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE "create"
* activity.text = "antiviral resistance detection"
* reason[+] = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier "Verifier"
* agent[=].who.reference = "http://server.example.org/fhir/Practitioner/pract"
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
* subject.reference = "http://server.example.org/fhir/Patient/pat"
* performedDateTime = "2013-04-05"
* recorder.reference = "http://server.example.org/fhir/Practitioner/pract"
* performer.actor.reference = "http://server.example.org/fhir/Practitioner/pract"
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
* subject.reference = "http://server.example.org/fhir/Patient/f201"
* issued = "2013-03-11T10:28:00+01:00"
* effectiveDateTime = "2013-03-11T10:28:00+01:00"
* performer[+].reference = "http://server.example.org/fhir/Practitioner/pract"
* valueCodeableConcept = $sct#3092008 "Staphylococcus aureus"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#POS
* method = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"


// Taken from FHIR core example, replicated here to add the AIdata profile
Instance: satO2
InstanceOf: Observation
Title: "Oxygen Saturation example with AI device"
Description: """
An example of an Oxygen Saturation Observation, where the device used is an AI system.
"""
Usage: #example
//* meta.profile[+] = Canonical(AIdata) -- this does not work as AIdata is on DomainResource, and this level of IG publisher doesn't like two different resource types at the core.
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST "Artificial Intelligence asserted"
* identifier.system = "http://example.org/observation/id"
* identifier.value = "o1223435-10"
* partOf.reference = "http://server.example.org/fhir/Procedure/ob"
* status = #final
* category[0] = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code.coding[0] = $loinc#2708-6 "Oxygen saturation in Arterial blood"
* code.coding[+] = $loinc#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* code.coding[+] = urn:iso:std:iso:11073:10101#150456 "MDC_PULS_OXIM_SAT_O2"
* subject.reference = "http://server.example.org/fhir/Patient/f201"
* effectiveDateTime = "2014-12-05T09:30:10+01:00"
* valueQuantity = 95 '%' "%"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N "Normal"
* interpretation.text = "Normal (applies to non-numeric results)"
* device = Reference(TheAI)
* performer[+].reference = "http://server.example.org/fhir/Practitioner/pract"
* referenceRange.low = 90 '%' "%"
* referenceRange.high = 99 '%' "%"