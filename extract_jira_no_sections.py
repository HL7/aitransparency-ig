"""
Extract Jira tickets that do NOT have Related Section(s) values,
grouped by their Related Artifact(s) field.
"""
import re
from html.parser import HTMLParser
from collections import defaultdict

class JiraTableParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tickets = []
        self.current_ticket = {}
        self.in_row = False
        self.in_cell = False
        self.current_cell_class = None
        self.cell_data = []
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == 'tr' and 'data-issuekey' in attrs_dict:
            self.in_row = True
            self.current_ticket = {'key': attrs_dict['data-issuekey']}
            
        elif tag == 'td' and self.in_row:
            self.in_cell = True
            self.current_cell_class = attrs_dict.get('class', '')
            self.cell_data = []
            
        elif tag == 'br' and self.in_cell:
            # Preserve line breaks in cell data
            self.cell_data.append('<BR/>')
            
    def handle_endtag(self, tag):
        if tag == 'tr' and self.in_row:
            self.in_row = False
            if self.current_ticket:
                self.tickets.append(self.current_ticket)
                self.current_ticket = {}
                
        elif tag == 'td' and self.in_cell:
            self.in_cell = False
            data = ''.join(self.cell_data).strip()
            
            if self.current_cell_class == 'summary':
                self.current_ticket['summary'] = data
            elif self.current_cell_class == 'customfield_11300':
                self.current_ticket['artifact'] = data
            elif self.current_cell_class == 'customfield_10518':
                self.current_ticket['section'] = data
                
            self.current_cell_class = None
            self.cell_data = []
            
    def handle_data(self, data):
        if self.in_cell:
            self.cell_data.append(data)

def clean_text(text):
    """Clean HTML text by removing tags and extra whitespace"""
    # Remove HTML tags
    text = re.sub(r'<[^>]+>', ' ', text)
    # Replace multiple spaces with single space
    text = re.sub(r'\s+', ' ', text)
    # Remove special whitespace characters
    text = text.replace('&nbsp;', ' ')
    return text.strip()

def main():
    # Read the HTML file
    html_file = r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html'
    
    print("Reading HTML file...")
    with open(html_file, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    print("Parsing HTML...")
    parser = JiraTableParser()
    parser.feed(html_content)
    
    print(f"Found {len(parser.tickets)} tickets total\n")
    
    # Filter tickets with no section and group by artifact
    tickets_by_artifact = defaultdict(list)
    
    for ticket in parser.tickets:
        section = ticket.get('section', '').strip()
        
        # Check if section is empty or contains only whitespace/nbsp
        if not section or section == '' or section == '&nbsp;':
            artifact = ticket.get('artifact', '').strip()
            if not artifact or artifact == '' or artifact == '&nbsp;':
                artifact = '(No Artifact Specified)'
            
            # Clean the text
            summary = clean_text(ticket.get('summary', ''))
            artifact_clean = clean_text(artifact) if artifact != '(No Artifact Specified)' else artifact
            
            tickets_by_artifact[artifact_clean].append({
                'key': ticket['key'],
                'summary': summary
            })
    
    # Print results organized by artifact
    print("=" * 80)
    print("TICKETS WITHOUT 'Related Section(s)' - GROUPED BY ARTIFACT")
    print("=" * 80)
    print()
    
    total_tickets = sum(len(tickets) for tickets in tickets_by_artifact.values())
    print(f"Total tickets without Related Section(s): {total_tickets}\n")
    
    # Sort artifacts alphabetically, but put "No Artifact" last
    sorted_artifacts = sorted([a for a in tickets_by_artifact.keys() if a != '(No Artifact Specified)'])
    if '(No Artifact Specified)' in tickets_by_artifact:
        sorted_artifacts.append('(No Artifact Specified)')
    
    for artifact in sorted_artifacts:
        tickets = tickets_by_artifact[artifact]
        print(f"\n{'='*80}")
        print(f"ARTIFACT: {artifact}")
        print(f"Count: {len(tickets)} ticket(s)")
        print('='*80)
        
        for ticket in tickets:
            print(f"\n  {ticket['key']}")
            print(f"  {ticket['summary']}")
    
    print("\n" + "="*80)
    print(f"SUMMARY: {total_tickets} tickets without Related Section(s) across {len(tickets_by_artifact)} artifact group(s)")
    print("="*80)

if __name__ == '__main__':
    main()
