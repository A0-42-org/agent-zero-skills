---
name: "create-skill"
description: "Wizard for creating new Agent Zero skills with modular architecture (core, features, patterns, workflows). Guides through skill creation, Git workflow, and security checks."
version: "2.0.0"
author: "Agent Zero Team"
tags: ["meta", "wizard", "creation", "skills", "security", "git"]
trigger_patterns:
  - "create skill"
  - "new skill"
  - "make skill"
  - "add skill"
  - "skill wizard"
---

# Create Skill Wizard

This skill helps you create new Agent Zero skills that follow the SKILL.md standard and the modular architecture.

## Quick Start

To create a new skill, I'll guide you through these steps:

1. **Category Selection** - Choose core/, features/, patterns/, or workflows/
2. **Name & Purpose** - What should this skill do?
3. **Trigger Patterns** - When should this skill activate?
4. **Content Structure** - What instructions should the agent follow?
5. **Security Check** - Ensure no sensitive data is included
6. **Git Workflow** - Commit and push to repository automatically

## Modular Architecture

Skills are organized in a modular structure at `/a0/usr/skills/`:

```
/a0/usr/skills/
├── core/          # Essential skills (auth, UI framework, database, bootstrap)
├── features/      # Specific implementations (editor, theming, analytics, payments)
├── patterns/      # Best practices (components, forms, server-actions, performance)
└── workflows/     # Multi-step processes (auth setup, dashboard creation, admin)
```

### Category Guidelines

| Category | Purpose | Examples |
|----------|---------|----------|
| `core/` | Essential, foundational functionality | `better-auth-svelte`, `skeleton-ui-svelte`, `sveltekit-database`, `sveltekit-bootstrap` |
| `features/` | Specific feature implementations | `sveltekit-theming`, `sveltekit-dnd-dashboard`, `sveltekit-analytics` |
| `patterns/` | Best practices and code patterns | `sveltekit-components`, `sveltekit-forms`, `sveltekit-server-actions`, `sveltekit-performance` |
| `workflows/` | Multi-step processes combining multiple skills | `dashboard-creation-workflow`, `auth-setup-workflow` |

## SKILL.md Format

Every skill needs a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: "skill-name"
description: "Clear description of what this skill does and when to use it"
version: "1.0.0"
author: "Agent Zero Team"
tags: ["category1", "category2"]
trigger_patterns:
  - "keyword1"
  - "phrase that triggers this"
---

# Skill Title

Your skill instructions go here...
```

## Required Fields

| Field | Description | Example |
|-------|-------------|---------|
| `name` | Unique identifier (lowercase, hyphens) | `"sveltekit-components"` |
| `description` | When/why to use this skill | `"Reusable component patterns for Svelte 5 with best practices"` |

## Optional Fields

| Field | Description | Example |
|-------|-------------|---------|
| `version` | Semantic version | `"1.0.0"` |
| `author` | Creator name | `"Agent Zero Team"` |
| `tags` | Categorization keywords | `["sveltekit", "components", "svelte-5"]` |
| `trigger_patterns` | Words/phrases that activate skill | `["component", "reusable", "svelte 5"]` |

## Naming Conventions

### Skill Names

- **SvelteKit skills**: Prefix with `sveltekit-` (e.g., `sveltekit-components`, `sveltekit-database`)
- **Framework-specific skills**: Prefix with framework name (e.g., `better-auth-svelte`, `skeleton-ui-svelte`)
- **General skills**: Descriptive name (e.g., `code-review`, `data-analysis`)
- **Workflow skills**: Suffix with `-workflow` (e.g., `dashboard-creation-workflow`)

### Examples

```
✅ GOOD:
- sveltekit-components
- sveltekit-forms
- better-auth-svelte
- dashboard-creation-workflow

