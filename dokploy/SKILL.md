---
name: "dokploy"
description: "Manage Dokploy server remotely. Use for deploying SvelteKit applications from GitHub, creating projects, applications, databases, and managing deployments."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["deployment", "dokploy", "sveltekit", "github", "devops"]
trigger_patterns:
  - "dokploy"
  - "deploy"
  - "create application"
  - "deploy sveltekit"
  - "dokploy project"
  - "deploy github"
allowed_tools:
  - "code_execution_tool"
  - "browser_agent"
  - "document_query"
  - "memory_save"
  - "memory_load"
---

# Dokploy Deployment Skill

## Overview
This skill provides automated workflows for managing a Dokploy server and deploying SvelteKit applications from GitHub repositories.

## Prerequisites

### Installation
1. Install Bun package manager:
   ```bash
   curl -fsSL https://bun.sh/install | bash
   export PATH="$HOME/.bun/bin:$PATH"
   ```

2. Install Dokploy CLI:
   ```bash
   bun install -g @dokploy/cli
   ```

### Authentication
The Dokploy CLI requires authentication with a server URL and API token.

**Credentials:**
- Server URL: `http://192.168.1.110:3000/`
- API Token: Available in environment variables or Dokploy web interface
- Email: `a0@ludoapex.fr`
- Password: `6dlQz6HEeQq8ldn31pAC6LzOqcFwLi`

**Authenticating the CLI:**
```bash
export PATH="$HOME/.bun/bin:$PATH"
dokploy authenticate --url http://192.168.1.110:3000/ --token YOUR_API_TOKEN
```

**Verify Authentication:**
```bash
dokploy verify
```

## Core Commands

### Project Management

**List all projects:**
```bash
dokploy project list
```

**Get project information:**
```bash
dokploy project info --projectId PROJECT_ID
```

**Create a new project:**
```bash
dokploy project create --name "my-project" --description "My project description"
```

### Application Management

**Create a new application:**
```bash
dokploy app create --projectId PROJECT_ID --name "my-app" --description "My app" --appName "docker-app-name" --skipConfirm
```

**Deploy an application:**
```bash
dokploy app deploy --projectId PROJECT_ID --applicationId APPLICATION_ID --skipConfirm
```

**Stop an application:**
```bash
dokploy app stop --projectId PROJECT_ID --applicationId APPLICATION_ID --skipConfirm
```

**Delete an application:**
```bash
dokploy app delete --projectId PROJECT_ID --applicationId APPLICATION_ID --skipConfirm
```

## GitHub Organization Configuration

**Important:** All repositories must be created in the `A0-42-org` organization.

**GitHub Organization Details:**
- Organization Name: `A0-42-org`
- URL: https://github.com/A0-42-org
- Repository Naming Convention: kebab-case (e.g., `my-awesome-project`)

**Creating a GitHub Repository:**
```bash
gh repo create A0-42-org/<repo-name> --private --description "<description>"
```

## Workflows for SvelteKit Deployment

### Workflow 1: Create and Deploy a SvelteKit Application

1. **Create a SvelteKit project locally** (using the `sveltekit-skeleton-init` skill):
   ```bash
   # Use the sveltekit-skeleton-init skill to create a new SvelteKit project
   ```

2. **Create a GitHub repository in the organization**:
   ```bash
   gh repo create A0-42-org/my-sveltekit-app --private --description "My SvelteKit application"
   ```

3. **Push the project to GitHub**:
   ```bash
   cd /path/to/my-sveltekit-app
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin git@github.com:A0-42-org/my-sveltekit-app.git
   git push -u origin main
   ```

4. **Create a project in Dokploy**:
   ```bash
   dokploy project create --name "sveltekit-project" --description "My SvelteKit applications"
   ```

5. **Create an application in Dokploy** (this will use the project ID from step 4):
   ```bash
   # First, list projects to get the ID
   dokploy project list
   
   # Then create the application with the project ID
   dokploy app create --projectId PROJECT_ID --name "my-sveltekit-app" --description "My SvelteKit application" --skipConfirm
   ```

6. **Configure the application** (via Dokploy web interface):
   - Navigate to http://192.168.1.110:3000/
   - Go to the project and application created
   - Configure the repository settings (GitHub repository: `A0-42-org/my-sveltekit-app`)
   - Configure build settings for SvelteKit:
     - Build Command: `bun run build`
     - Install Command: `bun install`
     - Start Command: `node build`
   - Set environment variables if needed

