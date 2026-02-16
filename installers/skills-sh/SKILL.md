---
name: skills-sh-installer
description: Download, analyze, and install skills from skills.sh marketplace. Skills from skills.sh are EMBEDDED in HTML (not ZIP files), so this skill extracts HTML content, checks for Agent Zero format, converts if needed, performs security analysis, and asks for user confirmation before installation.
version: "1.0.0"
author: "Agent Zero"
tags: ["skills", "installation", "automation", "security", "skills.sh", "marketplace"]
trigger_patterns:
  - "add skill from skills.sh"
  - "install skills.sh skill"
  - "download from skills.sh"
  - "skills.sh marketplace"
---

# Skills.sh Installer


This skill automates the process of downloading, analyzing, and installing skills from the **skills.sh** marketplace.

## skills.sh vs ClawHub


| Aspect | skills.sh | ClawHub |
|--------|----------|----------|
| **Format** | HTML-embedded content | ZIP files |
| **Download URL** | Direct page (e.g., `https://skills.sh/subsy/ralph-tui/ralph-tui-prd`) | API endpoint (e.g., `https://wry-manatee-359.convex.site/api/v1/download?slug=slug`) |
| **Extraction** | Extract HTML content | Unzip archive |
| **Skill Format** | Often NOT in Agent Zero format | Usually Agent Zero format |
| **Conversion Needed** | YES (frequently) | RARELY |


**CRITICAL DIFFERENCE**: skills.sh skills are EMBEDDED in HTML pages, NOT provided as ZIP downloads.


## Workflow


1. **Parse skills.sh URL** - Extract the full skill path
2. **Download HTML** - Fetch the page from skills.sh
3. **Extract SKILL.md Content** - Parse HTML to extract skill documentation
4. **Check Format** - Verify if it has Agent Zero YAML frontmatter
5. **Convert if Needed** - Add YAML frontmatter (name, description, version, author, tags, trigger_patterns)
6. **Security Analysis** - Check for malicious code, secrets, dangerous commands
7. **Present Analysis** - Show findings and recommendation to user
8. **Wait for Confirmation** - Ask user to confirm installation
9. **Install** - Copy to appropriate directory in `/a0/usr/skills/`
10. **Commit and Push** - Commit and push to GitHub repository


## Step 1: Parse skills.sh URL


Extract the skill path from skills.sh URL:

| Input URL | Skill Path |
|-----------|-------------|
| `https://skills.sh/subsy/ralph-tui/ralph-tui-prd` | `subsy/ralph-tui/ralph-tui-prd` |
| `https://skills.sh/owner/skill-name` | `owner/skill-name` |

**Download URL**: Use the full URL directly (no API endpoint like ClawHub).


## Step 2: Download HTML


```python
import requests


url = "https://skills.sh/subsy/ralph-tui/ralph-tui-prd"

response = requests.get(url)

html_content = response.text
```


## Step 3: Extract SKILL.md Content


**Challenge**: The skill content is EMBEDDED in the HTML page, not in a separate file.


**Approach**:
1. Search for the `<h1>` tag with the skill title
2. Extract all content from that `<h1>` to the end of the skill documentation
3. Remove HTML tags and convert to Markdown
4. Clean up whitespace and formatting


**Example Extraction Code**:
```python
import re
from html import unescape

# Find the main skill content (starts with h1 title)
h1_match = re.search(r'<h1[^>]*>([^<]+)</h1>', html_content)

if h1_match:
    content_start = h1_match.end()
    # Find end of content (before footer or next major section)
    # Extract content
    raw_content = html_content[content_start:content_end]
    # Convert HTML to Markdown
    raw_content = re.sub(r'<h1[^>]*>([^<]+)</h1>', r'\n# \1\n', raw_content)
    raw_content = re.sub(r'<h2[^>]*>([^<]+)</h2>', r'\n## \1\n', raw_content)
    raw_content = re.sub(r'<h3[^>]*>([^<]+)</h3>', r'\n### \1\n', raw_content)
    raw_content = re.sub(r'<li[^>]*>([^<]+)</li>', r'- \1\n', raw_content)
    raw_content = re.sub(r'<p[^>]*>([^<]+)</p>', r'\n\1\n', raw_content)
    raw_content = re.sub(r'<br[^>]*>', '\n', raw_content)
    # Remove all remaining HTML tags
    raw_content = re.sub(r'<[^>]+>', '', raw_content)
    # Unescape HTML entities
    raw_content = unescape(raw_content)
```

