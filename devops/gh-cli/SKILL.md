---
name: "gh-cli"
description: "GitHub CLI (gh) automation best practices and workflows for Agent Zero. Use this skill for all GitHub operations including creating labels, issues, pull requests, and managing repositories."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["github", "gh-cli", "automation", "devops", "git", "workflows"]
trigger_patterns:
  - "github cli"
  - "gh-cli"
  - "github automation"
  - "create label"
  - "create issue"
  - "create pull request"
  - "create pr"
  - "github repo"
  - "manage labels"
  - "manage issues"
---

# GitHub CLI (gh) - Automation Best Practices

This skill provides comprehensive guidance for using GitHub CLI (gh) for automation workflows in Agent Zero.

## Why Use gh CLI?

- **10x faster** than REST API calls with curl
- **More reliable** - handles authentication automatically
- **Simpler syntax** - cleaner and more readable
- **Interactive fallback** - can prompt for inputs when needed
- **Native GitHub integration** - works with all GitHub features

## Installation Check

Always verify gh CLI is installed and authenticated before use:

```bash
# Check if gh is installed
whereis gh

# Check version
gh --version

# Check authentication status
gh auth status
```

If not authenticated, run:
```bash
gh auth login
```

## Critical Rules

### 1. ALWAYS Create Private Repos by Default

**CRITICAL SECURITY RULE**: When creating GitHub repositories, the default visibility MUST be `--private`.

**Why this matters**:
- Data protection for sensitive information
- Security compliance requirements
- Prevents unauthorized access to proprietary code

```bash
# ✅ CORRECT - Creates private repo
gh repo create <repo-name> --private

# ❌ WRONG - Creates public repo
gh repo create <repo-name>
gh repo create <repo-name> --public
```

### 2. Use gh CLI Over curl

- Use `gh` CLI for: creating labels, issues, PRs, managing repos
- Use `curl` only for: custom API calls, webhooks, unsupported features
- Use `browser_agent` only for: manual GitHub UI operations, complex workflows

### 3. Create Labels Before Issues

Prevents errors when creating issues with labels:

```bash
# Always create labels first
gh label create phase-0 --color '0E8A16' --description 'Tasks for Phase 0'
gh label create critical --color 'B60205' --description 'Critical priority tasks'

# Then create issues with labels
gh issue create --title 'Title' --body 'Body' --label 'phase-0,critical'
```

### 4. Link PRs to Issues

Use 'Closes #1' in PR body to automatically close issues:

```bash
gh pr create \
  --title 'Fix bug' \
  --body 'This PR fixes the reported bug.\n\nCloses #1'
```

### 5. Follow Semantic Naming

Use descriptive, consistent naming conventions:
- Phases: `phase-0`, `phase-1`, `phase-2`
- Components: `backend`, `frontend`, `api`, `database`
- Priority: `critical`, `high-priority`, `medium-priority`

## Common Commands

### Label Management

```bash
# Create a label
gh label create <name> --color '<hex>' --description '<desc>'

# List all labels
gh label list

# Delete a label
gh label delete <label-name>
```

**Examples**:
```bash
gh label create phase-0 --color '0E8A16' --description 'Tasks for Phase 0'
gh label create phase-1 --color '1D76DB' --description 'Tasks for Phase 1'
gh label create critical --color 'B60205' --description 'Critical priority tasks'
gh label create backend --color '0E8A16' --description 'Backend tasks and features'
gh label create frontend --color '5319E7' --description 'Frontend tasks and features'
gh label create api --color '0066CC' --description 'API development tasks'
gh label create service --color 'D4C5F9' --description 'Service layer tasks'
gh label create database --color '008672' --description 'Database related tasks'
```

### Issue Management

```bash
# Create an issue
gh issue create --title '<Title>' --body '<Body>' --label 'label1,label2'

# List all issues
gh issue list

# View specific issue
gh issue view <number>

# Close an issue
gh issue close <number>

# Add label to existing issue
gh issue edit <number> --add-label '<label>'
```

**Examples**:
```bash
# Create issue with single label
gh issue create \
  --title "Phase 0: Initial setup" \
  --body "## Task Description\nSet up the project structure." \
  --label "phase-0"

# Create issue with multiple labels
gh issue create \
  --title "Implement referral validation logic" \
  --body "## Task Description\nImplement critical referral validation logic." \
  --label "phase-3,backend,service,critical"
```

### Pull Request Management

```bash
# Create PR from current branch
gh pr create --title '<Title>' --body '<Body>'

# Create PR with explicit repo and base branch
gh pr create \
  --repo owner/repo \
  --base main \
  --head feature-branch \
  --title '<Title>' \
  --body '<Body>'

# List all PRs
gh pr list

# View specific PR
gh pr view <number>

# Merge a PR
gh pr merge <number> --merge

# Close a PR
gh pr close <number>
```

**Examples**:
```bash
# Create PR that closes issues
gh pr create \
  --repo owner/repo \
  --base main \
  --head feature/referral-validation \
  --title "Phase 0: Bugfixes and Setup" \
  --body "## Description\nThis PR implements Phase 0 tasks.\n\n## Changes\n- Fixed authentication issues\n- Set up project structure\n\n## Related Issues\n- Closes #1\n- Closes #2"

# Create PR with multiple issue links
gh pr create \
  --title "Implement API endpoints" \
  --body "## Description\nAdded REST API endpoints.\n\nCloses #5, #7, #10"
```

### Repository Management

```bash
# Create private repository
gh repo create <name> --private

# Create private repository with description
gh repo create <name> --private --description '<description>'

# Create repository from current directory
gh repo create . --private --source=. --remote=origin

# Create repository with specific owner
gh repo create owner/<repo-name> --private

# View repository info
gh repo view

# Verify visibility
gh repo view --json visibility
```

