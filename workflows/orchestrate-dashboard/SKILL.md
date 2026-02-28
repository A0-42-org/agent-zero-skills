---
name: orchestrate-dashboard
description: Project orchestration dashboard for managing multiple Agent Zero tasks and workflows.
version: 1.0.0
author: Agent Zero Team
tags:
  - orchestration
  - dashboard
  - tasks
  - management
  - workflow
trigger_patterns:
  - orchestrate dashboard
  - task dashboard
  - workflow dashboard
  - agent orchestration
---

# Orchestrate Dashboard - Workflow

Créer un dashboard admin complet en utilisant des compétences atomiques.

## Prerequisites

### Package Manager: Bun

This skill uses **Bun** as the package manager. Before running any commands, verify that bun is installed:

```bash
bun --version
```

#### Failsafe: Installing Bun

If bun is not installed, run the initialization script:

```bash
bash /a0/usr/init-tools.sh
```

This script will automatically install:
- Bun (JavaScript package manager)
- GitHub CLI (gh)

### Why Bun?

- **Fast**: Bun is fast
- **Compatible**: Works with all npm packages
- **Standard**: All Agent Zero skills use bun

### Common Bun Commands

| Command | Description |
|---------|-------------|
| `bun install` | Install dependencies |
| `bun add <package>` | Add dependency |
| `bun add -D <package>` | Add dev dependency |
| `bun run <script>` | Run npm script |
| `bunx <package>` | Execute npm package directly |
| `bun create <template>` | Create new project |
| `bun dev` | Start dev server |
| `bun build` | Build project |
| `bun test` | Run tests |

---


## Prerequisites

This workflow requires the following skills:

**→ [sveltekit/skeleton-ui](sveltekit/skeleton-ui/SKILL.md) - Configuration base**
**→ [sveltekit/superforms](sveltekit/superforms/SKILL.md) - Formulaires**
**→ [sveltekit/dashboard-template](sveltekit/dashboard-template/SKILL.md) - Composants dashboard**
**→ [sveltekit/analytics](sveltekit/analytics/SKILL.md) - Analytics (optionnel)**

## Workflow

### Step 1: Initialize SvelteKit Project

**→ Follow the `sveltekit/bootstrap` skill** to initialize a new SvelteKit project.

```bash
bun create svelte@latest my-dashboard
# Select: TypeScript, Skeleton UI, Tailwind CSS
```

### Step 2: Configure Skeleton UI

**→ Follow the `skeleton-ui` skill** to configure the base environment.

This includes:
- Skeleton UI installation
- Tailwind CSS v4 configuration
- Base themes setup

### Step 3: Add Superforms

**→ Follow the `superforms` skill** to enable forms for login/signup.

This provides:
- Server-side validation with Zod
- Client-side validation
- Form handling

### Step 4: Add Dashboard Components

**→ Follow the `dashboard-template` skill** to add reusable dashboard components.

This includes:
- **Base Features** (Always Included):
  - DashboardLayout - Main layout with sidebar/header
  - ThemeProvider - Theme management (light/dark/neutral)
  - ThemeToggle - Toggle theme button
  - MetricCard - KPI display component
  - DataTable - Data table with pagination
  - DnDDashboard - Drag-and-drop dashboard

- **Optional Features** (Called When Needed):
  - Charts - LineChart, BarChart, PieChart
  - Auth - Login, Signup forms
  - Analytics - Analytics components
  - User-Management - User table, profile

### Step 5: Add Analytics (Optional)

**→ Follow the `analytics` skill** to add analytics to the dashboard.

### Step 6: Add Theming (Optional)

**→ Follow the `theming` skill** to customize the dashboard theme.

## Result

You now have a complete admin dashboard with:
- ✅ SvelteKit + Skeleton UI configured
- ✅ Login/Signup forms
- ✅ Reusable dashboard components (Layout, MetricCard, DataTable, DnDDashboard)
- ✅ Optional analytics
- ✅ Optional custom theming

## Next Steps

- Customize the dashboard layout
- Add your own components
- Integrate with your backend
- Deploy your dashboard