## Step 4: Check Format


**Agent Zero SKILL.md Format**:

```yaml
---
name: "skill-name"
description: "Description of what this skill does"
version: "1.0.0"
author: "Author Name"
tags: ["tag1", "tag2"]
trigger_patterns:
  - "keyword1"
  - "phrase"
---

# Skill Title

Skill instructions...
```

**Check for YAML Frontmatter**:
```python
if not re.match(r'^---\s*\n', content):
    # NOT in Agent Zero format - needs conversion
    needs_conversion = True
```

## Step 5: Convert if Needed


**Most skills.sh skills are NOT in Agent Zero format.** They lack YAML frontmatter.


**Conversion Steps**:
1. Extract skill title from first heading
2. Extract description from first paragraph or title attribute
3. Determine appropriate category (core/features/patterns/workflows)
4. Generate YAML frontmatter:

```yaml
---
name: "skill-name-from-title"
description: "Description from first paragraph or meta tag"
version: "1.0.0"
author: "from skills.sh URL (owner/skill)"
tags: ["category1", "category2"]
trigger_patterns:
  - "keyword1"
  - "phrase"
---
```
5. Prepend YAML frontmatter to content

**Example**: Converting `ralph-tui-prd`:

```yaml
---
name: ralph-tui-prd-generator
description: Generate detailed Product Requirements Documents optimized for AI agent execution. Ask clarifying questions, create structured PRDs with quality gates, and output in [PRD]...[/PRD] markers.
version: "1.0.0"
author: "subsy/ralph-tui"
tags: ["prd", "requirements", "documentation", "workflow"]
trigger_patterns:
  - "create prd"
  - "product requirements"
  - "prd generator"
  - "requirements document"
---

[Original content from skills.sh...]
```

## Step 6: Security Analysis


### Checks to perform:

1. **Malicious Code** - Scan for dangerous patterns
2. **Secrets Detection** - Check for API keys, tokens, passwords
3. **Dangerous Commands** - Check for `rm -rf /`, `curl`, `wget`, etc.
4. **Shell Commands** - Check for shell execution attempts
5. **Scripts** - Check for executable scripts


### Security Checklist

```python
import re

checks = {
    "API Keys": bool(re.search(r'\b(?:sk-|ak-|api[_-]?key)\s*[=:]\s*[\w-]+', content)),
    "Passwords": bool(re.search(r'\b(?:password|passwd|pwd)\s*[=:]\s*[\w-]+', content)),
    "Tokens": bool(re.search(r'\b(?:bearer|token)\s*[=:]\s*[\w.\-]+', content)),
    "Dangerous Commands": bool(re.search(r'\brm\s+-rf\s+/', content)),
    "Shell Commands": bool(re.search(r'(?:curl|wget|nc\s+-l|bash\s+-i)', content)),
}
```

## Step 7: Present Analysis


Present the following to the user:

| Check | Result |
|-------|--------|
| **Skill Name** | <name> |
| **Description** | <description> |
| **Format** | ✅ Agent Zero / ❌ Needs Conversion |
| **Conversion Applied** | <details if converted> |
| **Malicious Code** | ✅ None / ❌ Suspicious |
| **Secrets Detected** | ✅ None / ❌ Found: <type> |
| **Dangerous Commands** | ✅ None / ❌ Found: <commands> |
| **Recommended Category** | <category> |

### Recommendation

```markdown
**SECURITY STATUS**: ⚠️ **REVIEW REQUIRED** / ✅ **SAFE TO INSTALL**

**FORMAT STATUS**: ✅ **AGENT ZERO COMPATIBLE** / ⚠️ **NEEDS CONVERSION**

**Converted Content**: <yes/no> - If converted, explain what was added (YAML frontmatter, tags, triggers)


**Do you want to install this skill?**

Options:
- "yes" - Install the skill
- "no" - Cancel installation
- "modify" - Install with specific changes (specify what)
```

## Step 8: Wait for Confirmation

Ask the user to confirm:

