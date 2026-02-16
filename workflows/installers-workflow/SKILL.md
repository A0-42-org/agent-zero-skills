# Installers Workflow

Complete workflow for installing Agent Zero skills from external marketplaces (ClawHub and skills.sh).

## Use Case

Use this workflow when:
- Installing new skills from ClawHub marketplace
- Installing new skills from skills.sh marketplace
- Need to verify security of external skills
- Need to convert skills from different formats
- Want to automate skill installation process

## Workflow Overview

This workflow guides you through installing skills from external sources in 4 steps:

1. **Choose Marketplace** - Select ClawHub or skills.sh marketplace
2. **Download Skill** - Download skill from marketplace
3. **Security Analysis** - Analyze skill for security issues
4. **Install Skill** - Install skill into Agent Zero

## Prerequisites Skills

This workflow calls these skills conditionally based on your needs:
- `installers/clawhub` - Installing from ClawHub marketplace (OPTIONAL)
- `installers/skills-sh` - Installing from skills.sh marketplace (OPTIONAL)

## Step-by-Step Guide

### Step 1: Choose Marketplace

#### 1.1 ClawHub Marketplace

**Format**: ZIP files

**URL Format**: https://clawhub.org/skills/<skill-name>

**Advantages**:
- Provides downloadable ZIP files
- Easier to install
- Contains full skill structure

#### 1.2 skills.sh Marketplace

**Format**: HTML pages with embedded content

**URL Format**: https://skills.sh/skills/<skill-name>

**Advantages**:
- Larger marketplace
- More skills available
- Community-driven

**Disadvantages**:
- Requires HTML parsing
- More complex installation

### Step 2: Download Skill

#### 2.1 Download from ClawHub

```bash
# Using curl
curl -L https://clawhub.org/skills/<skill-name>/archive/refs/heads/main.zip -o skill-temp.zip

# Using wget
wget https://clawhub.org/skills/<skill-name>/archive/refs/heads/main.zip -O skill-temp.zip
```

#### 2.2 Download from skills.sh

```bash
# Download HTML page
curl -L https://skills.sh/skills/<skill-name> -o skill-temp.html
```

### Step 3: Security Analysis

#### 3.1 Check for Security Issues

Check for:

**API Keys**: `\b(?:sk-|ak-|api[_-]?key)\s*[=:]\s*[\w-]+`

**Passwords**: `\b(?:password|passwd|pwd)\s*[=:]\s*[\w-]+`

**Tokens**: `\b(?:bearer|token)\s*[=:]\s*[\w\.-]+`

**Dangerous Commands**: `\brm\s+-rf\s+/`

**Shell Commands**: `\b(?:curl|wget|nc\s+-l|bash\s+-i)`

#### 3.2 Security Report

Generate a security report showing:

| Check | Result |
|-------|--------|
| API Keys | ✅ SAFE / ⚠️ DETECTED |
| Passwords | ✅ SAFE / ⚠️ DETECTED |
| Tokens | ✅ SAFE / ⚠️ DETECTED |
| Dangerous Commands | ✅ SAFE / ⚠️ DETECTED |
| Shell Commands | ✅ SAFE / ⚠️ DETECTED |

### Step 4: Install Skill

#### 4.1 Install from ClawHub

```bash
# Extract ZIP file
unzip skill-temp.zip -d skill-temp

# Determine skill category
cd skill-temp

# Move skill to appropriate category
# Choose: core/, features/, patterns/, sveltekit/, workflows/
mv <skill-name> /a0/usr/skills/<category>/<skill-name>

# Clean up
cd ..
rm -rf skill-temp skill-temp.zip
```

#### 4.2 Install from skills.sh

