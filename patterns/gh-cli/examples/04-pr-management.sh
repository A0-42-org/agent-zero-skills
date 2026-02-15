#!/bin/bash
# Example: Pull Request Management Workflow with gh CLI
# This script demonstrates managing pull requests

echo "=== GitHub PR Management Workflow ==="

# 1. List all open PRs
echo "
1. Listing all open PRs..."
gh pr list --state open

# 2. View specific PR
echo "
2. Viewing latest PR..."
LATEST_PR=$(gh pr list --state open --json number --jq '.[0].number')
gh pr view $LATEST_PR

# 3. Check PR status
echo "
3. Checking PR status..."
gh pr view $LATEST_PR --json state,title,headRefName,baseRefName,mergeable,reviewDecision

# 4. Add reviewers
echo "
4. Adding reviewers..."
gh pr edit $LATEST_PR --add-reviewer "reviewer1,reviewer2"

# 5. Add assignee
echo "
5. Adding assignee..."
gh pr edit $LATEST_PR --add-assignee "developer1"

# 6. Add labels
echo "
6. Adding labels..."
gh pr edit $LATEST_PR --add-label "phase-1,backend,enhancement"

# 7. Check PR checks
echo "
7. Checking PR checks status..."
gh pr checks $LATEST_PR

# 8. Merge PR (if checks pass and approved)
echo "
8. Ready to merge?"
read -p "Merge PR #$LATEST_PR? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    gh pr merge $LATEST_PR --merge --delete-branch=true
    echo "PR merged successfully!"
else
    echo "PR not merged."
fi

echo "=== PR management complete! ==="
