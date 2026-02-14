---
name: "dokploy"
description: "Manage Dokploy server remotely via API and CLI. Use for deploying SvelteKit applications from GitHub, creating projects, applications, databases, and managing deployments."
version: "1.5.0"
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


**Important Security Note**: NEVER hardcode API tokens in code or documentation. Always use environment variables.

**Credentials:**
- Server URL: `http://192.168.1.110:3000/`
- API Token: Available in environment variable `$DOKPLOY_API_KEY` (from user settings)
- Email: `a0@ludoapex.fr`

**Authenticating CLI:**
```bash
export PATH="$HOME/.bun/bin:$PATH"
dokploy authenticate --url http://192.168.1.110:3000/ --token $DOKPLOY_API_KEY
```

**Verifying Authentication:**
```bash
dokploy verify
```

## API Endpoints Reference (from OpenAPI)

### Authentication
**Required Header**: `x-api-key: YOUR_API_TOKEN`

**Security Scheme**: API Key Authentication
- Type: apiKey
- In: header
- Name: x-api-key

**NEVER use `Authorization: Bearer`** - all requests use `x-api-key` header.

### Application Management Endpoints

#### Create Application
- **Endpoint**: `POST /api/application.create`
- **Request Body**:
  ```json
  {
    "name": "string (minLength: 1)",
    "appName": "string (minLength: 1, maxLength: 63, pattern: ^[a-zA-Z0-9._-]+$)",
    "description": "string (nullable)",
    "environmentId": "string",
    "serverId": "string (nullable)"
  }
  ```

#### Update Application
- **Endpoint**: `POST /api/application.update`
- **Description**: Update application configuration (repository, build type, etc.)
- **Request Body**: Contains all application configuration (see OpenAPI for full schema)

#### Save GitHub Provider
- **Endpoint**: `POST /api/application.saveGithubProvider`
- **Description**: Configure GitHub repository for the application
- **Request Body**:
  ```json
  {
    "applicationId": "string (required)",
    "githubId": "string (required)",
    "owner": "string (required)",
    "repository": "string (required)",
    "branch": "string (required)",
    "buildPath": "string"
  }
  ```

**Example**:
```bash
curl -X POST "http://192.168.1.110:3000/api/application.saveGithubProvider" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d '{
    "applicationId": "app_xxx",
    "githubId": "ghprov_xxx",
    "owner": "A0-42-org",
    "repository": "segre-vip",
    "branch": "main",
    "buildPath": "."
  }'
```

#### Save Build Type
- **Endpoint**: `POST /api/application.saveBuildType`
- **Request Body**:
  ```json
  {
    "applicationId": "string (required)",
    "buildType": "dockerfile | heroku_buildpacks | paketo_buildpacks | nixpacks | static | railpack",
    "dockerfile": "string (nullable)",
    "dockerContextPath": "string (nullable)",
    "dockerBuildStage": "string (nullable)",
    "publishDirectory": "string (nullable)",
    "isStaticSpa": "boolean (nullable)"
  }
  ```

**CRITICAL**: The `publishDirectory` parameter tells Dokploy where to find the built application. This is essential for deployment success.

#### Save Environment
- **Endpoint**: `POST /api/application.saveEnvironment`
- **Description**: Configure environment variables and build arguments for an application
- **Request Body**:
  ```json
  {
    "applicationId": "string (required)",
    "env": "string (multiline .env format, nullable)",
    "buildArgs": "string (multiline build arguments, nullable)",
    "buildSecrets": "string (multiline secrets, nullable)",
    "createEnvFile": "boolean"
  }
  ```

**Example**:
```bash
curl -X POST "http://192.168.1.110:3000/api/application.saveEnvironment" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d '{
    "applicationId": "APP_ID",
    "env": "DATABASE_URL=postgres://...\nSECRET=value"
  }'
```

#### Deploy Application
- **Endpoint**: `POST /api/application.deploy`
- **Request Body**:
  ```json
  {
    "applicationId": "string (required)",
    "title": "string",
    "description": "string"
  }
  ```

#### List Deployments
- **Endpoint**: `GET /api/deployment.all?applicationId=...`
- **Description**: Get all deployments for a specific application

