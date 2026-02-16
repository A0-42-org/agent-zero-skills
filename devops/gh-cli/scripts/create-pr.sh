#!/bin/bash
# Helper script: Create PR that closes issues
# Usage: ./scripts/create-pr.sh "Title" "BaseBranch" "IssueNumbers"
# Example: ./scripts/create-pr.sh "Fix auth bug" "main" "5,7,10"

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 "Title" "BaseBranch" "IssueNumbers""
    exit 1
fi

TITLE="$1"
BASE_BRANCH="$2"
ISSUES="$3"

echo "Creating PR: $TITLE"

gh pr create \
  --title "$TITLE" \
  --body "## Description\n\nThis PR implements the requested changes.\n\n## Related Issues\nCloses #$ISSUES" \
  --base "$BASE_BRANCH"

echo "PR created successfully!"
