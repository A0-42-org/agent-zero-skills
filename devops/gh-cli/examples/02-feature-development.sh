#!/bin/bash
# Example: Feature Development Workflow with gh CLI
# This script demonstrates a complete feature development cycle

# 1. Create feature issue
echo "Creating feature issue..."
FEATURE_PR_NUMBER=$(gh issue create \
  --title "Implement user authentication" \
  --body "## Task Description\n\nImplement JWT-based user authentication with login and logout functionality.\n\n## Requirements\n- User registration endpoint\n- User login endpoint\n- JWT token generation and validation\n- Password hashing with bcrypt\n- Refresh token mechanism\n\n## Checklist\n- [ ] Create user schema\n- [ ] Implement registration endpoint\n- [ ] Implement login endpoint\n- [ ] Implement logout endpoint\n- [ ] Add JWT middleware\n- [ ] Add password hashing\n- [ ] Write unit tests" \
  --label "phase-1,backend,critical" \
  --json number \
  --jq '.number'
)

echo "Created issue #${FEATURE_PR_NUMBER}"

# 2. Create feature branch
echo "Creating feature branch..."
FEATURE_BRANCH="feature/user-authentication"
git checkout -b $FEATURE_BRANCH

# 3. Implement feature...
echo "Implementing feature..."
# (Your implementation code goes here)

# 4. Commit changes
git add -A
git commit -m "feat: implement user authentication"

# 5. Push to remote
git push -u origin $FEATURE_BRANCH

# 6. Create Pull Request
echo "Creating Pull Request..."
gh pr create \
  --title "Implement user authentication" \
  --body "## Description\n\nThis PR implements JWT-based user authentication system with the following features:\n\n### Changes\n- Added user registration endpoint (`POST /api/auth/register`)\n- Added user login endpoint (`POST /api/auth/login`)\n- Added user logout endpoint (`POST /api/auth/logout`)\n- Implemented JWT token generation and validation\n- Added password hashing with bcrypt\n- Implemented refresh token mechanism\n- Added authentication middleware\n\n### Testing\n- Unit tests for auth endpoints\n- Integration tests with real JWT tokens\n- Password hashing verification tests\n\n### Related Issues\nCloses #${FEATURE_PR_NUMBER}" \
  --base main

echo "Feature development complete!"
echo "Issue #${FEATURE_PR_NUMBER} will be automatically closed when PR is merged."
