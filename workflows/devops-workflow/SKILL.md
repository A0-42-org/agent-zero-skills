# DevOps Workflow

Complete workflow for deploying applications using Dokploy, OpenCode integration, and GitHub CLI automation.

## Use Case

Use this workflow when:
- Deploying a SvelteKit application to production
- Setting up CI/CD pipeline for automated deployment
- Configuring GitHub Actions for continuous deployment
- Managing deployment environments (staging, production)
- Automating DevOps tasks with GitHub CLI

## Workflow Overview

This workflow guides you through deploying applications in 6 steps:

1. **Project Preparation** - Prepare application for deployment
2. **GitHub Repository Setup** - Configure repository and CI/CD
3. **Dokploy Configuration** - Set up Dokploy for deployment
4. **Application Deployment** - Deploy application to production
5. **Monitoring & Maintenance** - Set up monitoring and maintenance
6. **Automation** - Automate DevOps tasks with GitHub CLI

## Prerequisites Skills

This workflow calls these skills conditionally based on your needs:
- `devops/dokploy` - Dokploy deployment platform (ALWAYS)
- `devops/opencode` - OpenCode integration (OPTIONAL)
- `devops/gh-cli` - GitHub CLI automation (OPTIONAL)

## Step-by-Step Guide

### Step 1: Project Preparation

#### 1.1 Build Configuration

Ensure your project has proper build configuration:

**For SvelteKit projects**:

```bash
# Update package.json
{
  "scripts": {
    "build": "vite build",
    "preview": "vite preview"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

#### 1.2 Environment Variables

Create `.env.production`:

```env
# App
APP_URL=https://yourapp.com

# Database
DATABASE_URL=postgresql://user:password@host:5432/dbname

# Auth
BETTER_AUTH_SECRET=your-secret-here
BETTER_AUTH_URL=https://yourapp.com

# API Keys
API_KEY=your-api-key
```

### Step 2: GitHub Repository Setup

#### 2.1 Initialize Repository

```bash
# Initialize Git repository
git init
git add .
git commit -m "Initial commit"

# Create GitHub repository
gh repo create your-app-name --public --source=. --push
```

#### 2.2 Configure GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'pnpm'
      
      - name: Install pnpm
        uses: pnpm/action-setup@v2
      
      - name: Install dependencies
        run: pnpm install --frozen-lockfile
      
      - name: Build application
        run: pnpm build
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          BETTER_AUTH_SECRET: ${{ secrets.BETTER_AUTH_SECRET }}
      
      - name: Deploy to Dokploy
        uses: dokploy/dokploy-action@v1
        with:
          url: https://your-dokploy-instance.com
          token: ${{ secrets.DOKPLOY_TOKEN }}
          project: your-project-name
          application: your-app-name
          build-path: ./build
```

#### 2.3 Set Up Secrets

```bash
# Add GitHub secrets
gh secret set DATABASE_URL
gh secret set BETTER_AUTH_SECRET
gh secret set DOKPLOY_TOKEN
```

### Step 3: Dokploy Configuration

#### 3.1 Connect Dokploy

1. Log in to your Dokploy instance
2. Add your GitHub repository
3. Configure project settings

#### 3.2 Create Application

```bash
# Using Dokploy API
# Or through the web UI
```

#### 3.3 Configure Build Settings

```json
{
  "buildCommand": "pnpm build",
  "outputDirectory": "build",
  "installCommand": "pnpm install",
  "nodeVersion": "18"
}
```

#### 3.4 Set Environment Variables

```bash
# Add environment variables in Dokploy
DATABASE_URL=postgresql://user:password@host:5432/dbname
BETTER_AUTH_SECRET=your-secret-here
BETTER_AUTH_URL=https://yourapp.com
```

### Step 4: Application Deployment

#### 4.1 Trigger Deployment

```bash
# Push to main branch to trigger deployment
git add .
git commit -m "Update production"
git push origin main
```

#### 4.2 Monitor Deployment

```bash
# Check deployment status
gh run list

# View deployment logs
gh run view --log
```

