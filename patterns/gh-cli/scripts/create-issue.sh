#!/bin/bash
# Helper script: Create an issue with labels
# Usage: ./scripts/create-issue.sh "Title" "Body" "label1,label2,label3"

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 "Title" "Body" "labels""
    exit 1
fi

TITLE="$1"
BODY="$2"
LABELS="$3"

echo "Creating issue: $TITLE"

gh issue create \
  --title "$TITLE" \
  --body "$BODY" \
  --label "$LABELS"

echo "Issue created successfully!"
