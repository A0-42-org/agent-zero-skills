#!/bin/bash
# Example: Project Initialization with gh CLI
# This script demonstrates setting up a new GitHub project

# 1. Create private repository
echo "Creating private repository..."
gh repo create my-project --private --description "A private project"

# 2. Clone the repository
echo "Cloning repository..."
cd ~
git clone git@github.com:$(gh auth status --show-token 2>&1 | grep "Logged in as" | awk '{print $4}')/my-project.git
cd my-project

# 3. Create project labels
echo "Creating project labels..."
gh label create phase-0 --color '0E8A16' --description 'Phase 0 tasks'
gh label create phase-1 --color '1D76DB' --description 'Phase 1 tasks'
gh label create phase-2 --color 'D4C5F9' --description 'Phase 2 tasks'
gh label create critical --color 'B60205' --description 'Critical priority'
gh label create high-priority --color 'FF7F00' --description 'High priority'
gh label create medium-priority --color 'E5E500' --description 'Medium priority'
gh label create backend --color '0E8A16' --description 'Backend tasks'
gh label create frontend --color '5319E7' --description 'Frontend tasks'
gh label create api --color '0066CC' --description 'API development'
gh label create database --color '008672' --description 'Database tasks'
gh label create docs --color '008672' --description 'Documentation'
gh label create bug --color 'B60205' --description 'Bug fix'
gh label create enhancement --color '84B6EB' --description 'Feature enhancement'
gh label create question --color 'CC317C' --description 'Question'

# 4. Create initial issues
echo "Creating initial issues..."

# Issue 1: Setup
gh issue create \
  --title "Phase 0: Initial Setup" \
  --body "## Task Description\n\nSet up the initial project structure and configuration.\n\n## Checklist\n- [ ] Initialize package.json\n- [ ] Set up TypeScript\n- [ ] Configure ESLint\n- [ ] Set up Prettier\n- [ ] Create basic directory structure" \
  --label "phase-0,backend,high-priority"

# Issue 2: Database
git checkout -b feature/database-setup
gh issue create \
  --title "Phase 0: Database Setup" \
  --body "## Task Description\n\nSet up the database schema and connection.\n\n## Checklist\n- [ ] Choose database technology\n- [ ] Design schema\n- [ ] Create migration files\n- [ ] Set up connection pool" \
  --label "phase-0,database,critical"

# Issue 3: API
git checkout -b feature/api-endpoints
gh issue create \
  --title "Phase 0: Basic API Endpoints" \
  --body "## Task Description\n\nCreate basic API endpoints for the application.\n\n## Checklist\n- [ ] Set up Express/Fastify\n- [ ] Create authentication endpoint\n- [ ] Create user endpoint\n- [ ] Add request validation" \
  --label "phase-0,api,high-priority"

echo "Project initialization complete!"
