---
name: "sveltekit-project-workflow"
description: "Complete workflow for SvelteKit projects including Git workflow, TODO management, PRD creation, GitHub issues generation, and client reports."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["sveltekit", "workflow", "git", "project-management"]
trigger_patterns:
  - "project workflow"
  - "sveltekit workflow"
  - "git workflow"
  - "task management"
  - "workflow projet"
  - "workflow sveltekit"
  - "workflow git"
  - "gestion des tâches"
---

# SvelteKit Project Workflow

This skill provides a complete workflow for SvelteKit projects including Git operations, TODO management, PRD creation, GitHub issues, and client reporting.

## Git Workflow for Each Task

### Standard Workflow for Every Single Task

Follow this workflow for **every individual task**:

```bash
# 1. Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/phase-X-step-Y

# 2. Implement the task
# ... write code ...

# 3. Commit changes with Conventional Commits format
git add .
git commit -m 'feat(phase-X): implement step Y'

# 4. Push to remote
git push origin feature/phase-X-step-Y

# 5. Create pull request (use GitHub CLI or web UI)
gh pr create --title "feat(phase-X): implement step Y" --body "Description of changes"

# 6. After merge, cleanup
git checkout main
git pull origin main
git branch -d feature/phase-X-step-Y
git push origin --delete feature/phase-X-step-Y
```

## Conventional Commits Format

Always use Conventional Commits format for all commits:

| Type | Format | Description |
|------|--------|-------------|
| Feature | `feat(phase-X): description` | New feature |
| Fix | `fix(phase-X): description` | Bug fix |
| Docs | `docs(phase-X): description` | Documentation changes |
| Refactor | `refactor(phase-X): description` | Code refactoring |
| Test | `test(phase-X): description` | Test changes |
| Chore | `chore(phase-X): description` | Maintenance tasks |

### Examples

```bash
git commit -m 'feat(phase-3): implement user dashboard'
git commit -m 'fix(phase-4): fix referral status validation'
git commit -m 'docs(phase-5): update API documentation'
git commit -m 'refactor(phase-2): improve service layer architecture'
git commit -m 'test(phase-3): add unit tests for referral service'
```

## TODO Management Workflow

### Single Source of Truth

- Use **ONE** TODO file as the source of truth (e.g., `TODO_IMPROVED.md`)
- Update TODO **after EVERY individual task** completion
- Progress tracking with percentages (✅ 100%, ⏳ 90%, 🟡 En cours, 🔜 À faire)
- **NEVER** maintain multiple TODO files simultaneously

### Progress Tracking Format

```markdown
## 📊 Progression globale
- [x] **74%** - Projet en cours (51/69 étapes complétées)

## 🚀 Phase 0: Initialisation & Configuration ✅ COMPLETÉ
### 0.1 Configuration de l'environnement
- [x] Créer repository GitHub
- [x] Cloner repository
```

### Progress Indicators

- ✅ 100% - Fully completed
- ⏳ 90% - Almost complete (1-2 tasks remaining)
- 🟡 45% - In progress (multiple tasks done)
- 🔜 0% - Not started

## Task Completion Sequence

After completing **EVERY individual task**:

1. ✅ Commit changes with Conventional Commits format
2. ✅ Update TODO_IMPROVED.md with progress
3. ✅ Push to GitHub **immediately**

```bash
# Example after completing task
git add .
git commit -m 'feat(phase-3): implement user authentication'
git push origin feature/phase-3-authentication
# Update TODO file
git add docs/TODO_IMPROVED.md
git commit -m 'docs(phase-3): update TODO - authentication completed'
git push origin feature/phase-3-authentication
```

## PRD Creation

Generate comprehensive Product Requirements Documents that include:

- Project overview and objectives
- Core features (public, user dashboard, admin, integrations)
- Technical specifications
- Database schema
- API endpoints
- Roadmap with phases
- Non-functional requirements
- Success criteria

### PRD Structure

