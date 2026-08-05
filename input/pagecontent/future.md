
In FHIR R5/R6 of FHIR core the Device resource has a `.property` element with a `.property.type` we can use to indicate the model-card, and place the model-card markdown into `.property.valueAttachment` as markdown string. (It could go into `.valueString` if we know it will be markdown, but that is not explicitly clear.)

