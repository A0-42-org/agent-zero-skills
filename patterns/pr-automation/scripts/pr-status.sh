#!/bin/bash
# PR Status Tracking Script
# Usage: ./pr-status.sh [pr-number] [--format json|table]

PR_NUMBER=$1
FORMAT=${2:-"table"}

if [ "$FORMAT" != "json" ] && [ "$FORMAT" != "table" ]; then
  echo "Error: Invalid format. Use 'json' or 'table'"
  exit 1
fi

# Function to display single PR status
show_pr_status() {
  local pr_num=$1
  
  PR_DETAILS=$(gh pr view "$pr_num" --json \
    title,state,author,headRefName,baseRefName,additions,deletions,mergeable, \
    createdAt,updatedAt,mergedAt,closedAt,labels,reviews 2>/dev/null || echo "")
  
  if [ -z "$PR_DETAILS" ]; then
    echo "Error: PR #$pr_num not found"
    exit 1
  fi
  
  if [ "$FORMAT" = "json" ]; then
    echo "$PR_DETAILS"
    return
  fi
  
  # Table format
  echo "=== Pull Request #$pr_num ==="
  echo
  echo "Title: $(echo "$PR_DETAILS" | jq -r '.title')"
  echo "State: $(echo "$PR_DETAILS" | jq -r '.state')"
  echo "Author: $(echo "$PR_DETAILS" | jq -r '.author.login')"
  echo "Branch: $(echo "$PR_DETAILS" | jq -r '.headRefName') -> $(echo "$PR_DETAILS" | jq -r '.baseRefName')"
  echo "Changes: +$(echo "$PR_DETAILS" | jq -r '.additions') -$(echo "$PR_DETAILS" | jq -r '.deletions')"
  echo "Mergeable: $(echo "$PR_DETAILS" | jq -r '.mergeable')"
  echo
  
  echo "Dates:"
  echo "  Created: $(echo "$PR_DETAILS" | jq -r '.createdAt')"
  echo "  Updated: $(echo "$PR_DETAILS" | jq -r '.updatedAt')"
  
  STATE=$(echo "$PR_DETAILS" | jq -r '.state')
  if [ "$STATE" = "MERGED" ]; then
    echo "  Merged: $(echo "$PR_DETAILS" | jq -r '.mergedAt')"
  elif [ "$STATE" = "CLOSED" ]; then
    echo "  Closed: $(echo "$PR_DETAILS" | jq -r '.closedAt')"
  fi
  echo
  
  echo "Labels:"
  LABELS=$(echo "$PR_DETAILS" | jq -r '.labels[] | .name' 2>/dev/null || echo "")
  if [ -n "$LABELS" ]; then
    echo "$LABELS" | sed 's/^/  - /'
  else
    echo "  (none)"
  fi
  echo
  
  echo "Reviews:"
  REVIEWS=$(echo "$PR_DETAILS" | jq -r '.reviews[] | "\(.author.login): \(.state)"' 2>/dev/null || echo "")
  if [ -n "$REVIEWS" ]; then
    echo "$REVIEWS" | sed 's/^/  - /'
  else
    echo "  (none)"
  fi
}

# Function to display all PRs
show_all_prs() {
  local state=$1
  
  if [ "$FORMAT" = "json" ]; then
    gh pr list --state "$state" --json number,title,state,author,headRefName,mergeable,labels
    return
  fi
  
  echo "=== Pull Requests (state: $state) ==="
  echo
  
  PRS=$(gh pr list --state "$state" --limit 100 --json number,title,author,headRefName,mergeable,labels 2>/dev/null || echo "")
  
  if [ -z "$PRS" ] || [ "$PRS" = "[]" ]; then
    echo "No pull requests found with state: $state"
    return
  fi
  
  COUNT=$(echo "$PRS" | jq 'length')
  echo "Total: $COUNT PR(s)"
  echo
  
  for i in $(seq 0 $((COUNT - 1))); do
    PR_NUM=$(echo "$PRS" | jq -r ".[$i].number")
    TITLE=$(echo "$PRS" | jq -r ".[$i].title")
    AUTHOR=$(echo "$PRS" | jq -r ".[$i].author.login")
    BRANCH=$(echo "$PRS" | jq -r ".[$i].headRefName")
    MERGEABLE=$(echo "$PRS" | jq -r ".[$i].mergeable")
    LABELS=$(echo "$PRS" | jq -r ".[$i].labels[] | .name" 2>/dev/null | tr '\n' ',' | sed 's/,$//')
    
    echo "#$PR_NUM: $TITLE"
    echo "  Author: $AUTHOR | Branch: $BRANCH"
    echo "  Mergeable: $MERGEABLE"
    if [ -n "$LABELS" ]; then
      echo "  Labels: $LABELS"
    fi
    echo
  done
}

# Main execution
if [ -n "$PR_NUMBER" ]; then
  show_pr_status "$PR_NUMBER"
else
  echo "=== PR Status Report ==="
  echo
  
  echo "[OPEN]"
  echo
  show_all_prs open
  echo
  
  echo "[MERGED]"
  echo
  show_all_prs merged
  echo
  
  echo "[CLOSED]"
  echo
  show_all_prs closed
fi
