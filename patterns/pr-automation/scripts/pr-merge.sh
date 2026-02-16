#!/bin/bash
# Automated PR Merge Script
# Usage: ./pr-merge.sh <pr-number> [--merge|--squash|--rebase]

set -e

PR_NUMBER=$1
MERGE_METHOD=${2:-"--merge"}

if [ -z "$PR_NUMBER" ]; then
  echo "Error: PR number required"
  echo "Usage: $0 <pr-number> [--merge|--squash|--rebase]"
  exit 1
fi

echo "=== Processing PR #$PR_NUMBER for Merge ==="
echo

# Verify PR exists and is open
PR_DETAILS=$(gh pr view "$PR_NUMBER" --json state,title,mergeable 2>/dev/null || echo "")

if [ -z "$PR_DETAILS" ]; then
  echo "Error: PR #$PR_NUMBER not found"
  exit 1
fi

PR_STATE=$(echo "$PR_DETAILS" | jq -r '.state')
if [ "$PR_STATE" != "OPEN" ]; then
  echo "Error: PR is not open (state: $PR_STATE)"
  exit 1
fi

echo "PR Title: $(echo "$PR_DETAILS" | jq -r '.title')"
echo "Merge Method: ${MERGE_METHOD#--}"
echo

# Step 1: Run quality checks
echo "[Step 1] Running quality checks..."
QUALITY_CHECK=$(dirname "$0")/pr-check.sh
if [ ! -f "$QUALITY_CHECK" ]; then
  echo "Warning: pr-check.sh not found, skipping quality checks"
else
  if ! "$QUALITY_CHECK" "$PR_NUMBER" > /dev/null 2>&1; then
    echo "❌ Quality checks failed - cannot merge"
    echo "Run '$(basename "$QUALITY_CHECK") $PR_NUMBER' for details"
    exit 1
  fi
  echo "✓ Quality checks passed"
fi
echo

# Step 2: Run automated review
echo "[Step 2] Running automated review..."
REVIEW_CHECK=$(dirname "$0")/pr-review.sh
if [ ! -f "$REVIEW_CHECK" ]; then
  echo "Warning: pr-review.sh not found, skipping review"
else
  if ! "$REVIEW_CHECK" "$PR_NUMBER" > /dev/null 2>&1; then
    echo "❌ Automated review failed - cannot merge"
    echo "Run '$(basename "$REVIEW_CHECK") $PR_NUMBER' for details"
    exit 1
  fi
  echo "✓ Automated review passed"
fi
echo

# Step 3: Check mergeability
echo "[Step 3] Checking mergeability..."
MERGEABLE=$(echo "$PR_DETAILS" | jq -r '.mergeable')
if [ "$MERGEABLE" != "MERGEABLE" ]; then
  echo "❌ PR is not mergeable"
  case "$MERGEABLE" in
    "CONFLICTING")
      echo "  Reason: Merge conflicts detected"
      ;;
    "UNKNOWN")
      echo "  Reason: Mergeability unknown (waiting for checks?)"
      ;;
    *)
      echo "  Reason: Unknown status"
      ;;
  esac
  exit 1
fi
echo "✓ PR is mergeable"
echo

# Step 4: Check for linked issues
echo "[Step 4] Checking linked issues..."
PR_BODY=$(gh pr view "$PR_NUMBER" --json body | jq -r '.body')
LINKED_ISSUES=$(echo "$PR_BODY" | grep -oE '#[0-9]+' | sort -u || echo "")

if [ -z "$LINKED_ISSUES" ]; then
  echo "⚠ Warning: No linked issues found"
  echo "  Consider adding 'Closes #1' or 'Fixes #1' to PR description"
  read -p "  Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Merge cancelled"
    exit 1
  fi
else
  echo "✓ Linked issues: $LINKED_ISSUES"
fi
echo

# Step 5: Check for approvals (if configured)
echo "[Step 5] Checking approvals..."
REVIEWS=$(gh pr view "$PR_NUMBER" --json reviews | jq -r '.reviews[] | select(.state == "APPROVED") | .author.login' 2>/dev/null || echo "")

if [ -z "$REVIEWS" ]; then
  echo "⚠ Warning: No approvals found"
  echo "  This may violate repository policies"
  read -p "  Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Merge cancelled"
    exit 1
  fi
else
  APPROVAL_COUNT=$(echo "$REVIEWS" | wc -l)
  echo "✓ Approvals: $APPROVAL_COUNT from:"
  echo "$REVIEWS" | sed 's/^/    - /'
fi
echo

# Step 6: Confirm merge
echo "[Step 6] Merge Summary"
echo "  PR #$PR_NUMBER: $(echo "$PR_DETAILS" | jq -r '.title')"
echo "  Method: ${MERGE_METHOD#--}"
echo "  Linked Issues: ${LINKED_ISSUES:-"None"}"
echo "  Approvals: ${APPROVAL_COUNT:-0}"
echo
read -p "  Proceed with merge? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Merge cancelled by user"
  exit 1
fi
echo

# Step 7: Execute merge
echo "[Step 7] Executing merge..."
MERGE_SUBJECT="Merge PR #$PR_NUMBER: $(echo "$PR_DETAILS" | jq -r '.title')"

if gh pr merge "$PR_NUMBER" "$MERGE_METHOD" --subject "$MERGE_SUBJECT" 2>/dev/null; then
  echo "✓ PR merged successfully!"
else
  echo "❌ Merge failed"
  echo "Possible reasons:"
  echo "  - Branch protection rules"
  echo "  - CI checks still running"
  echo "  - Insufficient permissions"
  exit 1
fi
echo

echo "=== Merge Complete ==="
echo "PR #$PR_NUMBER has been merged into the base branch."
