/*
Use Case:
        A provider receives a PDF of lab result(s) for a patient. This PDF is examined by an AI which generates a Patient resource and Observation resource(s). 

In the attached example the patient's name is Alton Walsh and the lab test is an HbA1C. All the FHIR resources in the bundle have been created by the AI, so they should be tagged accordingly. 

*/

Instance: Lab-Results-PDF
InstanceOf: DocumentReference
Title: "Lab Results PDF"
Description: """
A DocumentReference resource that represents a PDF document containing lab results for a patient. 
This is provided to an AI, which interprets and creates FHIR Resources.

In the attached example the patient's name is Alton Walsh and the lab test is an HbA1C. All the FHIR resources in the bundle have been created by the AI, so they should be tagged accordingly. 
"""
Usage: #example
* status = #current
* content.attachment.id = "ig-loader-labreport_for_alton_walsh.pdf"
* type = $loinc#11502-2 "Laboratory report"
* category.coding[0] = $sct#15220000 "Laboratory test"
* subject.reference = "http://server.example.org/fhir/Patient/alton-walsh"
* date = "2023-10-01T12:00:00+00:00"


Instance: AI-Generated-Lab-Results
InstanceOf: AIProvenance
Title: "Provenance of AI Generated Lab Results"
Description: """
A Provenance resource that documents the creation of a Lab result Observation resource by an AI (device), verified by a human.
The AI system is represented as a Device resource.
The Input is a PDF Lab result.
"""
Usage: #example
* target[+] = Reference(Bundle/b3c1f2d4-5c8e-4b0a-9f6d-7c8e1f2d4b5c)
//* target[+] = Reference(Patient/730779b1-7952-470a-8ea3-8f1ad87ff18f)
//* target[+] = Reference(Observation/608c4de1-1ab6-4bfe-b2e4-dca6b19223f0)
* occurredPeriod.start = "2023-10-01T12:00:00+00:00"
* recorded = "2023-10-01T12:05:00+00:00"
* policy = "http://server.example.org/fhir/DocumentReference/AI-Generated-Lab-Results"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle#transform "Transform/Translate Record Lifecycle Event"
* activity.text = "AI Generated Lab Results from PDF"
* agent[+].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/TheAI)
* entity[+].role = #source
* entity[=].what = Reference(DocumentReference/Lab-Results-PDF)
