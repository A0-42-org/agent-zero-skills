#!/bin/bash
# Automated PR Review Workflow
# This example demonstrates a complete automated review workflow

set -e

# Configuration
PR_NUMBER=${1:-"1"}  # Default to PR #1 if not specified
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

echo "========================================"
echo "Automated PR Review Workflow"
echo "========================================"
echo "PR Number: $PR_NUMBER"
echo

# Step 1: Get PR details
echo "[Step 1] Fetching PR details..."
PR_DETAILS=$(gh pr view "$PR_NUMBER" --json title,body,state,author,headRefName,baseRefName)
echo "  Title: $(echo "$PR_DETAILS" | jq -r '.title')"
echo "  Author: $(echo "$PR_DETAILS" | jq -r '.author.login')"
echo "  Branch: $(echo "$PR_DETAILS" | jq -r '.headRefName') -> $(echo "$PR_DETAILS" | jq -r '.baseRefName')"
echo

# Step 2: Run quality checks
echo "[Step 2] Running quality checks..."
if "$SCRIPT_DIR/pr-check.sh" "$PR_NUMBER"; then
  echo "  ✓ Quality checks passed"
else
  echo "  ✗ Quality checks failed"
  exit 1
fi
echo

# Step 3: Run automated review
echo "[Step 3] Running automated review..."
if "$SCRIPT_DIR/pr-review.sh" "$PR_NUMBER"; then
  echo "  ✓ Review passed"
else
  echo "  ✗ Review failed"
  echo "  Reviewer must manually review critical issues"
  exit 1
fi
echo

# Step 4: Check CI status
echo "[Step 4] Checking CI status..."
CI_STATUS=$(gh pr checks "$PR_NUMBER" --json name,conclusion | jq -r '.[] | "\(.name): \(.conclusion)"')
FAILING_CHECKS=$(gh pr checks "$PR_NUMBER" --json conclusion | jq -r '[.[] | select(.conclusion == "FAILURE" or .conclusion == "TIMED_OUT")] | length')

if [ "$FAILING_CHECKS" -eq 0 ]; then
  echo "  ✓ All CI checks passing"
else
  echo "  ✗ $FAILING_CHECKS failing check(s):"
  echo "$CI_STATUS" | grep -E "(FAILURE|TIMED_OUT)" | sed 's/^/    /'
  exit 1
fi
echo

# Step 5: Generate review report
echo "[Step 5] Generating review report..."
REPORT="tmp/pr-review-$PR_NUMBER-$(date +%Y%m%d-%H%M%S).md"
mkdir -p tmp

cat > "$REPORT" << REPORTEOF
# PR Review Report: #$PR_NUMBER

Generated: $(date)

## PR Information
- Title: $(echo "$PR_DETAILS" | jq -r '.title')
- Author: $(echo "$PR_DETAILS" | jq -r '.author.login')
- Branch: $(echo "$PR_DETAILS" | jq -r '.headRefName') -> $(echo "$PR_DETAILS" | jq -r '.baseRefName')

## Review Results

### Quality Checks
✓ Passed all quality checks

### Automated Review
✓ No critical issues found

### CI Status
✓ All checks passing

## Changes
REPORTEOF

# Get file changes
echo "" >> "$REPORT"
echo '\`\`\`' >> "$REPORT"
gh pr diff "$PR_NUMBER" --name-only >> "$REPORT"
echo '\`\`\`' >> "$REPORT"

echo "  ✓ Report saved to: $REPORT"
echo

echo "========================================"
echo "Review Complete - PR Approved!"
echo "========================================"
echo

echo "Next steps:"
echo "1. Review the full report: cat $REPORT"
echo "2. Review the code changes: gh pr diff $PR_NUMBER"
echo "3. Approve the PR: gh pr review $PR_NUMBER --approve"
echo "4. Merge the PR: gh pr merge $PR_NUMBER"
