#!/usr/bin/env python3
"""
Parse Jira HTML export to find tickets with both Related Section(s) and Related Artifact(s) empty.
"""

import re
from html.parser import HTMLParser
from collections import defaultdict

class JiraHTMLParser(HTMLParser):
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
    parser = JiraHTMLParser()
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
    
    # Print results
    print(f"Total tickets analyzed: {len(parser.tickets)}")
    print(f"\n{'='*80}")
    print(f"Tickets with BOTH Related Section(s) AND Related Artifact(s) empty: {len(missing_both)}")
    print(f"{'='*80}\n")
    
    if missing_both:
        # Organize by Related Page
        by_page = defaultdict(list)
        for ticket in missing_both:
            page = ticket['page'] if ticket['page'] else '(No Page Specified)'
            by_page[page].append(ticket)
        
        print("DETAILED LIST:\n")
        for page, tickets in sorted(by_page.items()):
            print(f"\n--- Related Page: {page} ---")
            print(f"Count: {len(tickets)} tickets")
            for ticket in tickets:
                print(f"\n  {ticket['key']}")
                print(f"  Summary: {ticket['summary'][:100]}{'...' if len(ticket['summary']) > 100 else ''}")
        
        # Print pattern analysis
        print(f"\n\n{'='*80}")
        print("PATTERN ANALYSIS:")
        print(f"{'='*80}\n")
        
        print("Distribution by Related Page:")
        for page, tickets in sorted(by_page.items(), key=lambda x: len(x[1]), reverse=True):
            print(f"  {page}: {len(tickets)} tickets")
        
        # Check for other patterns
        print("\nTickets with NO page AND no section AND no artifact:")
        completely_empty = [t for t in missing_both if not t['page']]
        print(f"  Count: {len(completely_empty)}")
        if completely_empty:
            for ticket in completely_empty:
                print(f"    {ticket['key']}: {ticket['summary'][:80]}{'...' if len(ticket['summary']) > 80 else ''}")

if __name__ == '__main__':
    main()
