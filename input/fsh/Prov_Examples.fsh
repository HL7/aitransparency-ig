
Alias: $sct = http://snomed.info/sct

/* Note that FHIR R6 has a Provenance example of a MolecularSequence recorded by a Biocompute object
 https://build.fhir.org/provenance-example-biocompute-object.html
 Yet this example has an agent of Practitioner/f007, rather than a Device.
 I have taken that example and modified it to indicate that the Biocompute object was the AI system providing input to the MolecularSequence.
*/

Instance: AI-Authored
InstanceOf: Provenance
Title: "AI Authored Provenance"
Description: """
A Provenance resource that documents the addition of followUp text in a Procedure by an AI system.
"""
Usage: #example
* target.extension.url = "http://hl7.org/fhir/StructureDefinition/targetPath"
* target.extension.valueString = "Procedure.followUp.text"
* target = Reference(Procedure/proce)
* recorded = "2021-12-08T16:54:24+11:00"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[=].who = Reference(Practitioner/pract)
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#informant
* agent[=].who = Reference(Device/TheAI)

Instance: TheAI
InstanceOf: Device
Title: "The AI System"
Description: """
An AI system that authored a resource.

TODO: Need codes in the device-type to indicate AI/LLM.
TODO: Need codes to identify the device version for the parts of an AI?
"""
Usage: #example
* identifier.system = "http://acme.com/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type.text = "AI/LLM"
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://acme.com"

Instance: AI-Contributed
InstanceOf: Provenance
Title: "Molecular Sequence Object Provenance"
Description: """
A Provenance resource that documents the creation of a MolecularSequence resource by an AI (Biocompute device), verified by a human.
The AI system is represented as a Device resource.
"""
Usage: #example
* target = Reference(MolecularSequence/seq)
* occurredPeriod.start = "2017-06-06"
* recorded = "2016-06-09T08:12:14+10:00"
* activity = http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE "create"
* activity.text = "antiviral resistance detection"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier
* agent[=].who = Reference(Practitioner/pract)
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[=].who = Reference(Device/TheAI)



// =================================== additional resources referenced =====================

Instance: seq
InstanceOf: MolecularSequence
Title: "Example Molecular Sequence"
Description: "A MolecularSequence resource that is created by a Biocompute object."
Usage: #example
* type = #dna
* coordinateSystem = 1


Instance: proc
InstanceOf: Procedure
Usage: #example
* meta.versionId = "1"
* status = #completed
* code = $sct#80146002 "Excision of appendix"
* code.text = "Appendectomy"
* subject = Reference(Patient/pat)
* performedDateTime = "2013-04-05"
* recorder = Reference(Practitioner/pract) "Dr Cecil Surgeon"
* performer.actor = Reference(Practitioner/pract) "Dr Cecil Surgeon"
* reasonCode.text = "Generalized abdominal pain 24 hours. Localized in RIF with rebound and guarding"
* followUp.text = "ROS 5 days  - 2013-04-10"
* note.text = "Routine Appendectomy. Appendix was inflamed and in retro-caecal position"

Instance: pat
InstanceOf: Patient
Title: "Example Patient"
Description: "An example patient resource."
Usage: #example
* name.given = "John"
* name.family = "Doe"


Instance: pract 
InstanceOf: Practitioner
Title: "Example Practitioner"
Description: "An example practitioner resource."
Usage: #example
* name.given = "Cecil"
* name.family = "Surgeon"

Instance: proce
InstanceOf: Procedure
Title: "Example Procedure"
Description: "An example procedure resource."
Usage: #example
* status = #completed
* subject = Reference(Patient/pat)