#### Get Application Details
- **Endpoint**: `GET /api/application.one?applicationId=...`

### Project & Environment Endpoints

#### List Projects
- **Endpoint**: `GET /api/project.all`
#### Create Environment
- **Endpoint**: `POST /api/environment.create`
- **Request Body**:
  ```json
  {
    "name": "string (minLength: 1)",
    "description": "string (nullable)",
    "projectId": "string"
  }
  ```
#### Get Environment by Project
- **Endpoint**: `GET /api/environment.byProjectId?projectId=...`

### User Authentication
#### Get Current User
- **Endpoint**: `GET /api/user.get`
- **Description**: Get authenticated user information

## SvelteKit Configuration Requirements

### Adapter Configuration
Dokploy expects a server that listens on a port. SvelteKit requires an adapter.

**Recommended**: Use `@sveltejs/adapter-node`.

1. Install adapter:
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

### Build Configuration

SvelteKit with `adapter-node` generates output in `.svelte-kit/output/`.

The build type should be configured accordingly in Dokploy:
- **dockerfile**: Use with a custom Dockerfile
- **nixpacks**: Use with a `nixpacks.toml` file
- **static**: For static sites only

**Important**: Consult SvelteKit documentation for proper Dockerfile configuration.

## CRITICAL: Publish Directory Configuration

### Why Publish Directory is Essential

The `publishDirectory` parameter in Dokploy's build configuration tells Dokploy **where to find the built application** inside the container. This is a CRITICAL setting that often causes deployment failures when misconfigured.

### How it Works

1. **SvelteKit Build**: `adapter-node` generates the application in `.svelte-kit/output/`
2. **Docker/Nixpacks**: The build process copies files to a specific directory
3. **Dokploy**: Looks in the `publishDirectory` to find the built application

### Correct Configuration for SvelteKit + adapter-node

#### Using Dockerfile

**Dockerfile**:
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY . .
RUN bun install --frozen-lockfile
RUN bun run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/.svelte-kit/output ./build
CMD ["node", "build/server/index.js"]
```

**Dokploy Configuration**:
- **Build Type**: `dockerfile`
- **Publish Directory**: `./build`

**Explanation**:
- SvelteKit builds to `.svelte-kit/output/`
- Dockerfile copies `.svelte-kit/output/` to `./build`
- Dokploy looks in `./build` to find the application

#### Using Nixpacks

**package.json** (for Nixpacks):
```json
{
  "engines": {
    "node": "22"
  }
}
```

**Dokploy Configuration**:
- **Build Type**: `nixpacks`
- **Publish Directory**: `./build`

**Explanation**:
- Nixpacks builds the application
- Output is typically in `./build` or `.svelte-kit/output/`
- Dokploy looks in `./build` to find the application
### Common Mistakes

**❌ WRONG - Missing publishDirectory**:
```bash
curl -X POST "http://192.168.1.110:3000/api/application.saveBuildType" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d '{
    "applicationId": "app_xxx",
    "buildType": "dockerfile"
    # publishDirectory is MISSING!
  }'
```
**Result**: Deployment fails instantly or returns 404.

**❌ WRONG - Wrong publishDirectory**:
```bash
curl -X POST "http://192.168.1.110:3000/api/application.saveBuildType" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d '{
    "applicationId": "app_xxx",
    "buildType": "dockerfile",
    "publishDirectory": ".svelte-kit/output" # WRONG!
  }'
```
**Result**: Dokploy cannot find the application in `.svelte-kit/output/` (it was copied to `./build` by Dockerfile).

**✅ CORRECT - Proper publishDirectory**:
```bash
curl -X POST "http://192.168.1.110:3000/api/application.saveBuildType" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d '{
    "applicationId": "app_xxx",
    "buildType": "dockerfile",
    "publishDirectory": "./build" # CORRECT!
  }'
