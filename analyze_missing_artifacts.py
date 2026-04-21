import re
from html.parser import HTMLParser
from collections import defaultdict

class JiraHTMLParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tickets = []
        self.current_ticket = {}
        self.current_field = None
        self.in_td = False
        self.td_class = None
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == 'tr' and 'class' in attrs_dict and 'issuerow' in attrs_dict['class']:
            if self.current_ticket:
                self.tickets.append(self.current_ticket)
            self.current_ticket = {}
            
        elif tag == 'td' and 'class' in attrs_dict:
            self.in_td = True
            self.td_class = attrs_dict['class']
            self.current_field = self.td_class
            
    def handle_endtag(self, tag):
        if tag == 'td':
            self.in_td = False
            self.td_class = None
            self.current_field = None
            
    def handle_data(self, data):
        if self.in_td and self.current_field and data.strip():
            # Skip certain noisy data
            if 'FHIR-' in data or data.strip() == 'Unassigned' or data.strip() == 'Unresolved':
                pass
            else:
                if self.current_field not in self.current_ticket:
                    self.current_ticket[self.current_field] = data.strip()
                else:
                    self.current_ticket[self.current_field] += ' ' + data.strip()

# Read the HTML file
with open(r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html', 'r', encoding='utf-8') as f:
    html_content = f.read()

# Parse tickets with regex (more reliable for this format)
ticket_pattern = r'<tr id="issuerow\d+".*?</tr>'
tickets_raw = re.findall(ticket_pattern, html_content, re.DOTALL)

print(f"Found {len(tickets_raw)} tickets\n")

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
    description = description.replace('&amp;', '&').replace('&lt;', '<').replace('&gt;', '>').strip()
    
    # Extract Related Artifact(s) field - customfield_11300
    artifact_match = re.search(r'<td class="customfield_11300">\s*(.*?)\s*</td>', ticket_html, re.DOTALL)
    artifact_value = artifact_match.group(1).strip() if artifact_match else ""
    # Check if it's empty (just whitespace or nothing)
    artifact_value = re.sub(r'<[^>]+>', '', artifact_value).strip()
    
    tickets.append({
        'key': key,
        'summary': summary,
        'description': description,
        'artifact': artifact_value
    })

# Define FHIR artifacts to look for
fhir_artifacts = {
    'AI Data': [
        'ai data', 'aidata', 'ai-data', 
        'observation profile', 'observation resource',
        'ai observation', 'ai-generated observation'
    ],
    'AI Device': [
        'ai device', 'aidevice', 'ai-device', 
        'device profile', 'device resource',
        'device.type', 'device type', 'device.note', 'device.property',
        'llm device', 'ai/llm'
    ],
    'AI Model-Card DocumentReference': [
        'model card', 'modelcard', 'model-card', 
        'documentreference profile', 'documentreference resource',
        'model-card documentreference', 'model card document'
    ],
    'AI Provenance': [
        'ai provenance', 'aiprovenance', 'ai-provenance', 
        'provenance profile', 'provenance resource',
        'provenance.entity', 'provenance.agent'
    ],
    'AIdeviceTypeVS': [
        'aidevicetypevs', 'ai device type valueset', 'ai-device-type-vs',
        'device type valueset', 'device type value set',
        'aidevicetype', 'ai device type codes'
    ],
    'CodeSystem': [
        'codesystem', 'code system', 'coding system',
        'terminology', 'codes'
    ]
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
    matches = []
    for artifact, keywords in fhir_artifacts.items():
        for keyword in keywords:
            if keyword in combined_text:
                # Determine confidence
                confidence = 'medium'
                
                # Higher confidence if artifact name is in title/summary
                if keyword in ticket['summary'].lower():
                    confidence = 'high'
                
                # High confidence for specific artifact mentions
                if artifact == 'AI Device':
                    if any(term in combined_text for term in ['device profile', 'device.type', 'device.note', 'device.property', 'ai device', 'device resource']):
                        confidence = 'high'
                elif artifact == 'AI Provenance':
                    if any(term in combined_text for term in ['provenance profile', 'provenance resource', 'provenance.entity', 'provenance.agent', 'ai provenance']):
                        confidence = 'high'
                elif artifact == 'AI Model-Card DocumentReference':
                    if any(term in combined_text for term in ['model card', 'model-card', 'documentreference']):
                        confidence = 'high'
                elif artifact == 'AI Data':
                    if any(term in combined_text for term in ['observation profile', 'observation resource', 'ai data', 'ai-generated']):
                        confidence = 'high'
                elif artifact == 'AIdeviceTypeVS':
                    if any(term in combined_text for term in ['valueset', 'value set', 'device type']):
                        confidence = 'high'
                
                # Lower confidence for generic terms
                if keyword in ['terminology', 'codes'] and 'codesystem' not in combined_text:
                    confidence = 'low'
                
                matches.append((artifact, confidence, keyword))
                break  # Only count once per artifact
    
    # Add to misclassified if we found matches
    if matches:
        # Get the best match (prefer high confidence)
        best_match = sorted(matches, key=lambda x: (x[1] == 'high', x[0]))[0]
        artifact_name, confidence, matched_keyword = best_match
        
        misclassified[artifact_name].append({
            'key': ticket['key'],
            'summary': ticket['summary'],
            'description': ticket['description'][:200] + '...' if len(ticket['description']) > 200 else ticket['description'],
            'confidence': confidence,
            'matched_keyword': matched_keyword
        })

# Output results
print("=" * 80)
print("TICKETS WITHOUT 'Related Artifact(s)' THAT APPEAR TO BE ABOUT SPECIFIC ARTIFACTS")
print("=" * 80)
print()

total_misclassified = sum(len(v) for v in misclassified.values())
print(f"Found {total_misclassified} potentially misclassified tickets\n")

for artifact_name in sorted(misclassified.keys()):
    tickets_list = misclassified[artifact_name]
    print(f"\n{'='*80}")
    print(f"ARTIFACT: {artifact_name}")
    print(f"Count: {len(tickets_list)} tickets")
    print('='*80)
    
    # Group by confidence
    high_confidence = [t for t in tickets_list if t['confidence'] == 'high']
    medium_confidence = [t for t in tickets_list if t['confidence'] == 'medium']
    low_confidence = [t for t in tickets_list if t['confidence'] == 'low']
    
    for confidence_level, tickets_sublist in [('HIGH', high_confidence), ('MEDIUM', medium_confidence), ('LOW', low_confidence)]:
        if tickets_sublist:
            print(f"\n{confidence_level} CONFIDENCE ({len(tickets_sublist)} tickets):")
            print("-" * 80)
            for ticket in tickets_sublist:
                print(f"\nKey: {ticket['key']}")
                print(f"Summary: {ticket['summary']}")
                print(f"Description: {ticket['description']}")
                print(f"Matched on: '{ticket['matched_keyword']}'")

print("\n" + "=" * 80)
print("SUMMARY BY ARTIFACT")
print("=" * 80)
for artifact_name in sorted(misclassified.keys()):
    tickets_list = misclassified[artifact_name]
    high = len([t for t in tickets_list if t['confidence'] == 'high'])
    medium = len([t for t in tickets_list if t['confidence'] == 'medium'])
    low = len([t for t in tickets_list if t['confidence'] == 'low'])
    print(f"{artifact_name}: {len(tickets_list)} total (High: {high}, Medium: {medium}, Low: {low})")

print(f"\nTotal misclassified tickets: {total_misclassified}")