```bash
# Parse HTML and extract content
python3 -c "
import re
from html import unescape

with open('skill-temp.html', 'r') as f:
    html_content = f.read()

# Extract content between <h1> and footer
h1_match = re.search(r'<h1[^>]*>([^<]+)</h1>', html_content)
if h1_match:
    title = h1_match.group(1)
    content_start = html_content.find('<h1', h1_match.end())
    content = html_content[content_start:]

    # Convert HTML to Markdown
    content = re.sub(r'<h1>', '# ', content)
    content = re.sub(r'<h2>', '## ', content)
    content = re.sub(r'<h3>', '### ', content)
    content = re.sub(r'<h4>', '#### ', content)
    content = re.sub(r'<li>', '- ', content)
    content = re.sub(r'<code>', '`', content)
    content = re.sub(r'</code>', '`', content)
    content = re.sub(r'<pre>', '`\n', content)
    content = re.sub(r'</pre>', '\n`', content)
    content = re.sub(r'<p>', '\n', content)
    content = re.sub(r'</p>', '\n', content)
    content = re.sub(r'<[^>]+>', '', content)
    content = unescape(content)
    content = re.sub(r'\n\n+', '\n\n', content)

    # Generate YAML frontmatter
    yaml = f'''---
name: {title}
description: Skill from skills.sh
version: 1.0.0
author: Unknown
tags: []
trigger_patterns:
  - {title.lower()}
---

'''

    # Save skill file
    with open(f'/a0/usr/skills/patterns/{title.lower()}/SKILL.md', 'w') as f:
        f.write(yaml + content)

    print(f'Installed skill: {title}')
"

# Clean up
rm skill-temp.html
```

#### 4.3 Commit Installation

```bash
# Add new skill to git
cd /a0/usr/skills
git add <category>/<skill-name>/

# Commit changes
git commit -m 'feat: add <skill-name> from <marketplace>'

# Push to GitHub
git push origin main
```

## Workflow Checklist

### Step 1: Choose Marketplace
- [ ] Marketplace selected (ClawHub or skills.sh)
- [ ] Skill URL identified

### Step 2: Download Skill
- [ ] Skill downloaded from marketplace
- [ ] File saved to temporary location

### Step 3: Security Analysis
- [ ] Security checks performed
- [ ] No security issues detected
- [ ] Security report generated

### Step 4: Install Skill
- [ ] Skill extracted or converted
- [ ] Skill moved to appropriate category
- [ ] Skill committed to git
- [ ] Changes pushed to GitHub

## Common Pitfalls

### 1. Not Verifying Security
```bash
# ❌ BAD - Installing without security check
unzip skill-temp.zip -d /a0/usr/skills/features/skill-name

# ✅ GOOD - Verifying security first
python3 security-check.py skill-temp.zip
# Only proceed if SAFE
unzip skill-temp.zip -d /a0/usr/skills/features/skill-name
```

### 2. Not Determining Correct Category
```bash
# ❌ BAD - Installing in wrong category
mv skill-name /a0/usr/skills/features/skill-name

# ✅ GOOD - Determining correct category first
# SvelteKit skills → sveltekit/
# Installers → installers/
# DevOps → devops/
# Content → content/
# Patterns → patterns/
# Workflows → workflows/
mv skill-name /a0/usr/skills/<correct-category>/skill-name
```

### 3. Not Committing to Git
```bash
# ❌ BAD - Not committing changes
mv skill-name /a0/usr/skills/features/skill-name
# Done

# ✅ GOOD - Committing changes
mv skill-name /a0/usr/skills/features/skill-name
cd /a0/usr/skills
git add features/skill-name/
git commit -m 'feat: add skill-name from marketplace'
git push origin main
```

### 4. Not Using GH CLI
```bash
# ❌ BAD - Using git push directly
git push origin main

# ✅ GOOD - Using git push (after git commit)
git commit -m 'feat: add skill-name from marketplace'
git push origin main
```

## Next Steps

After completing this workflow, you can:

1. **Test Skill** - Use newly installed skill
2. **Update Documentation** - Update SKILL.md if needed
3. **Share Skill** - Share skill with community
4. **Create Custom Skills** - Create your own skills using create-skill wizard

---
**Use this workflow to safely install skills from ClawHub and skills.sh marketplaces.**
