---
name: "dokploy"
description: "Manage Dokploy server remotely via API and CLI. Use for deploying SvelteKit applications from GitHub, creating projects, applications, databases, and managing deployments."
version: "1.1.0"
author: "Agent Zero Team"
tags: ["deployment", "dokploy", "sveltekit", "github", "devops", "api"]
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
This skill provides workflows for managing a Dokploy server using both the **CLI** and the **REST API**. It focuses on deploying SvelteKit applications from GitHub repositories.

## Prerequisites

### Installation
1. **Install Bun package manager**:
   ```bash
   curl -fsSL https://bun.sh/install | bash
   export PATH="$HOME/.bun/bin:$PATH"
   ```

2. **Install Dokploy CLI**:
   ```bash
   bun install -g @dokploy/cli
   ```

### Authentication
The Dokploy CLI and API require authentication with a server URL and an API token.

**Credentials:**
- Server URL: `http://192.168.1.110:3000/`
- API Token: Available in environment variable `DOKPLOY_API_KEY` or user settings
- Email: `a0@ludoapex.fr`

**Authenticating the CLI:**
```bash
export PATH="$HOME/.bun/bin:$PATH"
dokploy authenticate --url http://192.168.1.110:3000/ --token $DOKPLOY_API_KEY
```

**Verifying Authentication:**
```bash
dokploy verify
```

**API Authentication:**
All API requests must include the header: `x-api-key: YOUR_API_TOKEN`

## API Endpoints Reference

### Projects
- **List Projects**: `GET /api/project.all`
- **Project Info**: `GET /api/project.info` (Body: `{ "projectId": "..." }`)

### Applications
- **Create Application**: `POST /api/application.create`
  ```json
  { "name": "app-name", "description": "desc", "environmentId": "env-id" }
  ```
- **Update Application**: `POST /api/application.update`
  ```json
  { "applicationId": "...", "repository": "repo", "owner": "org", "branch": "main" }
  ```
- **Save Build Type**: `POST /api/application.saveBuildType`
  ```json
  { "applicationId": "...", "buildType": "dockerfile", "dockerContextPath": "." }
  ```
- **Deploy Application**: `POST /api/application.deploy`
  ```json
  { "applicationId": "..." }
  ```

### Deployments
- **List Deployments**: `GET /api/deployment.all?applicationId=...`

## Core Workflows via API

### Workflow 1: Deploy a SvelteKit Application (API Method)

This is the preferred method for automation.

1. **Get Project and Environment IDs**:
   ```bash
   curl -X GET 'http://192.168.1.110:3000/api/project.all' -H 'x-api-key: $DOKPLOY_API_KEY'
   ```
   Note the `projectId` (e.g., `Q1lSu64fI4nIB038SpKQa` for "Agent0") and the `environmentId` (e.g., `4xRZ7Ft4ryueLkjP_qz77` for "production").

2. **Create the Application**:
   ```bash
   curl -X POST 'http://192.168.1.110:3000/api/application.create' \
     -H 'Content-Type: application/json' -H 'x-api-key: $DOKPLOY_API_KEY' \
     -d '{ "name": "landing", "description": "Agent Zero Landing", "environmentId": "4xRZ7Ft4ryueLkjP_qz77" }'
   ```
   Save the returned `applicationId`.

3. **Configure GitHub Repository**:
   ```bash
   curl -X POST 'http://192.168.1.110:3000/api/application.update' \
     -H 'Content-Type: application/json' -H 'x-api-key: $DOKPLOY_API_KEY' \
     -d '{ 
       "applicationId": "UnsOa05EUzK4d-E0HI5yq", 
       "repository": "agent-zero-landing", 
       "owner": "A0-42-org", 
       "branch": "main" 
     }'
   ```

4. **Configure Build Settings (Dockerfile)**:
   *Note: For SvelteKit, use a Dockerfile or configure Nixpacks correctly.*
   ```bash
   curl -X POST 'http://192.168.1.110:3000/api/application.saveBuildType' \
     -H 'Content-Type: application/json' -H 'x-api-key: $DOKPLOY_API_KEY' \
     -d '{ 
       "applicationId": "UnsOa05EUzK4d-E0HI5yq", 
       "buildType": "dockerfile", 
       "dockerContextPath": "." 
     }'
   ```

5. **Trigger Deployment**:
   ```bash
   curl -X POST 'http://192.168.1.110:3000/api/application.deploy' \
     -H 'Content-Type: application/json' -H 'x-api-key: $DOKPLOY_API_KEY' \
     -d '{ "applicationId": "UnsOa05EUzK4d-E0HI5yq" }'
   ```

## SvelteKit Configuration Requirements

### Adapter Configuration
Dokploy expects a server that listens on a port. SvelteKit requires an adapter.


**Recommended**: Use `@sveltejs/adapter-node`.

1. Install the adapter:
   ```bash
   cd /path/to/project
   bun add -d @sveltejs/adapter-node
   ```

2. Update `svelte.config.js`:
   ```javascript
   import adapter from '@sveltejs/adapter-node';
   const config = {
     kit: { adapter: adapter() }
   };
   ```

### Dockerfile (Optional but Recommended)
If using the `dockerfile` build type, ensure you have a valid Dockerfile in the root of your repository.

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json bun.lock ./
RUN npm install -g bun && bun install
COPY . .
RUN bun run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/build ./
COPY package.json ./
RUN npm install -g bun && bun install --production
EXPOSE 3000
CMD ["node", "index.js"]
```

## GitHub Organization Configuration

**Important:** All repositories must be created in the `A0-42-org` organization.

**Repository URL format:** `A0-42-org/repository-name`

## Troubleshooting

### Deployment Fails Instantly (Status: error)

**Symptoms**: Deployment status changes to `error` within milliseconds (< 100ms).

**Possible Causes**:
1. **Missing Adapter**: Project uses `adapter-auto` which might not produce a server output suitable for Dokploy.
   - **Fix**: Switch to `adapter-node` and provide a Dockerfile or use Nixpacks config.
2. **Invalid Build Configuration**: The build type does not match the repository contents.
   - **Fix**: Verify `buildType` matches your setup (`dockerfile`, `nixpacks`, `heroku`).
3. **Missing Dependencies**: Required packages for the chosen adapter are not installed.
   - **Fix**: Ensure `@sveltejs/adapter-node` is in `devDependencies`.

**How to Debug**:
- API Logs: The `deployment.all` endpoint provides a `logPath`, but logs are stored on the server filesystem (e.g., `/etc/dokploy/logs/...`). These are not always accessible via the public API.
- Web UI: Navigate to the application in the Dokploy UI to view real-time build logs.

### Authentication Issues

**Problem**: `dokploy verify` fails

**Solution**:
1. Check if the API token is valid in Dokploy web interface.
2. Verify server URL is correct: `http://192.168.1.110:3000/`
3. Re-authenticate: `dokploy authenticate --url URL --token TOKEN`

## Existing Infrastructure

- **Project Name**: Agent0
- **Project ID**: `Q1lSu64fI4nIB038SpKQa`
- **Environment**: Production (`4xRZ7Ft4ryueLkjP_qz77`)

- **Organization**: `A0-42-org`

## Additional Resources

- Dokploy Documentation: https://docs.dokploy.com
- Dokploy API Reference: https://docs.dokploy.com/docs/api
- SvelteKit Documentation: https://kit.svelte.dev

## Version History

- **1.1.0** - Added API workflows, troubleshooting for instant errors, and SvelteKit specific configuration.
- **1.0.0** - Initial release.
