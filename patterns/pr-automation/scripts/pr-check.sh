#!/bin/bash
# PR Quality Check Script
# Usage: ./pr-check.sh <pr-number>

set -e

PR_NUMBER=$1

if [ -z "$PR_NUMBER" ]; then
  echo "Error: PR number required"
  echo "Usage: $0 <pr-number>"
  exit 1
fi

echo "=== Checking PR #$PR_NUMBER ==="
echo

# Get PR details
PR_DETAILS=$(gh pr view "$PR_NUMBER" --json title,body,labels,state,author,mergeable)

# Check 1: Title
echo "[1/9] Checking PR title..."
TITLE=$(echo "$PR_DETAILS" | jq -r '.title')
if [ -n "$TITLE" ] && [ ${#TITLE} -ge 10 ]; then
  echo "  ✓ Title is descriptive: $TITLE"
else
  echo "  ✗ Title too short or missing"
  exit 1
fi
echo

# Check 2: Body/Description
echo "[2/9] Checking PR description..."
BODY=$(echo "$PR_DETAILS" | jq -r '.body')
if [ -n "$BODY" ] && [ ${#BODY} -ge 50 ]; then
  echo "  ✓ Description present (${#BODY} characters)"
else
  echo "  ✗ Description too short or missing"
  exit 1
fi
echo

# Check 3: Linked Issues
echo "[3/9] Checking for linked issues..."
LINKED_ISSUES=$(echo "$BODY" | grep -oE '#[0-9]+' | sort -u || true)
if [ -n "$LINKED_ISSUES" ]; then
  echo "  ✓ Linked issues: $LINKED_ISSUES"
else
  echo "  ✗ No linked issues found (use 'Closes #1' or 'Fixes #1')"
  exit 1
fi
echo

# Check 4: Labels
echo "[4/9] Checking PR labels..."
LABELS=$(echo "$PR_DETAILS" | jq -r '.labels[] | .name' 2>/dev/null || true)
if [ -n "$LABELS" ]; then
  echo "  ✓ Labels present:"
  echo "$LABELS" | sed 's/^/    - /'
else
  echo "  ⚠ No labels found"
fi
echo

# Check 5: Merge conflicts
echo "[5/9] Checking for merge conflicts..."
MERGEABLE=$(echo "$PR_DETAILS" | jq -r '.mergeable')
if [ "$MERGEABLE" = "MERGEABLE" ]; then
  echo "  ✓ No merge conflicts"
else
  echo "  ✗ Merge conflicts detected or mergeability unknown"
  exit 1
fi
echo

# Check 6: CI Checks
echo "[6/9] Checking CI status..."
CI_OUTPUT=$(gh pr checks "$PR_NUMBER" 2>/dev/null || echo "")
if [ -n "$CI_OUTPUT" ]; then
  FAILING=$(echo "$CI_OUTPUT" | grep -c "failing" || echo "0")
  if [ "$FAILING" -eq 0 ]; then
    echo "  ✓ All CI checks passing"
  else
    echo "  ✗ $FAILING failing check(s)"
    exit 1
  fi
else
  echo "  ⚠ No CI checks configured"
fi
echo

# Check 7: Code guidelines (placeholder for custom rules)
echo "[7/9] Checking code guidelines..."
DIFF=$(gh pr diff "$PR_NUMBER")
if [ -n "$DIFF" ]; then
  # Check for common issues
  if echo "$DIFF" | grep -qE "\.(password|secret|api_key|token)"; then
    echo "  ✗ Potential secrets found in code"
    exit 1
  fi
  echo "  ✓ Code guidelines check passed"
else
  echo "  ⚠ No changes to check"
fi
echo

# Check 8: Tests
echo "[8/9] Checking for test coverage..."
TEST_FILES=$(echo "$DIFF" | grep -cE "(test|spec)\.(ts|js|svelte)" || echo "0")
if [ "$TEST_FILES" -gt 0 ]; then
  echo "  ✓ Test files changed: $TEST_FILES"
else
  echo "  ⚠ No test files detected"
fi
echo

# Check 9: Documentation
echo "[9/9] Checking documentation..."
DOC_FILES=$(echo "$DIFF" | grep -cE "(README|TODO|DIRECTIVES|CHANGELOG)\.(md|txt)" || echo "0")
if [ "$DOC_FILES" -gt 0 ]; then
  echo "  ✓ Documentation updated: $DOC_FILES file(s)"
else
  echo "  ⚠ No documentation changes detected"
fi
echo

echo "=== Quality Check Complete ==="
echo "All critical checks passed! PR #$PR_NUMBER is ready for review."