**Examples**:
```bash
# Create private repo with description
gh repo create my-project --private --description "A private project"

# Create repo and initialize from current directory
gh repo create . --private --source=. --remote=origin
```

## GitHub Automation Workflow

### Step-by-Step Process

1. **Verify Installation**
   ```bash
   gh auth status
   ```

2. **Create Labels** (Always first!)
   ```bash
   gh label create phase-0 --color '0E8A16' --description 'Tasks for Phase 0'
   gh label create critical --color 'B60205' --description 'Critical priority'
   gh label create backend --color '0E8A16' --description 'Backend tasks'
   ```

3. **Create Issues**
   ```bash
   gh issue create \
     --title "Phase 0: Initial setup" \
     --body "Set up project structure" \
     --label "phase-0,backend"
   ```

4. **Create Branches**
   ```bash
   git checkout -b feature/phase-0-setup
   ```

5. **Create Pull Requests**
   ```bash
   gh pr create \
     --title "Phase 0: Bugfixes and Setup" \
     --body "## Description\nImplemented Phase 0 tasks.\n\nCloses #1" \
     --base main
   ```

## Error Handling

### Handle Missing Labels

```bash
# Suppress error if label exists
gh label create test --color 'ffffff' 2>/dev/null || echo 'Label test already exists'

# Create labels in bulk with error handling
for label in phase-0 phase-1 critical backend frontend; do
  gh label create $label --color '0E8A16' --description 'Project label' 2>/dev/null || echo "Label $label exists"
done
```

### Handle Authentication Errors

```bash
# Check auth and prompt login if needed
gh auth status || gh auth login
```

### Handle Repository Creation Errors

```bash
# Check if repo already exists
gh repo view owner/repo 2>/dev/null || gh repo create owner/repo --private
```

## Comparison: gh CLI vs curl

| Task | gh CLI | curl (REST API) |
|------|---------|----------------|
| Create label | `gh label create test` | `curl -X POST -H "Authorization: Bearer $TOKEN" ...` |
| Create issue | `gh issue create --title "Test"` | `curl -X POST -H "Authorization: Bearer $TOKEN" ...` |
| Create PR | `gh pr create --title "Test"` | `curl -X POST -H "Authorization: Bearer $TOKEN" ...` |
| Speed | ~0.5s | ~2-3s |
| Auth handling | Automatic | Manual (TOKEN required) |

**Result**: gh CLI is 4-6x faster and requires no manual authentication.

## Best Practices Summary

1. **Always create labels before creating issues** - prevents "Label not found" errors
2. **Use descriptive titles and bodies** - follow GitHub conventions for clarity
3. **Link PRs to issues** - use "Closes #1" or "Fixes #1" in PR body for automatic issue closure
4. **Use proper priority labeling** - critical, high-priority, medium-priority for task management
5. **Follow semantic naming** - phase-0, phase-1, backend, api, service for consistency
6. **Always use --private flag** - default to private repositories for security
7. **Prefer gh CLI over curl** - faster, more reliable, simpler syntax
8. **Use error handling** - suppress errors with 2>/dev/null for idempotent operations

## Common Workflows

### Project Initialization

```bash
# 1. Create private repo
gh repo create my-project --private

# 2. Clone and navigate
git clone git@github.com:owner/my-project.git
cd my-project

# 3. Create project labels
gh label create phase-0 --color '0E8A16' --description 'Phase 0 tasks'
gh label create phase-1 --color '1D76DB' --description 'Phase 1 tasks'
gh label create critical --color 'B60205' --description 'Critical priority'
gh label create backend --color '0E8A16' --description 'Backend tasks'
gh label create frontend --color '5319E7' --description 'Frontend tasks'

# 4. Create initial issues
gh issue create --title "Phase 0: Setup" --body "Initialize project" --label "phase-0"
gh issue create --title "Configure CI/CD" --body "Set up GitHub Actions" --label "phase-0,critical"
```

### Feature Development

```bash
# 1. Create feature issue
gh issue create \
  --title "Implement user authentication" \
  --body "## Description\nAdd JWT-based authentication." \
  --label "phase-1,backend,critical"

# 2. Create feature branch
git checkout -b feature/user-auth

# 3. Implement feature...

# 4. Create PR that closes the issue
gh pr create \
  --title "Implement user authentication" \
  --body "## Description\nAdded JWT-based authentication system.\n\n## Changes\n- Login endpoint\n- Token validation middleware\n- Refresh token logic\n\nCloses #5"
```

## Verification Commands

```bash
# Verify gh CLI is installed
gh --version

# Verify authentication
gh auth status

# Verify repo visibility (should show: "visibility": "private")
gh repo view --json visibility

# Verify labels were created
gh label list

# Verify issues were created
gh issue list

# Verify PRs were created
gh pr list
```

## Project-Specific Rules

For projects like **Vialto**:
- **ALL repositories** MUST be private
- **Client data repositories** MUST be private
- **Production code** MUST be private
- **ONLY create public repos** if explicitly requested by user with clear justification

## Integration with Agent Zero

**Preferred order for GitHub operations**:
1. `gh` CLI (primary) - use this for all standard GitHub operations
2. `curl` REST API (fallback) - use only for unsupported features
3. `browser_agent` (last resort) - use only for manual UI operations

**When to use each**:
- **gh CLI**: Creating labels, issues, PRs, managing repos (90% of cases)
- **curl**: Custom API calls, webhooks, unsupported features (5% of cases)
- **browser_agent**: Manual GitHub UI operations, complex workflows (5% of cases)

---

**Use this skill for all GitHub automation tasks to ensure fast, reliable, and secure operations.**
