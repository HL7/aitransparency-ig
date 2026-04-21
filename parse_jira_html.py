#!/usr/bin/env python3
"""
Parse Jira HTML export and extract tickets with fields:
- Ticket key (e.g., FHIR-55024)
- Summary/title
- Related Artifact(s) field (customfield_11300)
- Related Section(s) field (customfield_10518)
- Related Page(s) field (customfield_11301)

Organize tickets in priority order:
(a) FIRST: Group by Related Artifact(s) - tickets that have an artifact specified
(b) SECOND: Group by Related Section(s) within Related Page(s) - tickets that have no artifact but have a section
(c) THIRD: Group by Related Page(s) only - tickets that have neither artifact nor section
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
        self.in_tr = False
        self.in_td = False
        self.capture_text = False
        self.text_buffer = []
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == 'tr' and 'data-issuekey' in attrs_dict:
            self.in_tr = True
            self.current_ticket = {
                'key': attrs_dict.get('data-issuekey', ''),
                'summary': '',
                'artifact': '',
                'section': '',
                'page': ''
            }
        
        elif self.in_tr and tag == 'td':
            self.in_td = True
            self.text_buffer = []
            class_name = attrs_dict.get('class', '')
            
            if 'summary' in class_name:
                self.current_field = 'summary'
                self.capture_text = True
            elif 'customfield_11300' in class_name:
                self.current_field = 'artifact'
                self.capture_text = True
            elif 'customfield_10518' in class_name:
                self.current_field = 'section'
                self.capture_text = True
            elif 'customfield_11301' in class_name:
                self.current_field = 'page'
                self.capture_text = True
    
    def handle_endtag(self, tag):
        if tag == 'tr' and self.in_tr:
            if self.current_ticket.get('key'):
                self.tickets.append(self.current_ticket)
            self.in_tr = False
            self.current_ticket = {}
        
        elif tag == 'td' and self.in_td:
            if self.capture_text and self.current_field:
                text = ''.join(self.text_buffer).strip()
                # Clean up text
                text = re.sub(r'\s+', ' ', text)
                text = text.replace('&nbsp;', ' ').strip()
                self.current_ticket[self.current_field] = text
            self.in_td = False
            self.capture_text = False
            self.current_field = None
            self.text_buffer = []
    
    def handle_data(self, data):
        if self.capture_text:
            self.text_buffer.append(data)

def clean_text(text):
    """Clean up text content"""
    text = text.strip()
    text = re.sub(r'\s+', ' ', text)
    return text

def parse_html_file(filepath):
    """Parse the HTML file and return list of tickets"""
    with open(filepath, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    return parser.tickets

def organize_tickets(tickets):
    """
    Organize tickets into three categories:
    (a) Tickets with Related Artifact(s)
    (b) Tickets with Related Section(s) but no artifact
    (c) Tickets with Related Page(s) only (no artifact or section)
    """
    # Category A: Has artifact
    artifact_groups = defaultdict(list)
    
    # Category B: Has section but no artifact
    section_groups = defaultdict(lambda: defaultdict(list))
    
    # Category C: Has page but no artifact or section
    page_groups = defaultdict(list)
    
    # Category D: No artifact, section, or page
    no_grouping = []
    
    for ticket in tickets:
        has_artifact = bool(ticket.get('artifact', '').strip())
        has_section = bool(ticket.get('section', '').strip())
        has_page = bool(ticket.get('page', '').strip())
        
        if has_artifact:
            # Category A
            artifact_groups[ticket['artifact']].append(ticket)
        elif has_section:
            # Category B
            page = ticket.get('page', '(Unspecified Page)')
            section_groups[page][ticket['section']].append(ticket)
        elif has_page:
            # Category C
            page_groups[ticket['page']].append(ticket)
        else:
            # Category D
            no_grouping.append(ticket)
    
    return artifact_groups, section_groups, page_groups, no_grouping

def generate_markdown(tickets):
    """Generate markdown document from organized tickets"""
    artifact_groups, section_groups, page_groups, no_grouping = organize_tickets(tickets)
    
    lines = []
    lines.append("# AI Transparency IG - Jira Tickets Analysis")
    lines.append("")
    lines.append(f"**Total Tickets:** {len(tickets)}")
    lines.append(f"**Export Date:** 2026-01-26")
    lines.append("")
    lines.append("---")
    lines.append("")
    
    # Category A: Grouped by Artifact
    lines.append("## (A) Tickets Grouped by Related Artifact(s)")
    lines.append("")
    
    if artifact_groups:
        artifact_count = sum(len(tickets) for tickets in artifact_groups.values())
        lines.append(f"**Total tickets with artifacts:** {artifact_count}")
        lines.append("")
        
        for artifact in sorted(artifact_groups.keys()):
            tickets_list = artifact_groups[artifact]
            lines.append(f"### {artifact}")
            lines.append("")
            lines.append(f"*{len(tickets_list)} ticket(s)*")
            lines.append("")
            
            for ticket in sorted(tickets_list, key=lambda t: t['key'], reverse=True):
                summary = clean_text(ticket.get('summary', 'No summary'))
                lines.append(f"- [{ticket['key']}](https://jira.hl7.org/browse/{ticket['key']}) - {summary}")
            
            lines.append("")
    else:
        lines.append("*No tickets found with Related Artifact(s).*")
        lines.append("")
    
    lines.append("---")
    lines.append("")
    
    # Category B: Grouped by Section within Page
    lines.append("## (B) Tickets Grouped by Related Section(s) within Related Page(s)")
    lines.append("")
    lines.append("*Tickets that have a Related Section but no Related Artifact.*")
    lines.append("")
    
    if section_groups:
        section_count = sum(
            len(tickets) 
            for page_sections in section_groups.values() 
            for tickets in page_sections.values()
        )
        lines.append(f"**Total tickets with sections (no artifacts):** {section_count}")
        lines.append("")
        
        for page in sorted(section_groups.keys()):
            lines.append(f"### Page: {page}")
            lines.append("")
            
            for section in sorted(section_groups[page].keys()):
                tickets_list = section_groups[page][section]
                lines.append(f"#### Section: {section}")
                lines.append("")
                lines.append(f"*{len(tickets_list)} ticket(s)*")
                lines.append("")
                
                for ticket in sorted(tickets_list, key=lambda t: t['key'], reverse=True):
                    summary = clean_text(ticket.get('summary', 'No summary'))
                    lines.append(f"- [{ticket['key']}](https://jira.hl7.org/browse/{ticket['key']}) - {summary}")
                
                lines.append("")
    else:
        lines.append("*No tickets found with Related Section(s) but no Related Artifact(s).*")
        lines.append("")
    
    lines.append("---")
    lines.append("")
    
    # Category C: Grouped by Page only
    lines.append("## (C) Tickets Grouped by Related Page(s) Only")
    lines.append("")
    lines.append("*Tickets that have a Related Page but neither Related Artifact nor Related Section.*")
    lines.append("")
    
    if page_groups:
        page_count = sum(len(tickets) for tickets in page_groups.values())
        lines.append(f"**Total tickets with pages only (no artifacts or sections):** {page_count}")
        lines.append("")
        
        for page in sorted(page_groups.keys()):
            tickets_list = page_groups[page]
            lines.append(f"### Page: {page}")
            lines.append("")
            lines.append(f"*{len(tickets_list)} ticket(s)*")
            lines.append("")
            
            for ticket in sorted(tickets_list, key=lambda t: t['key'], reverse=True):
                summary = clean_text(ticket.get('summary', 'No summary'))
                lines.append(f"- [{ticket['key']}](https://jira.hl7.org/browse/{ticket['key']}) - {summary}")
            
            lines.append("")
    else:
        lines.append("*No tickets found with Related Page(s) only.*")
        lines.append("")
    
    lines.append("---")
    lines.append("")
    
    # Category D: No grouping
    if no_grouping:
        lines.append("## (D) Tickets with No Related Page, Section, or Artifact")
        lines.append("")
        lines.append(f"**Total tickets with no grouping:** {len(no_grouping)}")
        lines.append("")
        
        for ticket in sorted(no_grouping, key=lambda t: t['key'], reverse=True):
            summary = clean_text(ticket.get('summary', 'No summary'))
            lines.append(f"- [{ticket['key']}](https://jira.hl7.org/browse/{ticket['key']}) - {summary}")
        
        lines.append("")
    
    return '\n'.join(lines)

if __name__ == '__main__':
    html_file = r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html'
    
    print("Parsing HTML file...")
    tickets = parse_html_file(html_file)
    
    print(f"Found {len(tickets)} tickets")
    
    print("Generating markdown report...")
    markdown = generate_markdown(tickets)
    
    output_file = r'c:\Users\johnm\Desktop\ai-jira.md'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(markdown)
    
    print(f"Report generated: {output_file}")
