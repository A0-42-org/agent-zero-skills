---
name: pr-automation
description: Automated Pull Request management for Agent Zero including PR review, quality checks, and merge workflows. Use this skill for automating PR lifecycle from creation to merge.
version: 1.0.0
tags:
  - github
  - pr-automation
  - pull-request
  - code-review
  - merge
  - workflows
  - ci-cd
trigger_patterns:
  - "pr review"
  - "pr automation"
  - "pull request"
  - "merge pr"
  - "pr checks"
  - "pr quality"
  - "automated review"
  - "pr workflow"
---

# PR Automation Skill

Automated Pull Request management for Agent Zero including PR review, quality checks, and merge workflows.

## Overview

This skill provides automated workflows for managing Pull Requests from creation to merge. It includes quality checks, automated reviews, merge decision logic, and integration with GitHub issues.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Access to target repository
- Appropriate permissions for PR operations

## Installation Check

```bash
# Verify GitHub CLI installation
gh --version
gh auth status

# Check access to repository
cd /path/to/repo
gh repo view
```

## Key Features

1. **PR Quality Checks**: Automated checks for PR quality (labels, linked issues, description quality)
2. **PR Review**: Automated review based on project guidelines and standards
3. **Merge Approval**: Determine if PR is ready for merge based on checks
4. **Merge Execution**: Merge PRs when all checks pass
5. **PR Status Tracking**: Monitor PR status and provide reports
6. **Integration with Issues**: Ensure PRs link to issues properly

## PR Quality Checklist

- [ ] PR has descriptive title
- [ ] PR has detailed description
- [ ] PR links to one or more issues (Closes #1, Fixes #1)
- [ ] PR has appropriate labels
- [ ] PR has no merge conflicts
- [ ] All CI checks pass (if configured)
- [ ] Code follows project guidelines
- [ ] Tests are included (TDD)
- [ ] Documentation is updated

## Automated Review Criteria

1. **Code Quality**: Check for proper formatting, naming conventions
2. **Test Coverage**: Verify tests are added/updated
3. **Documentation**: Check if docs are updated
4. **Security**: Verify no secrets or sensitive data
5. **Best Practices**: Follow project-specific guidelines

## Merge Decision Logic

**Auto-merge if**:
- All quality checks pass
- No critical issues found in review
- At least 1 approval (if configured)
- Linked issue exists

**Manual review if**:
- Critical issues found
- Large code changes (>500 lines)
- Breaking changes detected
- Security concerns

## Common Commands

### List PRs
```bash
gh pr list --state open
gh pr list --label "phase-3" --state merged
gh pr list --author @me --state open
```

### Review PR
```bash
gh pr view <pr-number> --json title,body,state,author,headRefName,baseRefName
gh pr checks <pr-number>
gh pr diff <pr-number>
```

### Merge PR
```bash
gh pr merge <pr-number> --merge --subject "Merge PR #<number>"
gh pr merge <pr-number> --squash
gh pr merge <pr-number> --rebase
```

### Check PR Quality
```bash
gh pr view <pr-number> --json title,body,labels | jq '.title, .body, .labels'
```

## Workflow Examples

### Automated PR Review
```bash
# 1. Get PR details
pr_details=$(gh pr view <pr-number> --json title,body,labels,headRefName)

# 2. Check quality
echo "$pr_details" | jq -r '.title'  # Check title
echo "$pr_details" | jq -r '.body'   # Check body
echo "$pr_details" | jq -r '.labels[] | .name'  # Check labels

# 3. Get linked issues
echo "$pr_details" | jq -r '.body' | grep -o '#[0-9]+'

# 4. Check CI status
gh pr checks <pr-number>
```

### Automated Merge
```bash
# 1. Check PR passes all checks
if $(gh pr checks <pr-number> | grep -q 'passing'); then
  # 2. Merge PR
  gh pr merge <pr-number> --merge
fi
```

## Project-Specific Rules for Vialto

- **Must follow AGENTS.md guidelines**
- **Must use bun package manager** (not npm)
- **Tests required for all features** (TDD)
- **Documentation required** (TODO.md, DIRECTIVES.md)
- **No secrets in code** (use .env variables)
- **Follow Svelte 5 best practices**
- **Follow SvelteKit patterns**

## Error Handling

```bash
# Handle merge conflicts
if ! gh pr merge <pr-number> --merge 2>/dev/null; then
  echo "Merge failed - possible conflict"
fi

# Handle missing PR
if ! gh pr view <pr-number> >/dev/null 2>&1; then
  echo "PR not found"
fi

# Handle authentication errors
if ! gh auth status >/dev/null 2>&1; then
  echo "Not authenticated. Run: gh auth login"
fi
```

## File Structure

```
pr-automation/
├── SKILL.md                    # Main documentation
├── scripts/
│   ├── pr-review.sh            # Automated PR review script
│   ├── pr-check.sh             # PR quality checks
│   ├── pr-merge.sh             # Automated merge script
│   └── pr-status.sh            # PR status tracking
└── examples/
    ├── 01-automated-review.sh  # Review workflow example
    └── 02-automated-merge.sh   # Merge workflow example
```

## Usage

1. **Load the skill**: Use `skills_tool:load` with `skill_name: pr-automation`
2. **Run scripts**: Execute scripts from the `scripts/` directory
3. **Follow examples**: Use `examples/` as templates for your workflows

## Best Practices

1. **Always run quality checks before merging**
2. **Link PRs to issues** using "Closes #1" or "Fixes #1"
3. **Use descriptive PR titles** following conventional commits
4. **Include test results** in PR descriptions
5. **Review code changes** before merging
6. **Monitor CI/CD status** for all PRs
