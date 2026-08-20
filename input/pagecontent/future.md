
In FHIR R5/R6 of FHIR core the Device resource has a `.property` element with a `.property.type` we can use to indicate the model-card, and place the model-card markdown into `.property.valueAttachment` as markdown string. (It could go into `.valueString` if we know it will be markdown, but that is not explicitly clear.)

In R5/R6 `Provenance.entity.role` has the code `#instantiates` which would be more appropriate for the Model-Card and Input-Prompt. We use the broadest term `#derivation` today. These are not wrong, as they are entity provided to the AI, but `#instantiates` is more specific and appropriate.

This IG does not address how multiple cascaded AI models are recorded. This might be done using multiple Provenance resources, or by using the `Provenance.entity.agent`, or through some use of future AI standards that support documenting this in the Model-Card or Prompt.

This IG does not address generally "guardrails", which are important controls placed on the output of an AI model to prevent bias, inappropriate responses, or undesired actions. The IG does address if a human-in-the-loop is used, and if so, how that is recorded in the Provenance. 