```
**Result**: Deployment succeeds because Dokploy finds the application in `./build`.
## Package.json Configuration for Nixpacks

### Critical: Engines Field

**IMPORTANT**: When using Nixpacks, always specify the Node.js version in `package.json` using the `engines` field.

Without this field, Nixpacks may default to Node.js 18.x which is End-Of-Life and has been removed, causing build failures.

**Example package.json with engines field:**
```json
{
  "name": "my-sveltekit-app",
  "version": "0.0.1",
  "type": "module",
  "engines": {
    "node": "22"
  },
  "scripts": {
    "dev": "vite dev",
    "build": "vite build",
    "preview": "vite preview"
  }
}
```

**Supported Node versions** (as of 2026):
- Node.js 22 (recommended)
- Node.js 20
- Node.js 18 (EOL, do not use)

**Best Practice**: Always test with the same Node.js version locally before deploying.

## GitHub Organization Configuration

**Important:** All repositories must be created in the `A0-42-org` organization.

**Repository URL format:** `A0-42-org/repository-name`

## Existing Infrastructure

- **Project Name**: Agent0
- **Project ID**: `Q1lSu64fI4nIB038SpKQa`
- **Environment**: Production (`4xRZ7Ft4ryueLkjP_qz77`)
- **Organization**: `A0-42-org`

## Troubleshooting

### Deployment Fails Instantly (Status: error)

**Symptoms**: Deployment status changes to `error` within milliseconds (< 100ms).

**Possible Causes**:
1. **Missing Publish Directory**: The `publishDirectory` is not set or is incorrect.
   - **Fix**: Set `publishDirectory: "./build"` in `/api/application.saveBuildType`
2. **Missing Adapter**: Project uses `adapter-auto` which might not produce a server output suitable for Dokploy.
   - **Fix**: Switch to `adapter-node` and provide a Dockerfile or use Nixpacks config.
3. **Invalid Build Configuration**: The build type does not match the repository contents.
   - **Fix**: Verify `buildType` matches your setup (`dockerfile`, `nixpacks`, `heroku`).
4. **Missing Dependencies**: Required packages for the chosen adapter are not installed.
   - **Fix**: Ensure `@sveltejs/adapter-node` is in `devDependencies`.
5. **Missing Environment Variables**: Application requires env vars that are not configured.
   - **Fix**: Use `/api/application.saveEnvironment` to configure required variables.

### Node.js Version Issues with Nixpacks

**Symptom**: Build fails with "Node.js 18.x has reached End-Of-Life and has been removed"

**Cause**: Nixpacks defaults to Node.js 18.x which has been removed from Nixpkgs.

**Solution**: Add `engines` field to `package.json`:
```json
{
  "engines": {
    "node": "22"
  }
}
```

**This is CRITICAL** - Nixpacks respects the `engines` field and will use the specified Node.js version.

### Authentication Issues

**Problem**: `dokploy verify` fails

**Solution**:
1. Check if the API token is valid in the Dokploy web interface.
2. Verify the server URL is correct: `http://192.168.1.110:3000/`
3. Re-authenticate: `dokploy authenticate --url URL --token TOKEN`

### API Issues

**Problem**: `401 Unauthorized` with API requests

**Solution**:
1. Use `x-api-key` header, NOT `Authorization: Bearer`
2. Verify the token is correct: Use `$DOKPLOY_API_KEY` environment variable
3. Test authentication: `curl -H "x-api-key: $DOKPLOY_API_KEY" http://192.168.1.110:3000/api/user.get`

## Additional Resources

- Dokploy Documentation: https://docs.dokploy.com
- Dokploy API Reference: https://docs.dokploy.com/docs/api
- SvelteKit Documentation: https://kit.svelte.dev

## Version History

- **1.5.0** - Added CRITICAL section on Publish Directory configuration. This setting tells Dokploy where to find the built application and is essential for deployment success.
- **1.4.0** - Added critical lesson about `engines` field in package.json for Nixpacks. This is essential to force Node.js version and avoid EOL errors.
- **1.3.0** - Removed incorrect Dockerfile example (was invalid for SvelteKit adapter-node). Added application.saveGithubProvider endpoint documentation.
- **1.2.0** - Updated API endpoints from OpenAPI documentation, fixed authentication header (x-api-key), removed hardcoded tokens.
- **1.1.0** - Added API workflows, troubleshooting for instant errors, and SvelteKit specific configuration.
- **1.0.0** - Initial release.
