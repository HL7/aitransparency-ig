
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
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"

Instance: Provenance-AI-Contributed
InstanceOf: Provenance
Title: "Provenance of AI authored Lab Observation"
Description: """
A Provenance resource that documents the creation of a Lab result Observation resource by an AI (device), verified by a human.
The AI system is represented as a Device resource.
"""
Usage: #example
* target = Reference(Observation/Example-Observation-f206)
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

Instance: Example-Observation-f206
InstanceOf: Observation
Title: "Blood Culture Result"
Description: "A lab result Observation resource that is created by an AI system and verified by a human."
Usage: #example
* status = #final
* code.coding[0] = http://example.org/codes/foobar#104177 "Blood culture"
* code.coding[+] = $loinc#600-7 "Bacteria identified in Blood by Culture"
* subject = Reference(patientJMTest01)
* issued = "2013-03-11T10:28:00+01:00"
* effectiveDateTime = "2013-03-11T10:28:00+01:00"
// * performer[+].reference = "http://example.org/fhir/Practitioner/pract"
* valueCodeableConcept = $sct#3092008 "Staphylococcus aureus"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#POS
* method = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"


Alias: $v3-RoleCode = http://terminology.hl7.org/CodeSystem/v3-RoleCode
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v3-MaritalStatus = http://terminology.hl7.org/CodeSystem/v3-MaritalStatus

Instance: patientJMTest01
InstanceOf: Patient
Usage: #example
* active = true
* address.city = "Federal Way"
* address.country = "US"
* address.line = "31514 25th Ln S, 101"
* address.period.start = "2016-12-06"
* address.postalCode = "98003"
* address.state = "Wa"
* address.text = "31514 25th Ln S, 101, Federal Way, WA 98003"
* birthDate = "1955-10-03"
* communication.language = urn:ietf:bcp:47#en "English"
* communication.preferred = true
* contact[0].address.text = "24027 110th Pl SE, 202, Kent, Wa 98030"
* contact[=].name.text = "James Mosley"
* contact[=].relationship = $v3-RoleCode#HBRO
* contact[=].telecom.system = #phone
* contact[=].telecom.value = "(210) 555-3333"
* contact[+].address.text = "31514 25th Ln S, 201, Federal Way, WA 98003"
* contact[=].name.text = "Rosemarie Collins"
* contact[=].relationship = $v3-RoleCode#FRND
* contact[=].telecom.system = #phone
* contact[=].telecom.value = "(410) 444-5555"
* extension.extension[0].url = "ombCategory"
* extension.extension[=].valueCoding = urn:oid:2.16.840.1.113883.6.238#2054-5 "Black or African American"
* extension.extension[+].url = "text"
* extension.extension[=].valueString = "African American"
* extension.url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
* gender = #female
* identifier[0].system = "http://hospital.smarthealthit.org"
* identifier[=].type = $v2-0203#MR "Medical Record Number"
* identifier[=].type.text = "Medical Record Number"
* identifier[=].use = #usual
* identifier[=].value = "1072702"
* identifier[+].system = "http://hl7.org/fhir/sid/us-medicare"
* identifier[=].value = "1EG4-TE5-MK73"
* language = #en-US
* maritalStatus = $v3-MaritalStatus#W
* meta.lastUpdated = "2025-09-06T18:49:49.000+00:00"
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
* meta.source = "#B4AhoTkno88myfix"
* meta.versionId = "1"
* name.family = "Mosley"
* name.given = "Jenny"
* name.text = "Mosley, Jenny"
* name.use = #usual
* telecom[0].system = #phone
* telecom[=].use = #home
* telecom[=].value = "555-555-5555"
* telecom[+].system = #phone
* telecom[=].value = "(410) 444-5555"