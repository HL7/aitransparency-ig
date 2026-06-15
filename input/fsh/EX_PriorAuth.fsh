/*
Use Case 1 (administrative / payer angle):
    A health plan uses an AI system to review a prior-authorization request and draft the
    determination. A human utilization reviewer verifies the draft before it is released.

    This shows the "AI Attribution in Documentation Review" use case from a non-clinician
    perspective: the data being reviewed is administrative (a prior-authorization decision),
    and the reviewer is a payer rather than a treating clinician.

    The AI system (Device/TheAI) and the human verifier are recorded on an AIProvenance, and
    the ClaimResponse carries the AIAST security label so the AI involvement is visible without
    fetching the Provenance.
*/

Alias: $claim-type = http://terminology.hl7.org/CodeSystem/claim-type
Alias: $remittance-outcome = http://hl7.org/fhir/remittance-outcome
Alias: $v3-ObservationValue = http://terminology.hl7.org/CodeSystem/v3-ObservationValue
Alias: $provenance-participant-type = http://terminology.hl7.org/CodeSystem/provenance-participant-type
Alias: $provenance-entity-role = http://terminology.hl7.org/CodeSystem/provenance-entity-role

Instance: AI-PriorAuth-Determination
InstanceOf: ClaimResponse
Title: "Prior Authorization Determination drafted by AI"
Description: """
A ClaimResponse representing a prior-authorization determination that was drafted by an AI system
and verified by a human utilization reviewer at the payer.

The whole resource is tagged with the `AIAST` security label so that anyone reviewing the
determination can immediately see that AI was involved in producing it, and can then fetch the
[AIProvenance](Provenance-AI-PriorAuth-Provenance.html) for details (including the human review).
"""
Usage: #example
* meta.security = $v3-ObservationValue#AIAST "Artificial Intelligence asserted"
* status = #active
* type = $claim-type#professional "Professional"
* use = #preauthorization
* patient.reference = "http://server.example.org/fhir/Patient/pat"
* created = "2026-02-10T09:15:00Z"
* insurer.reference = "http://server.example.org/fhir/Organization/payer"
* request.reference = "http://server.example.org/fhir/Claim/priorauth-mri-request"
* outcome = #complete
* disposition = "Prior authorization approved for the requested MRI of the lumbar spine based on the submitted clinical documentation and the plan's medical-necessity criteria."
* preAuthRef = "PA-2026-0099"

Instance: AI-PriorAuth-Provenance
InstanceOf: AIProvenance
Title: "Provenance of AI drafted Prior Authorization Determination"
Description: """
A Provenance resource that documents an AI system drafting a prior-authorization determination
([ClaimResponse](ClaimResponse-AI-PriorAuth-Determination.html)), which was then verified by a
human utilization reviewer at the payer.

- The AI system is represented as a Device resource (`Device/TheAI`).
- A human reviewer is recorded as a verifier, showing human-in-the-loop oversight.
- The original prior-authorization request (Claim) is recorded as the source input.
"""
Usage: #example
* target = Reference(ClaimResponse/AI-PriorAuth-Determination)
* occurredDateTime = "2026-02-10T09:15:00Z"
* recorded = "2026-02-10T09:20:00Z"
* reason[AIReason] = $v3-ObservationValue#AIAST
* activity.text = "AI drafted prior-authorization determination, verified by a utilization reviewer"
* agent[+].type = $provenance-participant-type#verifier "Verifier"
* agent[=].who.reference = "http://server.example.org/fhir/Practitioner/utilization-reviewer"
* agent[+].type = $provenance-participant-type#author "Author"
* agent[=].who = Reference(Device/TheAI)
* entity[+].role = $provenance-entity-role#source "Source"
* entity[=].what.reference = "http://server.example.org/fhir/Claim/priorauth-mri-request"
