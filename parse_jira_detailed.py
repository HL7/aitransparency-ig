#!/usr/bin/env python3
"""
Parse Jira HTML export to extract detailed ticket information
"""
import re
from html.parser import HTMLParser
from collections import defaultdict
import json

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
                    text = re.sub(r'<[^>]+>', '', text)
                    self.current_ticket['summary'] = text
                elif self.current_field == 'customfield_11301':
                    self.current_ticket['related_pages'] = text if text and text != ' ' and text != '&nbsp;' else ''
                elif self.current_field == 'customfield_10518':
                    self.current_ticket['related_sections'] = text if text and text != ' ' and text != '&nbsp;' else ''
                    
            self.in_td = False
            self.current_field = None
            self.capture_text = False
            
    def handle_data(self, data):
        if self.capture_text and self.in_td:
            self.text_buffer.append(data)

def parse_jira_html(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    return parser.tickets

def organize_by_page_and_section(tickets):
    organized = defaultdict(lambda: defaultdict(list))
    
    for ticket in tickets:
        page = ticket.get('related_pages', '').strip()
        section = ticket.get('related_sections', '').strip()
        
        if not page or page in ['', '&nbsp;', ' ']:
            page = '(No Page Specified)'
        
        if not section or section in ['', '&nbsp;', ' ']:
            section = '(No Section Specified)'
            
        organized[page][section].append(ticket)
    
    return organized

def save_detailed_report(organized, output_file):
    """Save a detailed report to a markdown file"""
    
    sorted_pages = sorted(organized.keys(), key=lambda x: (x == '(No Page Specified)', x))
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Jira Tickets Analysis: AI Transparency IG\n\n")
        f.write("**Date:** 2026-01-26\n")
        f.write(f"**Total Tickets:** {sum(sum(len(tickets) for tickets in sections.values()) for sections in organized.values())}\n\n")
        f.write("---\n\n")
        
        f.write("## Table of Contents\n\n")
        for i, page in enumerate(sorted_pages, 1):
            sections = organized[page]
            page_total = sum(len(tickets) for tickets in sections.values())
            f.write(f"{i}. [{page}](#{page.lower().replace(' ', '-').replace('(', '').replace(')', '')}) ({page_total} tickets)\n")
        
        f.write("\n---\n\n")
        
        for page in sorted_pages:
            sections = organized[page]
            page_total = sum(len(tickets) for tickets in sections.values())
            
            f.write(f"## {page}\n\n")
            f.write(f"**Total tickets for this page:** {page_total}\n\n")
            
            sorted_sections = sorted(sections.keys(), key=lambda x: (x == '(No Section Specified)', x))
            
            for section in sorted_sections:
                tickets = sections[section]
                f.write(f"### {section}\n\n")
                f.write(f"*{len(tickets)} ticket{'s' if len(tickets) != 1 else ''}*\n\n")
                
                for ticket in sorted(tickets, key=lambda x: x.get('key', '')):
                    key = ticket.get('key', 'N/A')
                    summary = ticket.get('summary', 'N/A')
                    f.write(f"- **{key}**: {summary}\n")
                f.write("\n")
            
            f.write("---\n\n")
        
        # Summary statistics
        f.write("## Summary Statistics\n\n")
        f.write(f"- **Total Pages:** {len(sorted_pages)}\n")
        f.write(f"- **Total Tickets:** {sum(sum(len(tickets) for tickets in sections.values()) for sections in organized.values())}\n\n")
        
        f.write("### Tickets per Page\n\n")
        for page in sorted_pages:
            sections = organized[page]
            page_total = sum(len(tickets) for tickets in sections.values())
            f.write(f"- **{page}:** {page_total} tickets\n")
        
        f.write("\n### Section Breakdown\n\n")
        for page in sorted_pages:
            sections = organized[page]
            f.write(f"#### {page}\n\n")
            sorted_sections = sorted(sections.keys(), key=lambda x: (x == '(No Section Specified)', x))
            for section in sorted_sections:
                ticket_count = len(sections[section])
                f.write(f"- **{section}:** {ticket_count} ticket{'s' if ticket_count != 1 else ''}\n")
            f.write("\n")

def save_json_report(tickets, organized, output_file):
    """Save data as JSON for further processing"""
    data = {
        'total_tickets': len(tickets),
        'tickets': tickets,
        'organized': {
            page: {
                section: [
                    {
                        'key': t.get('key'),
                        'summary': t.get('summary'),
                        'related_pages': t.get('related_pages'),
                        'related_sections': t.get('related_sections')
                    }
                    for t in ticket_list
                ]
                for section, ticket_list in sections.items()
            }
            for page, sections in organized.items()
        }
    }
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

def main():
    html_file = r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html'
    markdown_output = r'c:\Users\johnm\git\HL7\aitransparency-ig\jira_tickets_analysis.md'
    json_output = r'c:\Users\johnm\git\HL7\aitransparency-ig\jira_tickets_data.json'
    
    print("Parsing Jira HTML file...")
    tickets = parse_jira_html(html_file)
    print(f"Found {len(tickets)} tickets\n")
    
    print("Organizing by page and section...")
    organized = organize_by_page_and_section(tickets)
    
    print(f"Saving detailed markdown report to: {markdown_output}")
    save_detailed_report(organized, markdown_output)
    
    print(f"Saving JSON data to: {json_output}")
    save_json_report(tickets, organized, json_output)
    
    print("\nDone!")
    
    # Print summary
    print(f"\nSummary:")
    print(f"- Total tickets: {len(tickets)}")
    print(f"- Total pages: {len(organized)}")
    
    sorted_pages = sorted(organized.keys(), key=lambda x: (x == '(No Page Specified)', x))
    for page in sorted_pages:
        sections = organized[page]
        page_total = sum(len(tickets) for tickets in sections.values())
        print(f"  • {page}: {page_total} tickets")

if __name__ == '__main__':
    main()
