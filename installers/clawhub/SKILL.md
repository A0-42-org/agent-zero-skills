---
name: clawhub-installer
description: Download, analyze, and install skills from ClawHub. Automatically downloads
  ZIP from ClawHub URL, extracts, performs security analysis, and asks for user confirmation
  before installation.
trigger_patterns:
- clawhub
- install from clawhub
- download skill from clawhub
- clawhub marketplace
version: 1.0.0
author: Agent Zero Team
tags:
- skills
- installation
- automation
- security
- marketplace
---

# ClawHub Skill Installer

This skill automates the process of downloading, analyzing, and installing skills from ClawHub.

## Workflow

1. **Parse ClawHub URL** - Extract the slug from the URL (e.g., `steipete/obsidian` → `obsidian`)
2. **Download ZIP** - Download from `https://wry-manatee-359.convex.site/api/v1/download?slug=<slug>`
3. **Extract** - Extract ZIP to temporary directory
4. **Security Analysis** - Analyze for malicious code, secrets, dangerous commands
5. **Present Analysis** - Show analysis results to user
6. **Wait for Confirmation** - Ask user to confirm installation
7. **Install** - Copy to `/a0/usr/skills/<category>/`
8. **Commit and Push** - Commit and push to GitHub repository

## Step 1: Parse URL

Extract the slug from ClawHub URL:

| URL Format | Slug |
|-----------|-------|
| `https://clawhub.ai/steipete/obsidian` | `obsidian` |
| `https://clawhub.ai/owner/skill-name` | `skill-name` |

**Download URL**:
```bash
https://wry-manatee-359.convex.site/api/v1/download?slug=<slug>
```

## Step 2: Download ZIP

```python
import os
import requests
import zipfile

skill_slug = "obsidian"  # Extracted from URL
download_url = f"https://wry-manatee-359.convex.site/api/v1/download?slug={skill_slug}"

# Download to workdir
zip_path = "/a0/usr/workdir/skill-temp.zip"
response = requests.get(download_url)
with open(zip_path, 'wb') as f:
    f.write(response.content)
```

## Step 3: Extract ZIP

```python
import zipfile

# Extract to temp directory
extract_dir = "/a0/usr/workdir/skill-analysis"
os.makedirs(extract_dir, exist_ok=True)

with zipfile.ZipFile(zip_path, 'r') as zip_ref:
    zip_ref.extractall(extract_dir)
```

## Step 4: Security Analysis

### Checks to perform:

1. **File Structure** - Verify ZIP contains SKILL.md
2. **SKILL.md Format** - Check for YAML frontmatter
3. **Malicious Code** - Scan for dangerous patterns
4. **Secrets Detection** - Check for API keys, tokens, passwords
5. **Dangerous Commands** - Check for `rm -rf /`, `curl`, `wget`, etc.

### Security Checklist

```python
import re

skill_path = os.path.join(extract_dir, "SKILL.md")
with open(skill_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Security checks
checks = {
    "API Keys": bool(re.search(r'(?:sk-|ak-|api[_-]?key)\s*[=:]\s*[\w-]+', content, re.IGNORECASE)),
    "Passwords": bool(re.search(r'(?:password|passwd|pwd)\s*[=:]\s*[\w-]+', content, re.IGNORECASE)),
    "Tokens": bool(re.search(r'(?:bearer|token)\s*[=:]\s*[\w\.-]+', content, re.IGNORECASE)),
    "Dangerous Commands": bool(re.search(r'rm\s+-rf\s+/', content)),
    "Shell Commands": bool(re.search(r'(?:curl|wget|nc\s+-l|bash\s+-i)', content)),
}
```

## Step 5: Present Analysis

Present the following to the user:

| Check | Result |
|-------|--------|
| **Skill Name** | <name> |
| **Description** | <description> |
| **Version** | <version> |
| **Owner** | <owner> |
| **File Structure** | ✅ Valid / ❌ Invalid |
| **SKILL.md Format** | ✅ Valid / ❌ Invalid |
| **Malicious Code** | ✅ None detected / ❌ Suspicious |
| **Secrets Detected** | ✅ None / ❌ Found: <type> |
| **Dangerous Commands** | ✅ None / ❌ Found: <commands> |