```markdown
# Product Requirements Document - Project Name

## 1. Overview
## 2. Core Features
## 3. Technical Requirements
## 4. Database Schema
## 5. API Endpoints
## 6. Roadmap
## 7. Non-Functional Requirements
## 8. Success Criteria
```

### When to Create PRD

- Before starting any new project
- When project requirements change significantly
- When onboarding new developers

## GitHub Issues Generation

### Create Issues from PRD

Use GitHub CLI (gh) to create issues from PRD:

```bash
# Create issue with labels and assignees
gh issue create \
  --title "feat(phase-1): implement user authentication" \
  --body "Description of the task..." \
  --label "phase-1,enhancement" \
  --assignee @username
```

### Issue Best Practices

- Assign to appropriate phases using labels (e.g., `phase-1`, `phase-2`)
- Use conventional commit format in issue titles
- Include acceptance criteria
- Link to related PRD section
- Assign to appropriate team members

### Recommended Labels

- **Phase labels**: `phase-0`, `phase-1`, `phase-2`, etc.
- **Type labels**: `bug`, `enhancement`, `documentation`, `question`
- **Priority labels**: `critical`, `high-priority`, `medium-priority`
- **Status labels**: `good first issue`, `help wanted`, `completed`

## Client Reports

### Generate Progress Reports

Generate regular client reports including:

- Overall completion percentage
- Completed phases with details
- Remaining tasks
- Recent achievements
- Next steps

### Report Structure

```markdown
# Client Progress Report

## Executive Summary
**Overall Progress: X%**

## Completed Phases
### Phase X: Title ✅ 100%
- Completed tasks...

## Current Work
### Phase Y: Title 🟡 Z%
- In progress tasks...

## Remaining Work
### Phase Z: Title 🔜 0%
- Pending tasks...

## Next Steps
1. ...
2. ...
```

### When to Update Reports

- After completing major milestones
- Weekly or bi-weekly updates
- When requested by client

## GitHub CLI Integration

### GitHub CLI Commands

Use gh CLI for:

- Creating repositories: `gh repo create`
- Managing issues: `gh issue create`, `gh issue list`, `gh issue close`
- Managing PRs: `gh pr create`, `gh pr merge`, `gh pr list`
- Repository management

### Authentication

Authenticate with GITHUB_PAT:

```bash
gh auth login --with-token
# Paste your GITHUB_PAT
```

### IMPORTANT: Never Use Force Sync

```bash
# ❌ BAD - Can lose commits
gh repo sync --force

# ✅ GOOD - Use git push directly
git push origin main
```

## Repository Management

### Branch Management

- Create feature branches: `feature/phase-X-step-Y`
- Merge to main after completion via Pull Request
- Delete feature branches after merge
- Keep main branch clean and deployable

### Commit Guidelines

- Commit frequently and with clear messages
- Use Conventional Commits format
- Include issue reference: `feat(phase-3): implement auth (#42)`

### Pull Request Guidelines

- Create PR for every feature
- Include clear description of changes
- Reference related issue
- Request code review before merge
- Use squashing to keep history clean

## Quick Reference

### Git Workflow Commands

```bash
# Start new task
git checkout main && git pull && git checkout -b feature/phase-X-step-Y

# Commit and push
git add . && git commit -m 'feat(phase-X): description' && git push origin feature/phase-X-step-Y

# Finish task
git checkout main && git pull && git branch -d feature/phase-X-step-Y && git push origin --delete feature/phase-X-step-Y
```

### Commit Format

```bash
feat(phase-X): new feature
fix(phase-X): bug fix
docs(phase-X): documentation
refactor(phase-X): refactoring
test(phase-X): tests
chore(phase-X): maintenance
```

### TODO Update

```bash
# After completing task
git add docs/TODO_IMPROVED.md
git commit -m 'docs(phase-X): update TODO - task completed'
git push
```

---

**Use this workflow for all SvelteKit projects to maintain consistency and track progress effectively.**
