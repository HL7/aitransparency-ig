import re
import html
from collections import defaultdict

# Read the HTML file
file_path = r'c:\Users\johnm\Downloads\Jira 2026-01-26T11_11_56-0600.html'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Find all issue rows using regex
issue_pattern = re.compile(
    r'data-issuekey="(FHIR-\d+)".*?'
    r'<td class="summary"><p>\s*(.*?)\s*</p>.*?'
    r'<td class="customfield_11301">(.*?)\n',
    re.DOTALL
)

issues = []
for match in issue_pattern.finditer(content):
    key = match.group(1)
    summary = html.unescape(re.sub(r'<[^>]+>', '', match.group(2))).strip()
    related_page = match.group(3).strip()
    
    # Clean up related page field
    related_page = html.unescape(re.sub(r'<[^>]+>', '', related_page)).strip()
    if not related_page:
        related_page = '(No related page specified)'
    
    issues.append((key, summary, related_page))

# Print count
print(f'Total issues found: {len(issues)}')
print()

# Group by related page
by_page = defaultdict(list)
for key, summary, page in issues:
    by_page[page].append((key, summary))

# Print grouped results
for page in sorted(by_page.keys()):
    print(f'### {page}')
    print()
    for key, summary in by_page[page]:
        print(f'- **{key}**: {summary}')
    print()
