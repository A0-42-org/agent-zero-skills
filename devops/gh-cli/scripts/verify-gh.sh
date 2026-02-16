#!/bin/bash
# Helper script: Verify gh CLI installation and authentication
# Usage: ./scripts/verify-gh.sh

echo "=== Verifying GitHub CLI Setup ==="

# Check installation
if ! command -v gh &> /dev/null; then
    echo "❌ gh CLI is not installed"
    echo "Install from: https://cli.github.com/"
    exit 1
fi
echo "✅ gh CLI is installed"

# Show version
echo "
Version:"
gh --version

# Check authentication
echo "
Authentication status:"
if gh auth status &> /dev/null; then
    echo "✅ gh CLI is authenticated"
    gh auth status
else
    echo "❌ gh CLI is not authenticated"
    echo "Run: gh auth login"
    exit 1
fi

# Check current repo
echo "
Current repository:"
if gh repo view &> /dev/null; then
    REPO_NAME=$(gh repo view --json name --jq '.name')
    REPO_VISIBILITY=$(gh repo view --json visibility --jq '.visibility')
    echo "✅ Repository: $REPO_NAME"
    echo "Visibility: $REPO_VISIBILITY"
    if [ "$REPO_VISIBILITY" != "private" ]; then
        echo "⚠️  WARNING: Repository is not private!"
    fi
else
    echo "ℹ️  Not in a GitHub repository"
fi

echo "
=== Verification Complete ==="