> Do you want to install this skill? (yes/no/modify)


## Step 9: Install Skill

If user confirms:

### Determine Category

Based on skill description, determine category:

| Category | When to use |
|----------|-------------|
| `core/` | Essential functionality (auth, UI, database, bootstrap) |
| `features/` | Specific implementations (editor, theming, analytics, marketplace installers) |
| `patterns/` | Best practices (components, forms, performance, documentation generation) |
| `workflows/` | Multi-step processes (auth setup, dashboard creation) |

### Install to Appropriate Directory

```python
import os

# Determine category based on skill name/description
category = determine_category(skill_slug)  # Implement logic


install_dir = f"/a0/usr/skills/{category}/{skill_slug}"
os.makedirs(install_dir, exist_ok=True)

# Copy SKILL.md
import shutil
shutil.copy(skill_file, os.path.join(install_dir, "SKILL.md"))
```

## Step 10: Commit and Push

Use the `gh-cli` skill for GitHub operations:

```bash
cd /a0/usr/skills
git add <category>/<skill-name>/
git commit -m "feat: add <skill-name> from skills.sh"
git push origin main
```

## Example: Complete Workflow

### User Request:

> Add this skill from skills.sh: https://skills.sh/subsy/ralph-tui/ralph-tui-prd

### Agent Response:

1. **Download**: Fetch HTML from `https://skills.sh/subsy/ralph-tui/ralph-tui-prd`
2. **Extract**: Parse HTML to extract SKILL.md content
3. **Check Format**: No YAML frontmatter found - needs conversion
4. **Convert**: Add YAML frontmatter:
   ```yaml
   ---
   name: ralph-tui-prd-generator
   description: Generate detailed PRDs optimized for AI agent execution
   version: "1.0.0"
   author: "subsy/ralph-tui"
   tags: ["prd", "requirements", "documentation"]
   trigger_patterns:
     - "create prd"
     - "prd generator"
   ---
   ```
5. **Analyze**:
   - ✅ No malicious code
   - ✅ No secrets detected
   - ✅ No dangerous commands
6. **Present**:
   ```
   ## Security Analysis
   | Check | Result |
   |-------|--------|
   | **Skill Name** | ralph-tui-prd-generator |
   | **Format** | ⚠️ Needs Conversion |
   | **Converted** | ✅ Added YAML frontmatter, tags, triggers |
   | **Security** | ✅ Safe |

   **Do you want to install?** (yes/no)
   ```
7. **User confirms**: "yes"
8. **Install**:
   - Category: `patterns/` (best practice for documentation generation)
   - Install to: `/a0/usr/skills/patterns/ralph-tui-prd-generator/SKILL.md`
9. **Commit and push**:
   ```bash
   git add patterns/ralph-tui-prd-generator/
   git commit -m "feat: add ralph-tui-prd-generator from skills.sh"
   git push origin main
   ```

## Important Notes


1. **ALWAYS ask for confirmation** before installing
2. **Perform thorough security analysis** before presenting to user
3. **skills.sh skills frequently need conversion** - Add YAML frontmatter
4. **Use the `gh-cli` skill** for all GitHub operations
5. **Determine category based on skill description**, not just name
6. **Clean up temporary files** after installation
7. **Use Python** for file operations (avoid `cat` with heredoc EOF)

## Cleanup

Remove temporary files after installation:

```python
import os
import shutil

os.remove(html_temp_file)
if os.path.exists(extract_dir):
    shutil.rmtree(extract_dir)
```

## Comparison: skills.sh vs ClawHub vs Direct Creation

| Aspect | skills.sh | ClawHub | Direct Creation (create-skill) |
|--------|----------|----------|-------------------------------|
| **Format** | HTML-embedded | ZIP | N/A |
| **Conversion** | FREQUENTLY needed | RARELY needed | N/A |
| **Security** | Automated analysis | Automated analysis | Automated checks |
| **User Confirmation** | YES (required) | YES (required) | YES (required) |
| **Git Workflow** | Automated | Automated | Automated |
| **Best for** | Community skills from skills.sh | Community skills from ClawHub | Creating new skills from scratch |

---
**Use this skill to safely download, analyze, convert (if needed), and install skills from skills.sh with user confirmation.**