### Step 5: Monitoring & Maintenance

#### 5.1 Set Up Monitoring

```bash
# Add monitoring tools
pnpm add @sentry/node
pnpm add -D @sentry/vite-plugin
```

#### 5.2 Configure Sentry

Create `sentry.client.config.ts`:

```typescript
import * as Sentry from "@sentry/svelte";

Sentry.init({
  dsn: "your-dsn",
  tracesSampleRate: 1.0,
});
```

#### 5.3 Set Up Logs

```bash
# Add logging
pnpm add pino
```

### Step 6: Automation

#### 6.1 Automate GitHub Tasks

```bash
# Create labels
gh label create bug --color "d73a4a" --description "Something isn't working"
gh label create enhancement --color "a2eeef" --description "New feature or request"
gh label create documentation --color "0075ca" --description "Improvements or additions to documentation"
```

#### 6.2 Automate Issue Creation

```bash
# Create issue template
gh issue create --title "Task: [Feature Name]" --body "Task description"
```

#### 6.3 Automate PR Management

```bash
# Create pull request
gh pr create --title "Add [Feature]" --body "Description" --base main --head feature-branch
```

## Workflow Checklist

### Step 1: Project Preparation
- [ ] Build configuration updated
- [ ] Environment variables defined
- [ ] Dependencies verified

### Step 2: GitHub Repository Setup
- [ ] Git repository initialized
- [ ] GitHub repository created
- [ ] GitHub Actions workflow configured
- [ ] GitHub secrets set up

### Step 3: Dokploy Configuration
- [ ] Dokploy instance connected
- [ ] Application created
- [ ] Build settings configured
- [ ] Environment variables set up

### Step 4: Application Deployment
- [ ] Deployment triggered
- [ ] Deployment monitored
- [ ] Deployment successful

### Step 5: Monitoring & Maintenance
- [ ] Monitoring set up
- [ ] Logging configured
- [ ] Alerts configured

### Step 6: Automation
- [ ] GitHub labels created
- [ ] Issue templates set up
- [ ] PR workflows automated

## Common Pitfalls

### 1. Not Setting GitHub Secrets
```bash
# ❌ BAD - Using hardcoded secrets
DATABASE_URL=postgresql://user:password@host:5432/dbname

# ✅ GOOD - Using GitHub secrets
DATABASE_URL=${{ secrets.DATABASE_URL }}
```

### 2. Not Using PNPM
```yaml
# ❌ BAD - Using npm
- name: Install dependencies
  run: npm install

# ✅ GOOD - Using pnpm
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '18'
    cache: 'pnpm'

- name: Install pnpm
  uses: pnpm/action-setup@v2

- name: Install dependencies
  run: pnpm install --frozen-lockfile
```

### 3. Not Specifying Node Version
```json
// ❌ BAD - Not specifying Node version
{
  "scripts": {
    "build": "vite build"
  }
}

// ✅ GOOD - Specifying Node version
{
  "scripts": {
    "build": "vite build"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

### 4. Not Using GitHub CLI
```bash
# ❌ BAD - Not automating
# Manually creating repository, labels, issues

# ✅ GOOD - Using gh CLI
gh repo create my-app --public --source=. --push
gh label create bug --color "d73a4a"
gh issue create --title "Bug: ..." --body "Description"
```

### 5. Not Setting Up Monitoring
```typescript
// ❌ BAD - No monitoring
// No error tracking or logging

// ✅ GOOD - Setting up monitoring
import * as Sentry from "@sentry/svelte";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 1.0,
});
```

## Next Steps

After completing this workflow, you can:

1. **Set Up Multiple Environments** - Configure staging and production environments
2. **Add More Automation** - Automate more DevOps tasks with gh-cli
3. **Set Up Backups** - Configure database backups
4. **Add SSL** - Configure SSL certificates
5. **Scale Application** - Configure load balancing

---
**Use this workflow to deploy and automate your applications using Dokploy, OpenCode, and GitHub CLI.**
