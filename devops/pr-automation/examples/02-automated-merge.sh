#!/bin/bash
# Automated PR Merge Workflow
# This example demonstrates a complete automated merge workflow

set -e

# Configuration
PR_NUMBER=${1:-"1"}  # Default to PR #1 if not specified
MERGE_METHOD=${2:-"--merge"}  # Options: --merge, --squash, --rebase
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

echo "========================================"
echo "Automated PR Merge Workflow"
echo "========================================"
echo "PR Number: $PR_NUMBER"
echo "Merge Method: ${MERGE_METHOD#--}"
echo

# Step 1: Verify PR exists and is open
echo "[Step 1] Verifying PR status..."
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

echo "  ✓ PR is open: $(echo "$PR_DETAILS" | jq -r '.title')"
echo

# Step 2: Run quality checks
echo "[Step 2] Running quality checks..."
if ! "$SCRIPT_DIR/pr-check.sh" "$PR_NUMBER" > /dev/null 2>&1; then
  echo "  ✗ Quality checks failed"
  echo "  Run '$(basename "$SCRIPT_DIR")/pr-check.sh $PR_NUMBER' for details"
  exit 1
fi
echo "  ✓ Quality checks passed"
echo

# Step 3: Run automated review
echo "[Step 3] Running automated review..."
if ! "$SCRIPT_DIR/pr-review.sh" "$PR_NUMBER" > /dev/null 2>&1; then
  echo "  ✗ Automated review failed"
  echo "  Run '$(basename "$SCRIPT_DIR")/pr-review.sh $PR_NUMBER' for details"
  exit 1
fi
echo "  ✓ Automated review passed"
echo

# Step 4: Check mergeability
echo "[Step 4] Checking mergeability..."
MERGEABLE=$(echo "$PR_DETAILS" | jq -r '.mergeable')
if [ "$MERGEABLE" != "MERGEABLE" ]; then
  echo "  ✗ PR is not mergeable"
  case "$MERGEABLE" in
    "CONFLICTING")
      echo "    Reason: Merge conflicts detected"
      ;;
    "UNKNOWN")
      echo "    Reason: Mergeability unknown (waiting for checks?)"
      ;;
    *)
      echo "    Reason: Unknown status"
      ;;
  esac
  exit 1
fi
echo "  ✓ PR is mergeable"
echo

# Step 5: Check for linked issues
echo "[Step 5] Checking linked issues..."
PR_BODY=$(gh pr view "$PR_NUMBER" --json body | jq -r '.body')
LINKED_ISSUES=$(echo "$PR_BODY" | grep -oE '#[0-9]+' | sort -u || echo "")

if [ -z "$LINKED_ISSUES" ]; then
  echo "  ⚠ Warning: No linked issues found"
  echo "    Consider adding 'Closes #1' or 'Fixes #1' to PR description"
else
  echo "  ✓ Linked issues: $LINKED_ISSUES"
fi
echo

# Step 6: Check for approvals
echo "[Step 6] Checking approvals..."
REVIEWS=$(gh pr view "$PR_NUMBER" --json reviews | jq -r '.reviews[] | select(.state == "APPROVED") | .author.login' 2>/dev/null || echo "")

if [ -z "$REVIEWS" ]; then
  echo "  ⚠ Warning: No approvals found"
  echo "    This may violate repository policies"
else
  APPROVAL_COUNT=$(echo "$REVIEWS" | wc -l)
  echo "  ✓ Approvals: $APPROVAL_COUNT from:"
  echo "$REVIEWS" | sed 's/^/    - /'
fi
echo

# Step 7: Check CI status
echo "[Step 7] Checking CI status..."
CI_CHECKS=$(gh pr checks "$PR_NUMBER" 2>/dev/null || echo "")

if [ -n "$CI_CHECKS" ]; then
  FAILING=$(echo "$CI_CHECKS" | grep -c "failing" || echo "0")
  PENDING=$(echo "$CI_CHECKS" | grep -c "pending" || echo "0")
  
  if [ "$FAILING" -gt 0 ]; then
    echo "  ✗ $FAILING failing check(s)"
    echo "$CI_CHECKS" | grep "failing" | sed 's/^/    /'
    exit 1
  elif [ "$PENDING" -gt 0 ]; then
    echo "  ⚠ $PENDING check(s) still pending"
    echo "    Waiting for checks to complete..."
  else
    echo "  ✓ All CI checks passing"
  fi
else
  echo "  ⚠ No CI checks configured"
fi
echo

# Step 8: Merge Summary and Confirmation
echo "[Step 8] Merge Summary"
echo "  PR #$PR_NUMBER: $(echo "$PR_DETAILS" | jq -r '.title')"
echo "  Method: ${MERGE_METHOD#--}"
echo "  Linked Issues: ${LINKED_ISSUES:-"None"}"
echo "  Approvals: ${APPROVAL_COUNT:-0}"
echo
read -p "  Proceed with merge? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Merge cancelled by user"
  exit 0
fi
echo

# Step 9: Execute merge
echo "[Step 9] Executing merge..."
MERGE_SUBJECT="Merge PR #$PR_NUMBER: $(echo "$PR_DETAILS" | jq -r '.title')"

if gh pr merge "$PR_NUMBER" "$MERGE_METHOD" --subject "$MERGE_SUBJECT" 2>/dev/null; then
  echo "  ✓ PR merged successfully!"
else
  echo "  ✗ Merge failed"
  echo "  Possible reasons:"
  echo "    - Branch protection rules"
  echo "    - CI checks still running"
  echo "    - Insufficient permissions"
  exit 1
fi
echo

# Step 10: Verify merge
echo "[Step 10] Verifying merge..."
MERGED_PR=$(gh pr view "$PR_NUMBER" --json state,mergedAt 2>/dev/null || echo "")
PR_STATE=$(echo "$MERGED_PR" | jq -r '.state')

if [ "$PR_STATE" = "MERGED" ]; then
  echo "  ✓ Merge verified"
  MERGED_AT=$(echo "$MERGED_PR" | jq -r '.mergedAt')
  echo "    Merged at: $MERGED_AT"
else
  echo "  ⚠ Could not verify merge state"
fi
echo

echo "========================================"
echo "Merge Complete!"
echo "========================================"
echo

echo "Next steps:"
echo "1. Verify the changes: git pull origin main"
echo "2. Update local branch: git checkout main && git pull"
echo "3. Delete merged branch: git branch -d <branch-name>"
