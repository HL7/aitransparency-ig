#!/usr/bin/env python3
"""
Parse Jira HTML export to extract ticket information with Related Page(s) and Related Section(s)
"""
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
        self.in_issuerow = False
        self.capture_text = False
        self.text_buffer = []
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == 'tr' and any(k == 'class' and 'issuerow' in v for k, v in attrs):
            self.in_issuerow = True
            self.current_ticket = {}
            # Extract issue key from data-issuekey attribute
            for k, v in attrs:
                if k == 'data-issuekey':
                    self.current_ticket['key'] = v
                    
        elif tag == 'td' and self.in_issuerow:
            self.in_td = True
            for k, v in attrs:
                if k == 'class':
                    self.current_field = v.strip()
                    self.capture_text = True
                    self.text_buffer = []
                    
    def handle_endtag(self, tag):
        if tag == 'tr' and self.in_issuerow:
            if self.current_ticket.get('key'):
                self.tickets.append(self.current_ticket.copy())
            self.in_issuerow = False
            self.current_ticket = {}
            
        elif tag == 'td' and self.in_td:
            if self.capture_text and self.current_field:
                text = ''.join(self.text_buffer).strip()
                
                if self.current_field == 'summary':
                    # Extract text from <p> tag
                    text = re.sub(r'<[^>]+>', '', text)
                    self.current_ticket['summary'] = text
                elif self.current_field == 'customfield_11301':
                    # Related Page(s)
                    self.current_ticket['related_pages'] = text if text and text != ' ' else ''
                elif self.current_field == 'customfield_10518':
                    # Related Section(s)
                    self.current_ticket['related_sections'] = text if text and text != ' ' else ''
                    
            self.in_td = False
            self.current_field = None
            self.capture_text = False
            
    def handle_data(self, data):
        if self.capture_text and self.in_td:
            self.text_buffer.append(data)

def parse_jira_html(filepath):
    """Parse the Jira HTML file and extract ticket information"""
    with open(filepath, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    return parser.tickets

def organize_by_page_and_section(tickets):
    """Organize tickets by page and section"""
    organized = defaultdict(lambda: defaultdict(list))
    
    for ticket in tickets:
        page = ticket.get('related_pages', '').strip()
        section = ticket.get('related_sections', '').strip()
        
        # Clean up the page name
        if not page or page in ['', '&nbsp;']:
            page = '(No Page Specified)'
        
        # Clean up the section name
        if not section or section in ['', '&nbsp;']:
            section = '(No Section Specified)'
            
        organized[page][section].append(ticket)
    
    return organized

def print_results(organized):
    """Print the organized results"""
    print("=" * 80)
    print("JIRA TICKETS ORGANIZED BY PAGE AND SECTION")
    print("=" * 80)
    print()
    
    # Sort pages
    sorted_pages = sorted(organized.keys(), key=lambda x: (x == '(No Page Specified)', x))
    
    total_tickets = 0
    
    for page in sorted_pages:
        sections = organized[page]
        page_total = sum(len(tickets) for tickets in sections.values())
        total_tickets += page_total
        
        print(f"\n{'='*80}")
        print(f"PAGE: {page}")
        print(f"Total tickets for this page: {page_total}")
        print(f"{'='*80}\n")
        
        # Sort sections
        sorted_sections = sorted(sections.keys(), key=lambda x: (x == '(No Section Specified)', x))
        
        for section in sorted_sections:
            tickets = sections[section]
            print(f"  SECTION: {section}")
            print(f"  ({len(tickets)} ticket{'s' if len(tickets) != 1 else ''})")
            print(f"  {'-'*76}")
            
            for ticket in sorted(tickets, key=lambda x: x.get('key', '')):
                key = ticket.get('key', 'N/A')
                summary = ticket.get('summary', 'N/A')
                print(f"    • {key}: {summary}")
            print()
    
    print(f"\n{'='*80}")
    print(f"TOTAL: {total_tickets} tickets across {len(sorted_pages)} pages")
    print(f"{'='*80}\n")

def main():
    html_file = r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html'
    
    print("Parsing Jira HTML file...")
    tickets = parse_jira_html(html_file)
    print(f"Found {len(tickets)} tickets\n")
    
    print("Organizing by page and section...")
    organized = organize_by_page_and_section(tickets)
    
    print_results(organized)

if __name__ == '__main__':
    main()
