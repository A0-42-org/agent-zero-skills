---
name: "create-skill"
description: "Wizard for creating new Agent Zero skills with modular architecture. Guides through skill creation, Git workflow, and security checks with updated structure."
version: "3.0.0"
author: "Agent Zero Team"
tags: ["meta", "wizard", "creation", "skills", "security", "git"]
trigger_patterns:
  - "create skill"
  - "new skill"
  - "make skill"
  - "add skill"
  - "skill wizard"
  - "créer skill"  # French
  - "nouveau skill"  # French
  - "création skill"  # French
---

# Create Skill Wizard

This skill helps you create new Agent Zero skills that follow SKILL.md standard and modular architecture.

## Prerequisites

### Package Manager: Bun

This skill uses **Bun** as the package manager. Before running any commands, verify that bun is installed:

```bash
bun --version
```

#### Failsafe: Installing Bun

If bun is not installed, run the initialization script:

```bash
bash /a0/usr/init-tools.sh
```

This script will automatically install:
- Bun (JavaScript package manager)
- GitHub CLI (gh)

### Why Bun?

- **Fast**: Bun is faster than npm and pnpm
- **Compatible**: Works with all npm packages
- **Standard**: All Agent Zero skills use bun

### Common Bun Commands

| Command | Description |
|---------|-------------|
| `bun install` | Install dependencies |
| `bun add <package>` | Add dependency |
| `bun add -D <package>` | Add dev dependency |
| `bun run <script>` | Run npm script |
| `bunx <package>` | Execute npm package directly |
| `bun create <template>` | Create new project |
| `bun dev` | Start dev server |
| `bun build` | Build project |
| `bun test` | Run tests |

---


## Quick Start

To create a new skill, I'll guide you through these steps:

1. **Category Selection** - Choose the right folder for your skill
2. **Name & Purpose** - What should this skill do?
3. **Trigger Patterns** - When should this skill activate? (Bilingual: English + French)
4. **Content Structure** - What instructions should the agent follow?
5. **Security Check** - Ensure no sensitive data is included
6. **Git Workflow** - Commit and push to repository automatically

## Updated Skills Structure

Skills are organized in a modular structure at `/a0/usr/skills/`:

```
/a0/usr/skills/
├── sveltekit/       # SvelteKit development skills (14 skills)
├── devops/          # DevOps, Git & CI/CD skills (4 skills)
├── installers/      # Skill installers (ClawHub, skills.sh) (2 skills)
├── workflows/        # Meta-skills & multi-step processes (5 skills)
├── content/         # Content creation skills (1 skill)
└── (root)          # General tools & utilities (9 skills)
```

### Category Guidelines

| Category | Purpose | Examples |
|----------|---------|----------|
| `sveltekit/` | Svelte 5, SkeletonUI v4, Tailwind CSS v4 | `bootstrap`, `skeleton-ui`, `database`, `auth`, `forms`, `components`, `analytics`, `performance`, `themed`, `dnd-dashboard`, `tiptap` |
| `devops/` | DevOps, Git, CI/CD, deployment | `gh-cli`, `git-commit`, `opencode`, `pr-automation`, `dokploy` |
| `installers/` | Install skills from external marketplaces | `clawhub`, `skills-sh` |
| `workflows/` | Meta-skills orchestrating multiple skills | `sveltekit-start`, `installers-workflow`, `devops-workflow`, `content-workflow`, `dashboard-creation-workflow` |
| `content/` | Content creation & copywriting | `copywriting` |
| `(root)` | General tools & utilities | `agent-browser`, `maxun`, `memory-optimizer`, `obsidian-light`, `himalaya`, `github-alert-analyzer`, `create-skill`, `stripe-integration`, `ralph-tui-prd-generator` |

## Choosing the Right Category

### For SvelteKit Skills

Use **`sveltekit/`** if your skill:
- Is specifically for SvelteKit development
- Uses Svelte 5 runes ($props, $state, $derived, $effect)
- Integrates with SkeletonUI v4
- Uses Tailwind CSS v4
- Implements SvelteKit patterns (server actions, forms, components)

**Examples**: `bootstrap`, `skeleton-ui`, `database`, `auth`, `forms`, `components`

### For DevOps Skills

Use **`devops/`** if your skill:
- Handles deployment (Dokploy, Docker, CI/CD)
- Manages Git operations (gh-cli, git-commit)
- Automates pull requests (pr-automation)
- Integrates with OpenCode

**Examples**: `gh-cli`, `git-commit`, `opencode`, `pr-automation`, `dokploy`

### For Installer Skills

Use **`installers/`** if your skill:
- Installs skills from external marketplaces
- Handles ClawHub or skills.sh formats
- Performs security analysis

**Examples**: `clawhub`, `skills-sh`

### For Workflow Skills

Use **`workflows/`** if your skill:
- Is a meta-skill orchestrating multiple skills
- Combines multiple skills into a complete workflow
- Provides step-by-step guides for complex tasks