### Recommendation

```markdown
**SECURITY STATUS**: ⚠️ **REVIEW REQUIRED** / ✅ **SAFE TO INSTALL**

**Files**: _meta.json, SKILL.md
**Content Summary**: [Brief description of what the skill does]

---

**Do you want to install this skill?**

Options:
- "yes" - Install the skill
- "no" - Cancel installation
```

## Step 6: Wait for Confirmation

Ask the user to confirm:

> Do you want to install this skill? (yes/no)


## Step 7: Install Skill

If user confirms:

### Determine Category

Based on skill description, determine category:

| Category | When to use |
|----------|-------------|
| `core/` | Essential functionality (auth, UI, database, bootstrap) |
| `features/` | Specific implementations (editor, theming, analytics, CI/CD tools) |
| `patterns/` | Best practices (components, forms, performance) |
| `workflows/` | Multi-step processes (auth setup, dashboard creation) |

### Install to Appropriate Directory

```python
# Determine category based on skill name/description
category = determine_category(skill_slug)  # Implement logic

install_dir = f"/a0/usr/skills/{category}/{skill_slug}"
os.makedirs(install_dir, exist_ok=True)

# Copy SKILL.md
import shutil
shutil.copy(os.path.join(extract_dir, "SKILL.md"), os.path.join(install_dir, "SKILL.md"))
```

## Step 8: Commit and Push

Use the `gh-cli` skill for GitHub operations:

```bash
cd /a0/usr/skills
git add <category>/<skill-name>/
git commit -m "feat: add <skill-name> from ClawHub"
git push origin main
```

## Example: Complete Workflow

### User Request:

> Install this skill from ClawHub: https://clawhub.ai/steipete/obsidian

### Agent Response:

1. **Extract slug**: `obsidian`
2. **Download**: `https://wry-manatee-359.convex.site/api/v1/download?slug=obsidian`
3. **Extract**: `/a0/usr/workdir/skill-analysis/`
4. **Analyze**:
   - File structure: ✅ Valid (_meta.json, SKILL.md)
   - SKILL.md format: ✅ Valid (YAML frontmatter)
   - Malicious code: ✅ None detected
   - Secrets: ✅ None detected
   - Dangerous commands: ✅ None detected
5. **Present analysis**:
   ```
   ## 🔍 Security Analysis

   | Check | Result |
   |-------|--------|
   | **Skill Name** | obsidian |
   | **Description** | [description from SKILL.md] |
   | **Version** | 1.0.0 |
   | **Owner** | steipete |
   | **File Structure** | ✅ Valid |
   | **SKILL.md Format** | ✅ Valid |
   | **Malicious Code** | ✅ None detected |
   | **Secrets** | ✅ None detected |
   | **Dangerous Commands** | ✅ None detected |

   **SECURITY STATUS**: ✅ **SAFE TO INSTALL**

   **Do you want to install this skill?** (yes/no)
   ```
6. **User confirms**: "yes"
7. **Install**:
   - Category: `features/` (utility tool)
   - Install to: `/a0/usr/skills/features/obsidian/SKILL.md`
8. **Commit and push**:
   ```bash
   git add features/obsidian/
   git commit -m "feat: add obsidian from ClawHub"
   git push origin main
   ```

## Important Notes

1. **ALWAYS ask for confirmation** before installing
2. **Perform thorough security analysis** before presenting to user
3. **Use the `gh-cli` skill** for all GitHub operations
4. **Determine category based on skill description**, not just name
5. **Clean up temporary files** after installation
6. **Use Python** for file operations (avoid `cat` with heredoc EOF)

## Cleanup

Remove temporary files after installation:

```python
import os
import shutil

os.remove(zip_path)
shutil.rmtree(extract_dir)
```

---
**Use this skill to safely download, analyze, and install skills from ClawHub with user confirmation.**
