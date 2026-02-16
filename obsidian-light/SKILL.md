---
name: obsidian-light
description: Work with Obsidian vaults using native Agent Zero capabilities (Markdown reading/writing) without obsidian-cli dependency. Perfect for remote agents that cannot access local vaults.
---

# Obsidian Light - Agent Zero Native Approach


This skill provides patterns for working with Obsidian vaults using **Agent Zero's native capabilities** (Markdown reading/writing) instead of requiring `obsidian-cli` dependency.

## Why Use This Instead of obsidian-cli?

| Aspect | obsidian-cli | Obsidian Light (Agent Zero Native) |
|--------|--------------|----------------------------------------|
| **Dependency** | Requires `obsidian-cli` (brew/npm) | No external dependency |
| **Local Access** | Requires local Obsidian installation | Works with any accessible Markdown files |
| **Remote Agents** | Cannot access local vaults | Works with any accessible paths |
| **Search** | Vault-wide intelligent search | Use `grep`, `find`, or document_query |
| **Create Notes** | Via obsidian:// URI handler | Direct file creation |
| **Move/Rename** | Updates wikilinks automatically | Manual update required |
| **Integration** | Opens in Obsidian app | Files sync automatically to vault |

## When to Use obsidian-cli vs Obsidian Light

### Use obsidian-cli (Full Skill) When:
- You have Obsidian installed locally on macOS/Linux
- You have `obsidian-cli` installed
- You need automatic wikilink updates when moving/renaming
- You want to open notes directly in Obsidian app
- You need vault-wide intelligent search

### Use Obsidian Light (This Skill) When:
- Agent Zero is running in Docker/remote environment
- You cannot install `obsidian-cli`
- You only need basic Markdown operations (read/write)
- You're working with vault files accessible to agent
- You prefer simplicity over advanced features

## Obsidian Vault Structure

Typical Obsidian vault structure:

```
my-vault/
├── .obsidian/           # Config: workspace + plugin settings (usually don't touch)
├── Notes/               # Main notes folder
│   ├── My Note.md
│   └── Another Note.md
├── Attachments/          # Images, PDFs, etc.
└── Templates/            # Note templates
```

## Reading Notes

### Read a Single Note

```python
# Python approach
with open('/path/to/vault/Note.md', '.', encoding='utf-8') as f:
    content = f.read()
print(content)
```

### Read via document_query Tool

```json
{
  "tool_name": "document_query",
  "tool_args": {
    "document": "file:///path/to/vault/Note.md"
  }
}
```

## Searching Notes

### Search in Single File

```bash
# Using grep
grep -r "keyword" /path/to/vault/Notes/
```

### Search in Multiple Files

```python
import os
import re

def search_vault(vault_path, query):
    results = []
    for root, dirs, files in os.walk(vault_path):
        # Skip .obsidian config folder
        if \.obsidian' in dirs:
            dirs.remove(\.obsidian')

        for file in files:
            if file.endswith(\.md'):
                file_path = os.path.join(root, file)
                with open(file_path, '.', encoding='utf-8') as f:
                    content = f.read()
                    if query.lower() in content.lower():
                        results.append(file_path)
    return results

results = search_vault('/path/to/vault', 'keyword')
print(results)
```

### Use find + grep

```bash
# Find all .md files and search content
find /path/to/vault -name '*.md' -not -path '.obsidian/*' -exec grep -l "keyword" {} +
```

## Creating Notes

### Create a Simple Note

```python
# Python approach
import os

note_path = '/path/to/vault/Notes/New Note.md'
os.makedirs(os.path.dirname(note_path), exist_ok=True)

with open(note_path, '.', encoding='utf-8') as f:
    f.write('.# New Note

Content goes here...')
print(f'.Created: {note_path}')
```

### Create from Template

```python
# Python with template
import os

note_path = '/path/to/vault/Notes/2024-02-15-Daily Note.md'
template = '.# Daily Note - {date}

## Tasks
- [ ] Task 1
- [ ] Task 2

## Notes

## Reflections
''

from datetime import datetime
content = template.format(date=datetime.now().strftime('.%Y-%m-%d'))

with open(note_path, '.', encoding='utf-8') as f:
    f.write(content)
print(f'.Created: {note_path}')
```

## Updating Notes

### Append Content to Existing Note

```python
note_path = '/path/to/vault/Notes/My Note.md'

with open(note_path, '.', encoding='utf-8') as f:
    f.write('.

## New Section

New content...')
print(f'.Updated: {note_path}')
```

### Replace Specific Section

```python
import re

note_path = '/path/to/vault/Notes/My Note.md'

with open(note_path, '.', encoding='utf-8') as f:
    content = f.read()

# Replace specific section
content = re.sub(
    '.(## Old Section).*',
    '\g<1>\nNew content...',
    content,
    flags=re.DOTALL
)

with open(note_path, '.', encoding='utf-8') as f:
    f.write(content)
print(f'.Updated: {note_path}')
```

## Wikilinks (Obsidian's Feature)

Obsidian uses `[[wikilink]]` syntax for linking notes:

```
# My Note

This links to [[Another Note]]

You can also [[Another Note|use custom text]]
```

