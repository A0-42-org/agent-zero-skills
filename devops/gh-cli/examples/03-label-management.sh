#!/bin/bash
# Example: Label Management Workflow with gh CLI
# This script demonstrates creating and managing GitHub labels

echo "=== GitHub Label Management Workflow ==="

# Phase Labels
echo "Creating Phase labels..."
gh label create phase-0 --color '0E8A16' --description 'Tasks for Phase 0' 2>/dev/null || echo "phase-0 already exists"
gh label create phase-1 --color '1D76DB' --description 'Tasks for Phase 1' 2>/dev/null || echo "phase-1 already exists"
gh label create phase-2 --color 'D4C5F9' --description 'Tasks for Phase 2' 2>/dev/null || echo "phase-2 already exists"
gh label create phase-3 --color 'F1D875' --description 'Tasks for Phase 3' 2>/dev/null || echo "phase-3 already exists"

# Priority Labels
echo "Creating Priority labels..."
gh label create critical --color 'B60205' --description 'Critical priority tasks' 2>/dev/null || echo "critical already exists"
gh label create high-priority --color 'FF7F00' --description 'High priority tasks' 2>/dev/null || echo "high-priority already exists"
gh label create medium-priority --color 'E5E500' --description 'Medium priority tasks' 2>/dev/null || echo "medium-priority already exists"
gh label create low-priority --color '7058FF' --description 'Low priority tasks' 2>/dev/null || echo "low-priority already exists"

# Type Labels
echo "Creating Type labels..."
gh label create bug --color 'B60205' --description 'Bug fix needed' 2>/dev/null || echo "bug already exists"
gh label create enhancement --color '84B6EB' --description 'Feature enhancement' 2>/dev/null || echo "enhancement already exists"
gh label create question --color 'CC317C' --description 'Question or support' 2>/dev/null || echo "question already exists"
gh label create documentation --color '0E8A16' --description 'Documentation needed' 2>/dev/null || echo "documentation already exists"
gh label create duplicate --color 'CCCCCC' --description 'Duplicate issue' 2>/dev/null || echo "duplicate already exists"
gh label create wontfix --color 'FFFFFF' --description 'Will not fix' 2>/dev/null || echo "wontfix already exists"

# Component Labels
echo "Creating Component labels..."
gh label create backend --color '0E8A16' --description 'Backend tasks and features' 2>/dev/null || echo "backend already exists"
gh label create frontend --color '5319E7' --description 'Frontend tasks and features' 2>/dev/null || echo "frontend already exists"
gh label create api --color '0066CC' --description 'API development tasks' 2>/dev/null || echo "api already exists"
gh label create service --color 'D4C5F9' --description 'Service layer tasks' 2>/dev/null || echo "service already exists"
gh label create database --color '008672' --description 'Database related tasks' 2>/dev/null || echo "database already exists"
gh label create ui --color '5319E7' --description 'UI/UX improvements' 2>/dev/null || echo "ui already exists"
gh label create testing --color 'FCE2C6' --description 'Testing related tasks' 2>/dev/null || echo "testing already exists"
gh label create infrastructure --color '006B75' --description 'Infrastructure and DevOps tasks' 2>/dev/null || echo "infrastructure already exists"

echo "=== Listing all labels ==="
gh label list

echo "=== Label management complete! ==="
