import re
from collections import defaultdict

# Read the HTML file
with open(r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html', 'r', encoding='utf-8') as f:
    html_content = f.read()

# Parse tickets with regex
ticket_pattern = r'<tr id="issuerow\d+".*?</tr>'
tickets_raw = re.findall(ticket_pattern, html_content, re.DOTALL)

print(f"Total tickets found: {len(tickets_raw)}\n")

# Extract ticket information
tickets = []
for ticket_html in tickets_raw:
    # Extract key
    key_match = re.search(r'data-issue-key="(FHIR-\d+)"', ticket_html)
    if not key_match:
        continue
    key = key_match.group(1)
    
    # Extract summary
    summary_match = re.search(r'<td class="summary"><p>\s*(.*?)\s*</p>', ticket_html, re.DOTALL)
    summary = summary_match.group(1).strip() if summary_match else ""
    
    # Extract description
    desc_match = re.search(r'<td class="description">\s*(.*?)\s*</td>', ticket_html, re.DOTALL)
    description = desc_match.group(1).strip() if desc_match else ""
    # Clean HTML from description
    description = re.sub(r'<[^>]+>', '', description)
    description = description.replace('&amp;', '&').replace('&lt;', '<').replace('&gt;', '>').replace('&quot;', '"').replace('&#39;', "'").strip()
    
    # Extract Related Artifact(s) field - customfield_11300
    artifact_match = re.search(r'<td class="customfield_11300">\s*(.*?)\s*</td>', ticket_html, re.DOTALL)
    artifact_value = artifact_match.group(1).strip() if artifact_match else ""
    # Check if it's empty (just whitespace or nothing)
    artifact_value = re.sub(r'<[^>]+>', '', artifact_value).strip()
    
    # Extract Related Page(s) field - customfield_11301
    page_match = re.search(r'<td class="customfield_11301">\s*(.*?)\s*</td>', ticket_html, re.DOTALL)
    page_value = page_match.group(1).strip() if page_match else ""
    page_value = re.sub(r'<[^>]+>', '', page_value).strip()
    
    tickets.append({
        'key': key,
        'summary': summary,
        'description': description,
        'artifact': artifact_value,
        'page': page_value
    })

# Count tickets without artifact field
no_artifact = [t for t in tickets if not t['artifact']]
print(f"Tickets WITHOUT Related Artifact(s) field: {len(no_artifact)}")
print(f"Tickets WITH Related Artifact(s) field: {len(tickets) - len(no_artifact)}\n")

# Define FHIR artifacts to look for with comprehensive keywords
fhir_artifacts = {
    'AI Device Profile': {
        'keywords': [
            'ai device', 'aidevice', 'ai-device', 
            'device profile', 'device resource',
            'device.type', 'device type', 'device.note', 'device.property',
            'llm device', 'ai/llm', 'device.udi'
        ],
        'context_boost': ['profile', 'constraint', 'cardinality', 'binding']
    },
    'AI Model-Card DocumentReference Profile': {
        'keywords': [
            'model card', 'modelcard', 'model-card', 
            'documentreference profile', 'documentreference resource',
            'model-card documentreference', 'model card document'
        ],
        'context_boost': ['profile', 'attachment', 'markdown']
    },
    'AI Provenance Profile': {
        'keywords': [
            'ai provenance', 'aiprovenance', 'ai-provenance', 
            'provenance profile', 'provenance resource',
            'provenance.entity', 'provenance.agent', 'provenance.target'
        ],
        'context_boost': ['profile', 'reference', 'linkage']
    },
    'AI Data (Observation) Profile': {
        'keywords': [
            'ai data', 'aidata', 'ai-data', 
            'observation profile', 'observation resource',
            'ai observation', 'ai-generated observation',
            'observation.value', 'observation.code'
        ],
        'context_boost': ['profile', 'generated', 'output']
    },
    'AIdeviceTypeVS (ValueSet)': {
        'keywords': [
            'aidevicetypevs', 'ai device type valueset', 'ai-device-type-vs',
            'device type valueset', 'device type value set',
            'aidevicetype', 'ai device type codes', 'device type binding'
        ],
        'context_boost': ['valueset', 'binding', 'expansion']
    },
    'CodeSystem': {
        'keywords': [
            'codesystem', 'code system', 'coding system',
            'terminology codes', 'concept codes'
        ],
        'context_boost': ['define', 'concept', 'hierarchy']
    },
    'Extensions': {
        'keywords': [
            'extension', 'extensions', 'extend', 'extensibility'
        ],
        'context_boost': ['extension definition', 'extension element', 'structuredefinition']
    }
}

# Analyze tickets without Related Artifact(s) field
misclassified = defaultdict(list)

for ticket in tickets:
    # Skip if artifact field is populated
    if ticket['artifact']:
        continue
    
    # Combine summary and description for analysis
    combined_text = (ticket['summary'] + ' ' + ticket['description']).lower()
    
    # Check for artifact mentions
    found_artifacts = {}
    for artifact, config in fhir_artifacts.items():
        keywords = config['keywords']
        context_boost = config.get('context_boost', [])
        
        for keyword in keywords:
            if keyword in combined_text:
                # Base confidence
                confidence_score = 1
                matched_keyword = keyword
                
                # Boost for title/summary mention
                if keyword in ticket['summary'].lower():
                    confidence_score += 2
                
                # Boost for context words
                for context_word in context_boost:
                    if context_word in combined_text:
                        confidence_score += 0.5
                
                # Penalize very short generic terms
                if len(keyword) < 6 and keyword in ['device', 'codes', 'data']:
                    confidence_score -= 0.5
                
                # Store best match for this artifact
                if artifact not in found_artifacts or confidence_score > found_artifacts[artifact][1]:
                    found_artifacts[artifact] = (matched_keyword, confidence_score)
                break
    
    # Add to results
    for artifact, (matched_keyword, score) in found_artifacts.items():
        if score >= 1:
            if score >= 2.5:
                confidence = 'high'
            elif score >= 1.5:
                confidence = 'medium'
            else:
                confidence = 'low'
            
            misclassified[artifact].append({
                'key': ticket['key'],
                'summary': ticket['summary'],
                'description': ticket['description'],
                'page': ticket['page'],
                'confidence': confidence,
                'score': score,
                'matched_keyword': matched_keyword
            })

# Output detailed results
print("=" * 100)
print("DETAILED ANALYSIS: TICKETS WITHOUT 'Related Artifact(s)' THAT SHOULD HAVE ARTIFACTS")
print("=" * 100)
print()

total_misclassified = sum(len(v) for v in misclassified.values())
print(f"Found {total_misclassified} potentially misclassified tickets across {len(misclassified)} artifact types\n")

for artifact_name in sorted(misclassified.keys()):
    tickets_list = sorted(misclassified[artifact_name], key=lambda x: (-['low', 'medium', 'high'].index(x['confidence']), x['key']))
    print(f"\n{'='*100}")
    print(f"ARTIFACT: {artifact_name}")
    print(f"Total: {len(tickets_list)} tickets")
    print('='*100)
    
    # Group by confidence
    high_confidence = [t for t in tickets_list if t['confidence'] == 'high']
    medium_confidence = [t for t in tickets_list if t['confidence'] == 'medium']
    low_confidence = [t for t in tickets_list if t['confidence'] == 'low']
    
    for confidence_level, tickets_sublist in [('HIGH', high_confidence), ('MEDIUM', medium_confidence), ('LOW', low_confidence)]:
        if tickets_sublist:
            print(f"\n{confidence_level} CONFIDENCE ({len(tickets_sublist)} tickets):")
            print("-" * 100)
            for ticket in tickets_sublist:
                print(f"\n  Key: {ticket['key']}")
                print(f"  Summary: {ticket['summary']}")
                print(f"  Related Page: {ticket['page'] if ticket['page'] else '(none)'}")
                print(f"  Matched on: '{ticket['matched_keyword']}' (score: {ticket['score']:.1f})")
                print(f"  Description excerpt:")
                # Print first 300 chars of description
                desc_lines = ticket['description'][:400].replace('\n', ' ').strip()
                print(f"    {desc_lines}{'...' if len(ticket['description']) > 400 else ''}")

print("\n" + "=" * 100)
print("SUMMARY BY ARTIFACT")
print("=" * 100)
for artifact_name in sorted(misclassified.keys()):
    tickets_list = misclassified[artifact_name]
    high = len([t for t in tickets_list if t['confidence'] == 'high'])
    medium = len([t for t in tickets_list if t['confidence'] == 'medium'])
    low = len([t for t in tickets_list if t['confidence'] == 'low'])
    print(f"  {artifact_name}: {len(tickets_list)} total")
    print(f"    - High confidence: {high}")
    print(f"    - Medium confidence: {medium}")
    print(f"    - Low confidence: {low}")
    print()

print(f"Grand Total: {total_misclassified} misclassified tickets")
print("=" * 100)
