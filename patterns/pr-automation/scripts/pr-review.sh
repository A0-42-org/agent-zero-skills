#!/bin/bash
# Automated PR Review Script
# Usage: ./pr-review.sh <pr-number>

set -e

PR_NUMBER=$1

if [ -z "$PR_NUMBER" ]; then
  echo "Error: PR number required"
  echo "Usage: $0 <pr-number>"
  exit 1
fi

echo "=== Reviewing PR #$PR_NUMBER ==="
echo

# Get PR details
PR_DETAILS=$(gh pr view "$PR_NUMBER" --json title,body,author,headRefName,baseRefName,additions,deletions,files)

# Display PR Info
echo "PR Information:"
echo "  Title: $(echo "$PR_DETAILS" | jq -r '.title')"
echo "  Author: $(echo "$PR_DETAILS" | jq -r '.author.login')"
echo "  Branch: $(echo "$PR_DETAILS" | jq -r '.headRefName') -> $(echo "$PR_DETAILS" | jq -r '.baseRefName')"
echo "  Changes: +$(echo "$PR_DETAILS" | jq -r '.additions') -$(echo "$PR_DETAILS" | jq -r '.deletions')"
echo

# Initialize review score
CRITICAL_ISSUES=0
WARNINGS=0
SUGGESTIONS=0

echo "--- Automated Review Criteria ---"
echo

# Check 1: Code Quality
echo "[1] Code Quality"
DIFF=$(gh pr diff "$PR_NUMBER")

# Check for proper formatting
if echo "$DIFF" | grep -qE "^\+.*{[[:space:]]+"; then
  echo "  ⚠ Inconsistent brace formatting detected"
  ((WARNINGS++))
else
  echo "  ✓ Formatting looks good"
fi

# Check for console.log/debug statements
if echo "$DIFF" | grep -E "^\+.*(console\.log|console\.debug|debugger)" | grep -v "^\+.*//.*console\.log" > /dev/null; then
  echo "  ⚠ Debug statements found in code"
  ((WARNINGS++))
else
  echo "  ✓ No debug statements"
fi
echo

# Check 2: Test Coverage
echo "[2] Test Coverage"
TEST_FILES=$(echo "$PR_DETAILS" | jq -r '.files[] | select(.path | test("(test|spec)\\.(ts|js|svelte)")) | .path' 2>/dev/null || echo "")
SOURCE_FILES=$(echo "$PR_DETAILS" | jq -r '.files[] | select(.path | test("^src/")) | select(.path | test("(test|spec)";"i") | not) | .path' 2>/dev/null || echo "")

if [ -n "$SOURCE_FILES" ]; then
  SOURCE_COUNT=$(echo "$SOURCE_FILES" | wc -l)
  TEST_COUNT=$(echo "$TEST_FILES" | wc -l)
  
  if [ "$TEST_COUNT" -eq 0 ]; then
    echo "  ✗ No test files added for $SOURCE_COUNT source file(s)"
    ((CRITICAL_ISSUES++))
  elif [ "$TEST_COUNT" -lt "$SOURCE_COUNT" ]; then
    echo "  ⚠ Test coverage incomplete: $TEST_COUNT tests for $SOURCE_COUNT source files"
    ((WARNINGS++))
  else
    echo "  ✓ Test coverage adequate"
  fi
else
  echo "  ⚠ No source files changed to test"
fi
echo

# Check 3: Documentation
echo "[3] Documentation"
DOC_FILES=$(echo "$PR_DETAILS" | jq -r '.files[] | select(.path | test("(README|TODO|DIRECTIVES|CHANGELOG|AGENTS)\\.(md|txt)")) | .path' 2>/dev/null || echo "")

if [ -n "$DOC_FILES" ]; then
  echo "  ✓ Documentation updated:"
  echo "$DOC_FILES" | sed 's/^/    - /'
else
  echo "  ⚠ No documentation changes detected"
  ((SUGGESTIONS++))
fi
echo

# Check 4: Security
echo "[4] Security Check"
SECURITY_ISSUES=0

# Check for potential secrets
if echo "$DIFF" | grep -E "^\+.*(password|secret|api_key|token|private_key).*=.*['\"]" | grep -v "^\+.*//.*password" > /dev/null; then
  echo "  ✗ Potential secrets hardcoded in code"
  ((CRITICAL_ISSUES++))
  ((SECURITY_ISSUES++))
fi

# Check for .env file changes
if echo "$PR_DETAILS" | jq -r '.files[] | .path' | grep -q "\.env"; then
  echo "  ⚠ .env file modified - ensure no secrets committed"
  ((WARNINGS++))
fi

if [ "$SECURITY_ISSUES" -eq 0 ]; then
  echo "  ✓ No security issues detected"
fi
echo

# Check 5: Best Practices for Vialto
echo "[5] Vialto Best Practices"

# Check for bun usage (not npm)
if echo "$DIFF" | grep -E "^\+.*npm (install|run)" | grep -v "^\+.*//.*npm" > /dev/null; then
  echo "  ⚠ npm commands detected - should use bun"
  ((WARNINGS++))
else
  echo "  ✓ Package manager looks correct"
fi

# Check for Svelte 5 runes usage if applicable
if echo "$PR_DETAILS" | jq -r '.files[] | .path' | grep -q "\.svelte$"; then
  if echo "$DIFF" | grep -E "^\+.*(onMount|onDestroy|beforeUpdate|afterUpdate)" | grep -v "^\+.*//.*on" > /dev/null; then
    echo "  ⚠ Legacy Svelte lifecycle methods detected - consider using Svelte 5 runes"
    ((SUGGESTIONS++))
  fi
fi
echo

# Review Summary
echo "--- Review Summary ---"
echo "Critical Issues: $CRITICAL_ISSUES"
echo "Warnings: $WARNINGS"
echo "Suggestions: $SUGGESTIONS"
echo

# Make recommendation
if [ "$CRITICAL_ISSUES" -gt 0 ]; then
  echo "❌ REVIEW: CRITICAL ISSUES FOUND"
  echo "PR requires fixes before merge."
  exit 1
elif [ "$WARNINGS" -gt 2 ]; then
  echo "⚠️  REVIEW: ISSUES FOUND"
  echo "PR has multiple warnings that should be addressed."
  exit 1
else
  echo "✅ REVIEW: PASSED"
  echo "PR is ready for merge."
  if [ "$SUGGESTIONS" -gt 0 ]; then
    echo "Note: $SUGGESTIONS suggestion(s) for improvement."
  fi
fi