❌ BAD:
- ComponentsSkill
- SvelteKit-Forms
- auth_skill
- dashboardWorkflow
```


## Git Workflow

After creating a skill, you MUST commit and push it to the repository.

### Use gh-cli Skill

**IMPORTANT**: Use the `gh-cli` skill for all GitHub operations.

Load the skill: `skills_tool:load({ skill_name: "gh-cli" })`

The `gh-cli` skill handles:
- Creating repositories
- Committing and pushing changes
- Creating labels, issues, and pull requests
- Managing repositories

### Repository Info

- **Organization**: A0-42-org
- **Repository**: https://github.com/A0-42-org/agent-zero-skills
- **Location**: `/a0/usr/skills/`

**ALWAYS** create repositories and push to `A0-42-org` organization (NOT personal account).

## Skill Directory Structure

```
/a0/usr/skills/
└── category-name/
   └── skill-name/
       ├── SKILL.md           # Required: Main skill file
       ├── scripts/           # Optional: Helper scripts
       │   ├── helper.py
       │   └── process.sh
       ├── templates/         # Optional: Templates
       │   └── output.md
       └── docs/              # Optional: Additional docs
          └── examples.md
```

## Writing Good Skill Instructions

### Be Specific and Actionable

```markdown
# Good
When creating Svelte 5 components:
1. Use $props() for props definition
2. Use $state() for reactive state
3. Use $derived() for computed values
4. Use $effect() for side effects

# Bad
Create components with Svelte 5 syntax.
```

### Include Examples

```markdown
## Example Component

```svelte
<script lang="ts">
  interface Props {
    title: string;
    count?: number;
  }
  
  let { title, count = 0 }: Props = $props();
  const doubled = $derived(count * 2);
</script>

<h1>{title}</h1>
<p>Count: {count}, Doubled: {doubled}</p>
```
```

### Provide Checklists

```markdown
## Component Checklist
- [ ] Props defined with $props()
- [ ] State uses $state()
- [ ] Derived values use $derived()
- [ ] Event handlers use onclick/oninput
- [ ] Component exported if needed
```

## ⚠️ Security: Handling Sensitive Data

### CRITICAL RULE: Never Include Secrets in Skills

When creating a skill, **NEVER** hardcode sensitive information in the `SKILL.md` file or examples.

**Forbidden Data (Do NOT include):**
- API Keys (e.g., `sk-123...`, `x-api-key`, `AKIAIOSFODNN7EXAMPLE`)
- Passwords (e.g., `mypassword`, `admin123`)
- Tokens (e.g., `Bearer eyJhb...`, refresh tokens)
- Private Internal URLs (unless public documentation examples)
- Personal Credentials (Usernames/Passwords)

### What to Do Instead:

**1. Use Placeholders or Variables**
Indicate where the variable should come from.

```bash
# ❌ BAD - Hardcoded Secret
curl -H "Authorization: Bearer sk-1234567890abcdefghij"

# ✅ GOOD - Variable Placeholder
curl -H "Authorization: Bearer $API_KEY"
```

**2. Describe Required Variable**
Explain clearly what the user needs to set up.

```yaml
# Required Environment Variables
# MY_API_KEY: Your secret API key from provider settings
# DB_PASSWORD: Secure password for database instance
```

**3. Use Agent Zero Secret Placeholders**
For operational use, rely on Agent Zero's secret management (using the replacement syntax) in prompts, not hardcoded values in documentation.

```markdown
# Use secret aliases in your tool calls:
# The system will automatically replace secrets with real values.
# Format: variable_name (without the prefix)
```

## Creating Your Skill: Step by Step

### Step 1: Choose Category

Select the appropriate category:

- **core/** - Essential functionality (auth, UI, database)
- **features/** - Specific implementations (editor, analytics, theming)
- **patterns/** - Best practices (components, forms, performance)
- **workflows/** - Multi-step processes (dashboard creation, auth setup)

### Step 2: Define Purpose

Answer these questions:
- What problem does this skill solve?
- When should the agent use it?
- What's the expected output?

### Step 3: Choose a Name

- Use lowercase letters and hyphens
- Prefix with `sveltekit-` for SvelteKit skills
- Be descriptive but concise
- Examples: `sveltekit-components`, `better-auth-svelte`, `dashboard-creation-workflow`

### Step 4: Write Trigger Patterns

List words/phrases that should activate this skill:

```yaml
trigger_patterns:
  - "create component"
  - "reusable component"
  - "svelte 5 component"
  - "component pattern"
```

### Step 5: Structure Your Content

Organize with clear sections:

```markdown
# Skill Title

## Use Case
When to use this skill

## Installation
Packages and setup

## Patterns
Step-by-step instructions

## Examples
Show sample code