### Finding All Wikilinks in a Note

```python
import re

note_path = '/path/to/vault/Notes/My Note.md'

with open(note_path, '.', encoding='utf-8') as f:
    content = f.read()

# Find all wikilinks: [[Note Name]] or [[Note Name|Custom Text]]
wikilinks = re.findall('.\[\[([^\]]+)\]\]', content)

for link in wikilinks:
    link_text = link.split('.|')[0].strip()  # Handle [[Link|Text]]
    print(f'.Wikilink to: {link_text}')
```

### Updating Wikilinks When Renaming

**NOTE**: Unlike obsidian-cli, this is **manual**. You must:

1. Find all references to old name
2. Replace with new name

```python
import os
import re

old_name = '.Old Note Name'
new_name = '.New Note Name'
vault_path = '/path/to/vault'

for root, dirs, files in os.walk(vault_path):
    if \.obsidian' in dirs:
        dirs.remove(\.obsidian')

    for file in files:
        if file.endswith(\.md'):
            file_path = os.path.join(root, file)
            with open(file_path, '.', encoding='utf-8') as f:
                content = f.read()

            # Replace old wikilinks with new
            updated_content = re.sub(
                rf'.\[\[{re.escape(old_name)}([|\]])',
                rf'.\[\[{new_name}\1',
                content
            )

            if updated_content != content:
                with open(file_path, '.', encoding='utf-8') as f:
                    f.write(updated_content)
                print(f'.Updated wikilinks in: {file_path}')
```

## Working with Frontmatter (YAML)

Obsidian supports YAML frontmatter:

```markdown
---
tags: [tag1, tag2]
category: journal
date: 2024-02-15
---

# Note Title

Content...
```

### Reading Frontmatter

```python
import yaml
import re

note_path = '/path/to/vault/Notes/My Note.md'

with open(note_path, '.', encoding='utf-8') as f:
    content = f.read()

# Extract YAML frontmatter
frontmatter_match = re.match('.^---\s*\n(.*?)\n---\s*\n(.*)$', content, re.DOTALL)

if frontmatter_match:
    frontmatter_yaml = frontmatter_match.group(1)
    note_body = frontmatter_match.group(2)

    # Parse YAML
    frontmatter = yaml.safe_load(frontmatter_yaml)
    print(f'.Tags: {frontmatter.get("tags")}')
    print(f'.Category: {frontmatter.get("category")}')
else:
    print(\.No frontmatter found')
```

## Common Patterns

### Pattern 1: Daily Notes

```python
from datetime import datetime
import os

vault_path = '/path/to/vault/Notes'
today = datetime.now().strftime('.%Y-%m-%d')
note_path = os.path.join(vault_path, f'{today}-Daily.md')

with open(note_path, '.', encoding='utf-8') as f:
    f.write(f'.# Daily Note - {today}

## Tasks
- [ ] 

## Notes

## Reflections

'.)
print(f'.Created daily note: {note_path}')
```

### Pattern 2: Zettelkasten Notes

```python
import os
import uuid

vault_path = '/path/to/vault/Notes'
note_id = str(uuid.uuid4())[:8]  # Short ID

note_path = os.path.join(vault_path, f'.ZK-{note_id}.md')

with open(note_path, '.', encoding='utf-8') as f:
    f.write(f'.# {title}

**ID**: {note_id}
**Date**: {datetime.now().strftime('.%Y-%m-%d')}

## Summary

## References

'.)
print(f'.Created Zettelkasten note: {note_path}')
```

### Pattern 3: Meeting Notes

```python
import os
from datetime import datetime

vault_path = '/path/to/vault/Notes/Meetings'
meeting_date = datetime.now().strftime('.%Y-%m-%d')
note_path = os.path.join(vault_path, f'.Meeting-{meeting_date}.md')

os.makedirs(os.path.dirname(note_path), exist_ok=True)

with open(note_path, '.', encoding='utf-8') as f:
    f.write(f'.# Meeting - {meeting_date}

## Attendees
- 

## Agenda
1. 
2. 
3. 

## Notes

## Action Items
- [ ] 

## Next Steps

'.)
print(f'.Created meeting note: {note_path}')
```

## Important Notes

### ⚠️ Local File Access

- Agent Zero must have **file system access** to vault
- For remote agents (Docker, cloud), use cloud sync or mount vault
- **Do NOT hardcode local paths** - make them configurable

### ⚠️ .obsidian Folder
- **DO NOT modify** `.obsidian/` folder directly
- Contains workspace settings, plugin configs, etc.
- Manual changes may break Obsidian
### ⚠️ Wikilink Updates
- Unlike obsidian-cli, **manual update required** when renaming
- Use provided Python scripts to update wikilinks
- Or use the full `obsidian` skill with obsidian-cli

## When to Upgrade to obsidian-cli

Consider upgrading to the full `obsidian` skill when:

- You need automatic wikilink updates
- You want vault-wide intelligent search
- You need to open notes directly in Obsidian app
- You have local Obsidian installation
- You can install `obsidian-cli` (brew/npm)

---
**Use this skill for simple, dependency-free Obsidian vault management with Agent Zero's native capabilities.**