7. **Deploy the application**:
   ```bash
   # First, list applications to get the application ID
   dokploy project info --projectId PROJECT_ID
   
   # Then deploy the application
   dokploy app deploy --projectId PROJECT_ID --applicationId APPLICATION_ID --skipConfirm
   ```

### Workflow 2: Deploy an Existing SvelteKit Project

If you already have a SvelteKit project locally (e.g., `agent-zero-landing`):

1. **Ensure the project is on GitHub**:
   ```bash
   cd /a0/usr/workdir/agent-zero-landing
   git remote -v
   
   # If not on GitHub, create the repository and push
   gh repo create A0-42-org/agent-zero-landing --private --description "Agent Zero Landing Page"
   git remote add origin git@github.com:A0-42-org/agent-zero-landing.git
   git branch -M main
   git push -u origin main
   ```

2. **Create a project in Dokploy**:
   ```bash
   dokploy project create --name "agent-zero" --description "Agent Zero applications"
   ```

3. **Create an application in Dokploy**:
   ```bash
   # First, list projects to get the ID
   dokploy project list
   
   # Then create the application with the project ID
   dokploy app create --projectId PROJECT_ID --name "landing" --description "Agent Zero Landing Page" --skipConfirm
   ```

4. **Configure the application** (via Dokploy web interface):
   - Navigate to http://192.168.1.110:3000/
   - Go to the project and application created
   - Configure the repository settings (GitHub repository: `A0-42-org/agent-zero-landing`)
   - Configure build settings for SvelteKit:
     - Build Command: `bun run build`
     - Install Command: `bun install`
     - Start Command: `node build`
   - Set environment variables if needed

5. **Deploy the application**:
   ```bash
   # First, list applications to get the application ID
   dokploy project info --projectId PROJECT_ID
   
   # Then deploy the application
   dokploy app deploy --projectId PROJECT_ID --applicationId APPLICATION_ID --skipConfirm
   ```

## Environment Variables Management

Environment variables can be configured through the Dokploy web interface:
1. Navigate to your application in the Dokploy web interface
2. Go to the "Environment Variables" section
3. Add your variables (e.g., `DATABASE_URL`, `API_KEY`)

## Troubleshooting

### Authentication Issues

**Problem**: `dokploy verify` fails

**Solution**:
1. Check if the API token is valid in Dokploy web interface
2. Verify server URL is correct: `http://192.168.1.110:3000/`
3. Re-authenticate: `dokploy authenticate --url URL --token TOKEN`

### Deployment Failures

**Problem**: Build or deployment fails

**Solution**:
1. Check build logs in the Dokploy web interface
2. Verify build commands for SvelteKit:
   - Install: `bun install`
   - Build: `bun run build`
3. Check environment variables
4. Verify repository access and branch existence

### GitHub Connection Issues

**Problem**: Cannot connect to GitHub repository

**Solution**:
1. Verify repository URL format: `A0-42-org/repo-name`
2. Check GitHub permissions for the organization
3. Ensure Dokploy has GitHub access configured
4. Verify branch name is correct (usually `main`)

## Example Use Cases

### Deploy the agent-zero-landing project

```bash
# Ensure the project is on GitHub
cd /a0/usr/workdir/agent-zero-landing
git remote -v

# If not on GitHub, create the repository and push
gh repo create A0-42-org/agent-zero-landing --private --description "Agent Zero Landing Page"
git remote add origin git@github.com:A0-42-org/agent-zero-landing.git
git branch -M main
git push -u origin main

# Create a project in Dokploy (if not already created)
dokploy project create --name "agent-zero" --description "Agent Zero applications"

# List projects to get the ID
dokploy project list

# Create an application in Dokploy (replace PROJECT_ID with the actual ID)
dokploy app create --projectId 2 --name "landing" --description "Agent Zero Landing Page" --skipConfirm

# List applications to get the application ID
dokploy project info --projectId 2

# Configure the application via Dokploy web interface
# Navigate to http://192.168.1.110:3000/ and configure:
# - Repository: A0-42-org/agent-zero-landing
# - Build Command: bun run build
# - Install Command: bun install
# - Start Command: node build

# Deploy the application (replace APPLICATION_ID with the actual ID)
dokploy app deploy --projectId 2 --applicationId APPLICATION_ID --skipConfirm
```

## Additional Resources

- Dokploy Documentation: https://docs.dokploy.com
- SvelteKit Documentation: https://kit.svelte.dev
- GitHub Webhooks: https://docs.github.com/en/developers/webhooks-and-events/webhooks

## Version History

- **1.0.0** - Initial release with SvelteKit deployment support and GitHub organization integration
