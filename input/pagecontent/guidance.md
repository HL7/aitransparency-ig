The following are informative guidance on the use of the AI Transparency Implementation Guide. The guidance is not normative, and is provided to help implementers understand the intent of the guide and how to use it effectively.

### Creating Provenance

When one creates a FHIR Resource, one could use a RESTful create. When this is done there is the question of how the FHIR Provenance and other resources defined here are created. 

There is an experimental http header defined in the [FHIR Provenance IG](https://hl7.org/fhir/provenance.html#header) that can be used to indicate that the Provenance is to be created by the server. This is a good approach, but it is not widely implemented. This approach also does not support creating the DocumentReference or Device if they need to be created.

The most widely supported approach is to do RESTful creates of the Provenance, DocumentReference, and Device resources. The target resource(s), DocumentReference, and Device; will be created first so that they can be indicated in the Provenance.

Another approach is to use a FHIR transaction bundle to create the target resource(s), Provenance, DocumentReference, and Device resources in one transaction. This will ensure that all resources are created together, and if any fail the entire transaction will fail. This is a good approach if it is available.