**Examples**: `sveltekit-start`, `installers-workflow`, `devops-workflow`, `content-workflow`, `dashboard-creation-workflow`

### For Content Skills

Use **`content/`** if your skill:
- Helps create marketing copy
- Generates content for landing pages
- Provides copywriting frameworks

**Examples**: `copywriting`

### For General Skills (Root)

Use **(root)** if your skill:
- Is a general tool or utility
- Doesn't fit in any specific category
- Works across multiple domains

**Examples**: `agent-browser`, `maxun`, `memory-optimizer`, `obsidian-light`, `himalaya`, `github-alert-analyzer`, `create-skill`, `stripe-integration`, `ralph-tui-prd-generator`

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
  - "keyword1"  # English
  - "phrase that triggers this"  # English
  - "mot-clé"  # French
  - "phrase qui déclenche"  # French
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
| `trigger_patterns` | Words/phrases that activate skill (BILINGUAL) | `["component", "composant", "reusable", "réutilisable"]` |

## Naming Conventions

### Skill Names

- **SvelteKit skills**: NO prefix (e.g., `components`, `forms`, `database`)
  - **Exception**: Keep prefix only if essential (e.g., `skeleton-ui`, `better-auth`)
- **Framework-specific skills**: Use framework name (e.g., `better-auth`, `skeleton-ui`, `tiptap`)
- **General skills**: Descriptive name (e.g., `code-review`, `data-analysis`)
- **Workflow skills**: Suffix with `-workflow` (e.g., `sveltekit-start`, `installers-workflow`)

### Examples

```
✅ GOOD:
- components
- forms
- database
- skeleton-ui
- better-auth
- sveltekit-start
- installers-workflow

❌ BAD:
- sveltekit-components  # Unnecessary prefix
- SvelteKit-Forms
- auth_skill
- dashboardWorkflow
```

## Git Workflow

After creating a skill, you MUST commit and push it to repository.

### Use Git Commands Directly

**IMPORTANT**: Use `git push origin main` for pushing changes.

Use GitHub CLI (`gh`) only for:
- Creating repositories (`gh repo create`)
- Managing issues and PRs
- Repository management

**DO NOT** use `gh repo sync --force` - it can cause commit loss!

### Repository Info

- **Organization**: A0-42-org
- **Repository**: https://github.com/A0-42-org/agent-zero-skills
- **Location**: `/a0/usr/skills/`

**ALWAYS** create repositories and push to `A0-42-org` organization (NOT personal account).

### Workflow

1. `git add <skill-folder>/`
2. `git commit -m 'feat: add <skill-name> skill'`
3. `git push origin main`

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

## Bilingual Support

For maximum accessibility, provide **bilingual trigger patterns**:

```yaml
---
name: "skill-name"
description: "Skill description"
version: "1.0.0"
author: "Agent Zero Team"
tags: ["category1", "category2"]
trigger_patterns:
  - "english keyword 1"
  - "english phrase 1"
  - "mot-clé français 1"
  - "phrase française 1"
---
```

**Why bilingual?** Users may speak English or French. Providing triggers in both languages ensures the skill is accessible to everyone.

## Security Best Practices

When creating a skill:

1. **Never include API keys** in the skill
2. **Never include passwords** or secrets
3. **Use placeholders** for sensitive data
4. **Document prerequisites** clearly
5. **Test the skill** thoroughly before committing

## Common Pitfalls

### 1. Wrong Category
```bash
# ❌ BAD - Putting a SvelteKit skill in root/
mv sveltekit-components /a0/usr/skills/components

# ✅ GOOD - Putting it in sveltekit/
mv sveltekit-components /a0/usr/skills/sveltekit/components
```

### 2. Not Using Bilingual Triggers
```yaml
# ❌ BAD - Only English triggers
trigger_patterns:
  - "create component"
  - "reusable component"

# ✅ GOOD - Bilingual triggers
trigger_patterns:
  - "create component"  # English
  - "reusable component"  # English
  - "créer composant"  # French
  - "composant réutilisable"  # French
```

### 3. Using gh repo sync --force
```bash
# ❌ BAD - Can lose commits
gh repo sync --force

# ✅ GOOD - Use git push directly
git add .
git commit -m 'feat: add new skill'
git push origin main
```

### 4. Wrong Technology Stack
```bash
# ❌ BAD - Using PNPM (not installed in Docker)
pnpm install
pnpm add @skeletonlabs/skeleton-svelte

# ✅ GOOD - Using Bun
bun install
bun add @skeletonlabs/skeleton-svelte
```

## Next Steps

After completing this wizard, you can:

1. **Use your new skill** - Start using it immediately
2. **Share it** - Add it to the repository
3. **Document it** - Write examples and guides
4. **Test it** - Ensure it works as expected

---
**Use this wizard to create new Agent Zero skills with the updated structure and bilingual support.**