## Common Pitfalls
What to avoid
```

### Step 6: Add Supporting Files (Optional)

If your skill needs scripts or templates:

```bash
# Create directory structure
mkdir -p /a0/usr/skills/category/skill-name/{scripts,templates,docs}
```

### Step 7: Security Check ⚠️

Before saving your skill, verify it contains **NO sensitive data**:

**Checklist:**
- [ ] No API keys or tokens in examples
- [ ] No passwords or secrets in code snippets
- [ ] Private IPs or internal URLs are anonymized or generic
- [ ] Credentials are referenced via variables (e.g., `$TOKEN`, `$API_KEY`)
- [ ] I have not copied/pasted any `.env` content directly into the file

### Step 8: Git Workflow

Commit and push the skill to the repository:

```bash
# Navigate to skills directory
cd /a0/usr/skills

# Stage the skill
git add category/skill-name/

# Commit with descriptive message
git commit -m "feat: add skill-name description"

# Push to origin
git push origin main

# Verify
git log --oneline -3
git status
```

## Existing Skills Reference

### Core Skills
- `better-auth-svelte` - Authentication with BetterAuth and SvelteKit
- `skeleton-ui-svelte` - Skeleton UI v4 with Tailwind CSS v4
- `sveltekit-database` - Drizzle ORM with PostgreSQL
- `sveltekit-bootstrap` - Project initialization and setup

### Feature Skills
- `sveltekit-theming` - Theme management with Skeleton UI v4
- `sveltekit-dnd-dashboard` - Sortable dashboards with drag-and-drop
- `sveltekit-analytics` - Event tracking and analytics dashboards

### Pattern Skills (To Be Created)
- `sveltekit-components` - Reusable component patterns
- `sveltekit-forms` - Form handling and validation
- `sveltekit-server-actions` - Server actions and progressive enhancement
- `sveltekit-performance` - Performance optimization patterns

### Workflow Skills (To Be Created)
- `dashboard-creation-workflow` - Multi-step dashboard creation process

## Skill Installation

### Local Installation

1. Create skill directory:
   ```bash
   mkdir -p /a0/usr/skills/category/skill-name
   ```

2. Create SKILL.md:
   ```bash
   touch /a0/usr/skills/category/skill-name/SKILL.md
   ```

3. Add content and save

4. Skills are automatically loaded on next agent initialization

### Sharing Skills

To share skills with others:

1. Create a GitHub repository
2. Include the skill directory structure
3. Add a README with installation instructions
4. Users can copy to their `/a0/usr/skills/` directory

## Testing Your Skill

After creating a skill:

1. Commit and push to repository
2. Start a new conversation
3. Use one of your trigger patterns
4. Verify that the agent follows your instructions
5. Iterate and improve based on results

## Global Skills

**Important**: Skills are **global resources** that can be used by **any agent**, not just the Svelte agent.

- Location: `/a0/usr/skills/`
- Accessible by all agents (default, developer, researcher, hacker, svelte, agent0)
- Design skills to be framework-agnostic when possible
- Specify framework-specific requirements in the skill description


## Best Practices for File Creation

### ⚠️ AVOID `cat` with Heredoc EOF for Long Content

When creating skill files or writing long content:

**DO NOT USE:**
```bash
# ❌ BAD - Causes EOF issues with long content
cat > /a0/usr/skills/skill-name/SKILL.md << 'EOF'
[very long content here...]
EOF
```

**INSTEAD, USE:**

1. **Python** (Recommended for long content):
```python
import os

content = """your long content here..."""

with open('/a0/usr/skills/skill-name/SKILL.md', 'w', encoding='utf-8') as f:
    f.write(content)
```

2. **OpenCode** (For complex multi-file tasks):
- Load the opencode skill: `skills_tool:load({ skill_name: "opencode" })`
- Use the build agent for file creation
- More stable for long content and avoids EOF issues

3. **echo** (For very short content only):
```bash
echo 'short content' > file.txt
```

**Why Avoid `cat` Heredoc EOF?**
- Causes blocking issues with long content
- Unpredictable behavior with special characters
- Difficult to debug when content gets truncated
- Python and OpenCode are more reliable and stable

---
**Use this skill to create well-structured, documented skills that follow the SKILL.md standard and modular architecture.**
