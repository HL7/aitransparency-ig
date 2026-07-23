/* 
The following extension is intended for DomainResource so it can be used on the root of any FHIR resource, or at any element of any FHIR Resource. It is used to capture the confidence that an AI system has in the result recorded in THAT resource. The confidence is expressible as: 
valueDecimal → probabilities (0–1)
valueQuantity → percentage with units (%)
valueRange → confidence intervals
valueCodeableConcept → e.g. categorical (“low/medium/high”)
valueString → free-form (fallback / legacy)

This extension is Universal Realm. It is intended to support FDA Transparency for Machine Learning-Enabled Medical Devices: Guiding Principles (June 2024)
https://www.fda.gov/medical-devices/software-medical-device-samd/transparency-machine-learning-enabled-medical-devices-guiding-principles
*/
Extension: AIconfidence
Title: "AI Confidence"
Description: """
The confidence that an AI system has in the result recorded in the resource or element to which this extension is attached. The confidence is expressible as: 

- valueDecimal → probabilities (0-1), 
- valueQuantity → percentage with units (%), 
- valueRange → confidence intervals, 
- valueCodeableConcept → e.g. categorical (“low/medium/high”), 
- valueString → free-form (fallback / legacy).
"""
Context: Resource, Element
* value[x] 1..1 MS
* value[x] only decimal or Quantity or Range or CodeableConcept or string
* valueDecimal MS
* valueDecimal ^short = "Probability"
* valueDecimal ^definition = "The probability that the result is correct, expressed as a decimal between 0 and 1."
* valueQuantity MS
* valueQuantity ^short = "Percentage"
* valueQuantity ^definition = "The probability that the result is correct, expressed as a percentage with units."
* valueRange MS
* valueRange ^short = "Confidence Interval"
* valueRange ^definition = "The confidence interval for the result, expressed as a range of values."
* valueCodeableConcept MS
* valueCodeableConcept ^short = "Categorical Confidence"
* valueCodeableConcept ^definition = "The confidence that the result is correct, expressed as a categorical value (e.g., low/medium/high)."
* valueCodeableConcept from http://terminology.hl7.org/ValueSet/certainty-rating (required)
* valueString MS
* valueString ^short = "Free-form Confidence"
* valueString ^definition = "The confidence that the result is correct, expressed as a free-form string."
