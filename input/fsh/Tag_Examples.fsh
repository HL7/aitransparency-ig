
Alias: $sct = http://snomed.info/sct
Alias: $v2-0074 = http://terminology.hl7.org/CodeSystem/v2-0074
Alias: $loinc = http://loinc.org
Alias: $codes = http://acme.ec/codes
Alias: $acmelabs = http://acmelabs.org
Alias: $v3-ObservationInterpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation
Alias: $organization-type = http://terminology.hl7.org/CodeSystem/organization-type
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v2-0131 = http://terminology.hl7.org/CodeSystem/v2-0131


//=====================================Example of Resource Level tagging ===  


Instance: glasgow
InstanceOf: Observation
Title: "Example Observation with AI Assisted security labels"
Description: """
This observation is derived from FHIR Core R4 Observation id **glasgow**. 
This use contains a Glasgow Coma Scale observation with **AI Asserted** security labels for the whole Resource.

Note that the example I took, I assumed was a good one for AIAST. But I am not sure that it is, especially since the outcome is not well coded, using ucum score values.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST
* status = #final
* code = $loinc#9269-2 "Glasgow coma score total"
* code.text = "Glasgow Coma Scale , (GCS)"
* subject = Reference(Patient/example) "Peter James Chalmers"
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


//==================================== Example of Element Level tagging 

Instance: DiagnosticeReport-Instance-for-f202-1
InstanceOf: DiagnosticReport
Description: """
This DiagnosticeReport is derived from FHIR Core R4 DiagnosticReport id **f202**. 
This use contains a DiagnosticReport with inline AI Asserted security labels for the conclusion and conclusionCode, 
as well as a ServiceRequest.

