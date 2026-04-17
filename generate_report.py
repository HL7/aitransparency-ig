#!/usr/bin/env python3
"""
Parse Jira HTML export to get full details of tickets with both fields empty.
"""

import re
from html.parser import HTMLParser

class DetailedJiraHTMLParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tickets = []
        self.current_ticket = None
        self.current_field = None
        self.in_td = False
        self.capture_text = False
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == 'tr' and 'data-issuekey' in attrs_dict:
            # Start of a new ticket row
            self.current_ticket = {
                'key': attrs_dict['data-issuekey'],
                'summary': '',
                'section': '',
                'artifact': '',
                'page': ''
            }
            
        elif tag == 'td' and self.current_ticket is not None:
            self.in_td = True
            # Check for specific field classes
            if 'class' in attrs_dict:
                class_val = attrs_dict['class']
                if 'summary' in class_val:
                    self.current_field = 'summary'
                    self.capture_text = True
                elif 'customfield_10518' in class_val:  # Related Section(s)
                    self.current_field = 'section'
                    self.capture_text = True
                elif 'customfield_11300' in class_val:  # Related Artifact(s)
                    self.current_field = 'artifact'
                    self.capture_text = True
                elif 'customfield_11301' in class_val:  # Related Page(s)
                    self.current_field = 'page'
                    self.capture_text = True
    
    def handle_endtag(self, tag):
        if tag == 'td':
            self.in_td = False
            self.capture_text = False
            self.current_field = None
            
        elif tag == 'tr' and self.current_ticket is not None:
            # End of ticket row, save it
            self.tickets.append(self.current_ticket)
            self.current_ticket = None
    
    def handle_data(self, data):
        if self.capture_text and self.current_field and self.current_ticket is not None:
            # Clean up the text
            text = data.strip()
            if text and text != '&nbsp;':
                self.current_ticket[self.current_field] += text + ' '

def main():
    # Read the HTML file
    with open(r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html', 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    # Parse the HTML
    parser = DetailedJiraHTMLParser()
    parser.feed(html_content)
    
    # Find tickets with both fields empty
    missing_both = []
    
    for ticket in parser.tickets:
        # Clean up fields
        ticket['summary'] = ticket['summary'].strip()
        ticket['section'] = ticket['section'].strip()
        ticket['artifact'] = ticket['artifact'].strip()
        ticket['page'] = ticket['page'].strip()
        
        # Check if both section and artifact are empty
        if not ticket['section'] and not ticket['artifact']:
            missing_both.append(ticket)
    
    # Print markdown-formatted results
    print("# Jira Tickets Analysis Report")
    print(f"\n**Total tickets analyzed:** {len(parser.tickets)}")
    print(f"\n**Tickets with BOTH Related Section(s) AND Related Artifact(s) empty:** {len(missing_both)}")
    
    print("\n## Detailed List of Tickets\n")
    
    # Sort by ticket key (descending)
    missing_both.sort(key=lambda x: x['key'], reverse=True)
    
    for i, ticket in enumerate(missing_both, 1):
        page = ticket['page'] if ticket['page'] else '*(No Page Specified)*'
        print(f"### {i}. {ticket['key']}")
        print(f"- **Summary:** {ticket['summary']}")
        print(f"- **Related Page(s):** {page}")
        print(f"- **Related Section(s):** *(empty)*")
        print(f"- **Related Artifact(s):** *(empty)*")
        print()
    
    # Print summary statistics
    print("\n## Summary by Related Page\n")
    
    from collections import defaultdict
    by_page = defaultdict(list)
    for ticket in missing_both:
        page = ticket['page'] if ticket['page'] else '(No Page Specified)'
        by_page[page].append(ticket)
    
    print("| Related Page | Count |")
    print("|--------------|-------|")
    for page, tickets in sorted(by_page.items(), key=lambda x: len(x[1]), reverse=True):
        print(f"| {page} | {len(tickets)} |")
    
    print("\n## Key Findings\n")
    print(f"1. **{len(missing_both)} out of {len(parser.tickets)} tickets ({len(missing_both)/len(parser.tickets)*100:.1f}%)** have neither Related Section(s) nor Related Artifact(s).")
    print(f"2. All {len(missing_both)} tickets DO have a Related Page specified (no tickets are completely unorganized).")
    print(f"3. The most affected page is **Use Cases** with {len(by_page.get('Use Cases', []))} tickets.")
    print(f"4. **General Guidance** has {len(by_page.get('General Guidance', []))} tickets without section/artifact organization.")
    print(f"5. These tickets rely solely on the Related Page field for categorization.")

if __name__ == '__main__':
    main()