- The DiagnosticReport is tagged with the security label `PROCESSINLINELABEL`, to indicate that there is inline security labeling.
- The `DiagnosticReport.conclusion` and `DiagnosticReport.conclusionCode` elements are tagged with the AI Asserted security label `AIAST`.
"""
Usage: #example
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PROCESSINLINELABEL
// Not clear we need this extension
//* extension[0].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-has-inline-sec-label"
//* extension[0].valueBoolean = true
* id = "f202"
* basedOn = Reference(ServiceRequest/req)
* status = #final
* category.coding[0] = $sct#15220000 "Laboratory test"
* category.coding[+] = $v2-0074#LAB
* code = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"
* subject = Reference(Patient/example)
* issued = "2013-03-11T10:28:00+01:00"
* performer = Reference(Organization/f201) "AUMC"
* result = Reference(Observation/f206) "Results for staphylococcus analysis on Roel's blood culture"
* conclusion = "Blood culture tested positive on staphylococcus aureus"
* conclusion.extension[0].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-inline-sec-label"
* conclusion.extension[0].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST
* conclusionCode = $sct#428763004 "Staphylococcus aureus bacteraemia"
* conclusionCode.extension[0].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-inline-sec-label"
* conclusionCode.extension[0].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#AIAST


//========================================= Other resources used above

Instance: req
InstanceOf: ServiceRequest
Usage: #example
* status = #active
* intent = #original-order
* code = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"
* subject = Reference(Patient/example)
* encounter = Reference(Encounter/f203)
* requester = Reference(Practitioner/pf201) "Dokter Bronsig"


Instance: f206
InstanceOf: Observation
Usage: #example
* status = #final
* code.coding[0] = $acmelabs#104177 "Blood culture"
* code.coding[+] = $loinc#600-7 "Bacteria identified in Blood by Culture"
* subject = Reference(Patient/example)
* issued = "2013-03-11T10:28:00+01:00"
* performer = Reference(Practitioner/f202) "Luigi Maas"
* valueCodeableConcept = $sct#3092008 "Staphylococcus aureus"
* interpretation = $v3-ObservationInterpretation#POS
* method = $sct#104177005 "Blood culture for bacteria, including anaerobic screen"

Instance: f201
InstanceOf: Organization
Usage: #example
* identifier.use = #official
* identifier.system = "http://www.zorgkaartnederland.nl/"
* identifier.value = "Artis University Medical Center"
* active = true
* type.coding[0] = $sct#405608006 "Academic Medical Center"
* type.coding[+] = urn:oid:2.16.840.1.113883.2.4.15.1060#V6 "University Medical Hospital"
* type.coding[+] = $organization-type#prov "Healthcare Provider"
* name = "Artis University Medical Center (AUMC)"
* telecom.system = #phone
* telecom.value = "+31715269111"
* telecom.use = #work
* address.use = #work
* address.line = "Walvisbaai 3"
* address.city = "Den Helder"
* address.postalCode = "2333ZA"
* address.country = "NLD"
* contact.name.use = #official
* contact.name.text = "Professor Brand"
* contact.name.family = "Brand"
* contact.name.given = "Ronald"
* contact.name.prefix = "Prof.Dr."
* contact.telecom.system = #phone
* contact.telecom.value = "+31715269702"
* contact.telecom.use = #work
* contact.address.line[0] = "Walvisbaai 3"
* contact.address.line[+] = "Gebouw 2"
* contact.address.city = "Den helder"
* contact.address.postalCode = "2333ZA"
* contact.address.country = "NLD"


Instance: pf201
InstanceOf: Practitioner
Usage: #example
* identifier.use = #official
* identifier.type.text = "UZI-nummer"
* identifier.system = "urn:oid:2.16.528.1.1007.3.1"
* identifier.value = "12345678901"
* active = true
* name.use = #official
* name.text = "Dokter Bronsig"
* name.family = "Bronsig"
* name.given = "Arend"
* name.prefix = "Dr."
* telecom.system = #phone
* telecom.value = "+31715269111"
* telecom.use = #work
* address.use = #work
* address.line[0] = "Walvisbaai 3"
* address.line[+] = "C4 - Automatisering"
* address.city = "Den helder"
* address.postalCode = "2333ZA"
* address.country = "NLD"
* gender = #male
* birthDate = "1956-12-24"
* qualification.code = $sct#41672002 "Pulmonologist"

Instance: f202
InstanceOf: Practitioner
Usage: #example
* identifier[0].use = #official
* identifier[=].type.text = "UZI-nummer"
* identifier[=].system = "urn:oid:2.16.528.1.1007.3.1"
* identifier[=].value = "12345678902"
* identifier[+].use = #official
* identifier[=].type.text = "BIG-nummer"
* identifier[=].system = "https://www.bigregister.nl/"
* identifier[=].value = "12345678902"
* active = true
* name.use = #official
* name.text = "Luigi Maas"
* name.family = "Maas"
* name.given = "Luigi"
* name.prefix = "Dr."
* telecom.system = #phone
* telecom.value = "+31715269111"
* telecom.use = #work
* address.use = #work
* address.line[0] = "Walvisbaai 3"
* address.line[+] = "C4 - Automatisering"
* address.city = "Den helder"
* address.postalCode = "2333ZA"
* address.country = "NLD"
* gender = #male
* birthDate = "1960-06-12"

Instance: f203
InstanceOf: Encounter
Usage: #example
* identifier.use = #temp
* identifier.value = "Encounter_Roel_20130311"
* status = #finished
* statusHistory.status = #arrived
* statusHistory.period.start = "2013-03-08"
* class = $v3-ActCode#IMP "inpatient encounter"
* type = $sct#183807002 
* priority = $sct#394849002 "High priority"
* subject = Reference(Patient/example)

Instance: example
InstanceOf: Patient
Usage: #example
* identifier.use = #usual
* identifier.type = $v2-0203#MR
* identifier.system = "urn:oid:1.2.36.146.595.217.0.1"
* identifier.value = "12345"
* identifier.period.start = "2001-05-06"
* identifier.assigner.display = "Acme Healthcare"
* active = true
* name[0].use = #official
* name[=].family = "Chalmers"
* name[=].given[0] = "Peter"
* name[=].given[+] = "James"
* name[+].use = #usual
* name[=].given = "Jim"
* name[+].use = #maiden
* name[=].family = "Windsor"
* name[=].given[0] = "Peter"
* name[=].given[+] = "James"
* name[=].period.end = "2002"
* telecom[0].use = #home
* telecom[+].system = #phone
* telecom[=].value = "(03) 5555 6473"
* telecom[=].use = #work
* telecom[=].rank = 1
* telecom[+].system = #phone
* telecom[=].value = "(03) 3410 5613"
* telecom[=].use = #mobile
* telecom[=].rank = 2
* telecom[+].system = #phone
* telecom[=].value = "(03) 5555 8834"
* telecom[=].use = #old
* telecom[=].period.end = "2014"
* gender = #male
* birthDate = "1974-12-25"
* birthDate.extension.url = "http://hl7.org/fhir/StructureDefinition/patient-birthTime"
* birthDate.extension.valueDateTime = "1974-12-25T14:35:45-05:00"
* deceasedBoolean = false
* address.use = #home
* address.type = #both
* address.text = "534 Erewhon St PeasantVille, Rainbow, Vic  3999"
* address.line = "534 Erewhon St"
* address.city = "PleasantVille"
* address.district = "Rainbow"
* address.state = "Vic"
* address.postalCode = "3999"
* address.period.start = "1974-12-25"
* contact.relationship = $v2-0131#N
* contact.name.family = "du Marché"
* contact.name.family.extension.url = "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix"
* contact.name.family.extension.valueString = "VV"
* contact.name.given = "Bénédicte"
* contact.telecom.system = #phone
* contact.telecom.value = "+33 (237) 998327"
* contact.address.use = #home
* contact.address.type = #both
* contact.address.line = "534 Erewhon St"
* contact.address.city = "PleasantVille"
* contact.address.district = "Rainbow"
* contact.address.state = "Vic"
* contact.address.postalCode = "3999"
* contact.address.period.start = "1974-12-25"
* contact.gender = #female
* contact.period.start = "2012"
//* managingOrganization = Reference(Organization/1)


