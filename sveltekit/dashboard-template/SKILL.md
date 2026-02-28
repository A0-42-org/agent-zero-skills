---
name: dashboard-template
description: Admin dashboard template with sidebar, charts, tables, and authentication for SvelteKit.
version: 1.0.0
author: Agent Zero Team
tags:
  - dashboard
  - admin
  - template
  - ui
  - charts
trigger_patterns:
  - dashboard template
  - admin dashboard
  - dashboard starter
  - admin panel
---

# Dashboard Template (GNU Meta-Skill)

Generic dashboard template for SvelteKit + SkeletonUI v4 with drag-and-drop functionality and svelteForge theme switching. This meta-skill follows GNU philosophy: do ONE thing perfectly, don't overcomplicate.

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


## Use Case

Use this meta-skill when:
- Creating a generic dashboard for any website
- Building an admin dashboard with sidebar navigation
- Implementing a dashboard with metric cards, data tables, and drag-and-drop
- Creating a dashboard with theme switching (svelteForge, light, dark, neutral)
- Building a responsive dashboard for SaaS applications

## GNU Philosophy: Do ONE Thing Perfectly

This meta-skill does ONE thing perfectly: **create a generic dashboard with base + drag-and-drop**.

**What's included (BASE):**
- ✅ Layout with sidebar and header
- ✅ Theme switching (svelteForge, light, dark, neutral)
- ✅ Metric Cards (KPIs)
- ✅ Data Table (sortable, with status columns)
- ✅ Drag-and-Drop (reorder widgets)

**Optional skills (called ONLY if needed):**
- 📊 `charts/` - If you need charts (Line, Bar, Pie)
- 🔐 `auth/` - If you need authentication (BetterAuth)
- 📈 `analytics/` - If you need analytics tracking
- 👥 `user-management/` - If you need CRUD for users

## Prerequisites

- **SvelteKit** - Web framework
- **SkeletonUI v4** - UI component library
- **Tailwind CSS v4** - Styling
- **Svelte 5 Runes** - Modern Svelte syntax
- **bun** - Package manager
- **svelte-dnd-action** - Drag-and-drop library

## Installation

### Step 1: Initialize SvelteKit Project

```bash
# Create new SvelteKit project with all required tools
npx sv create --types ts --install bun --template minimal --add eslint prettier tailwind="plugins:typography,forms" mcp="ide:opencode" devtools-json my-dashboard

cd my-dashboard

# Install dependencies
bun install

# Install svelte-dnd-action for drag-and-drop
bun add svelte-dnd-action
```

### Step 2: Configure Theme System (svelteForge)

Copy `app.css` from templates/css/app.css to `src/app.css`. This file includes:
- svelteForge theme with oklch color space
- Custom font classes: `.subtitle`, `.title`, `.font-code`
- Light, dark, neutral, and svelteForge themes
- CSS variables for typography, spacing, borders

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/css/app.css src/app.css
```

### Step 3: Create Theme Provider

Copy from `templates/layout/ThemeProvider.svelte`:

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/layout/ThemeProvider.svelte src/lib/components/
```

### Step 4: Create Dashboard Layout Component

Copy from `templates/layout/DashboardLayout.svelte`:

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/layout/DashboardLayout.svelte src/lib/components/
```

### Step 5: Create Theme Toggle Component

Copy from `templates/components/ThemeToggle.svelte`:

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/components/ThemeToggle.svelte src/lib/components/
```

### Step 6: Create Metric Card Component

Copy from `templates/components/MetricCard.svelte`:

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/components/MetricCard.svelte src/lib/components/
```

### Step 7: Create Data Table Component

Copy from `templates/components/DataTable.svelte`:

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/components/DataTable.svelte src/lib/components/
```

### Step 8: Create Drag-and-Drop Dashboard Component

Copy from `templates/dnd/DnDDashboard.svelte`:

```bash
cp /a0/usr/skills/sveltekit/dashboard-template/templates/dnd/DnDDashboard.svelte src/lib/components/
```

### Step 9: Create Dashboard Page

Create `src/routes/dashboard/+page.svelte`:

```svelte
<script lang="ts">
  import DashboardLayout from '$lib/components/DashboardLayout.svelte';
  import MetricCard from '$lib/components/MetricCard.svelte';
  import DataTable from '$lib/components/DataTable.svelte';
  import DnDDashboard from '$lib/components/DnDDashboard.svelte';

  const metrics = [
    { title: 'Total Revenue', value: '$45,231.89', trend: '+20.1%', positive: true },
    { title: 'New Customers', value: '+2,350', trend: '+180.1%', positive: true },
    { title: 'Active Accounts', value: '+573', trend: '+201', positive: true },
    { title: 'Growth Rate', value: '+19%', trend: '+4%', positive: true },
  ];

  const recentActivities = [
    { id: 1, name: 'Liam Johnson', email: 'liam@example.com', status: 'Active' },
    { id: 2, name: 'Olivia Smith', email: 'olivia@example.com', status: 'Pending' },
    { id: 3, name: 'Emma Williams', email: 'emma@example.com', status: 'Active' },
    { id: 4, name: 'Noah Brown', email: 'noah@example.com', status: 'Inactive' },
    { id: 5, name: 'Sophia Jones', email: 'sophia@example.com', status: 'Active' },
  ];
</script>

<DashboardLayout title="My Dashboard">
  <!-- Metric Cards -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
    {#each metrics as metric}
      <MetricCard 
        title={metric.title}
        value={metric.value}
        trend={metric.trend}
        positive={metric.positive}
      />
    {/each}
  </div>

  <!-- Drag-and-Drop Dashboard -->
  <DnDDashboard title="Widgets" />

  <!-- Data Table -->
  <div class="bg-white dark:bg-surface-900 rounded-lg shadow-sm border border-surface-200 dark:border-surface-800">
    <div class="px-6 py-4 border-b border-surface-200 dark:border-surface-800">
      <h2 class="text-lg font-semibold">Recent Activities</h2>
    </div>
    <DataTable data={recentActivities} />
  </div>
</DashboardLayout>
```

### Step 10: Update Root Layout

Update `src/routes/+layout.svelte`:

```svelte
<script lang="ts">
  import ThemeProvider from '$lib/components/ThemeProvider.svelte';
  import './app.css';
</script>

<svelte:head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="icon" href="%sveltekit.assets%/favicon.png" />
</svelte:head>

<ThemeProvider>
  <slot />
</ThemeProvider>
```

## Optional Skills

### 📊 Charts (Optional)

If you need charts, use `charts/` templates:

```bash
# Copy chart templates
cp /a0/usr/skills/sveltekit/dashboard-template/templates/charts/*.svelte src/lib/components/
```

See `templates/charts/README.md` for usage instructions.

### 🔐 Authentication (Optional)

If you need authentication, use `auth/` templates:

```bash
# Install BetterAuth
bun add better-auth

# Copy auth templates
cp /a0/usr/skills/sveltekit/dashboard-template/templates/auth/*.svelte src/lib/components/
```

See `templates/auth/README.md` for usage instructions.

### 📈 Analytics (Optional)

If you need analytics tracking, use `analytics/` templates:

```bash
# Copy analytics templates
cp /a0/usr/skills/sveltekit/dashboard-template/templates/analytics/*.ts src/lib/
```

See `templates/analytics/README.md` for usage instructions.

### 👥 User Management (Optional)

If you need user management, use `user-management/` templates:

```bash
# Install Drizzle ORM
bun add drizzle-orm better-sqlite3
bun add -D drizzle-kit

# Copy user management templates
cp /a0/usr/skills/sveltekit/dashboard-template/templates/user-management/*.svelte src/lib/components/
cp /a0/usr/skills/sveltekit/dashboard-template/templates/user-management/*.ts src/lib/
```

See `templates/user-management/README.md` for usage instructions.

## Templates Structure

```
📁 sveltekit/dashboard-template/
├── SKILL.md                    # This file
└── templates/
    ├── layout/                  # Layout components (BASE)
    │   ├── DashboardLayout.svelte
    │   ├── ThemeProvider.svelte
    │   └── ThemeToggle.svelte
    ├── components/              # Reusable components (BASE)
    │   ├── MetricCard.svelte
    │   └── DataTable.svelte
    ├── dnd/                     # Drag-and-Drop (BASE)
    │   └── DnDDashboard.svelte
    ├── css/                     # CSS (BASE)
    │   └── app.css (svelteForge theme)
    ├── charts/                  # Charts (OPTIONAL)
    │   ├── LineChart.svelte
    │   ├── BarChart.svelte
    │   ├── PieChart.svelte
    │   └── README.md
    ├── auth/                    # Authentication (OPTIONAL)
    │   ├── AuthProvider.svelte
    │   ├── ProtectedRoute.svelte
    │   └── README.md
    ├── analytics/               # Analytics (OPTIONAL)
    │   ├── tracking.ts
    │   └── README.md
    └── user-management/         # User Management (OPTIONAL)
        ├── UserList.svelte
        ├── UserForm.svelte
        └── README.md
```

## Customization

### Custom Themes

To create a custom theme, add CSS variables to `src/app.css`:

```css
[data-theme="custom"] {
  --color-primary-500: #your-color;
  --color-surface-50: #your-color;
  /* ... */
}
```

Then update the theme provider:

```svelte
type Theme = 'light' | 'dark' | 'neutral' | 'svelteForge' | 'custom';
```

### Custom Metric Cards

Modify `templates/components/MetricCard.svelte` to add more metrics:

```svelte
interface Props {
  title: string;
  value: string;
  trend: string;
  positive: boolean;
  icon?: string;  // Add icon
  description?: string;  // Add description
}
```

### Custom Data Table

Add sorting, filtering, and pagination to `templates/components/DataTable.svelte`:

```svelte
<script>
  let sortColumn = $state('name');
  let sortDirection = $state<'asc' | 'desc'>('asc');
  let filter = $state('');

  const filteredData = $derived(
    data.filter(item => 
      item.name.toLowerCase().includes(filter.toLowerCase())
    )
  );

  const sortedData = $derived(
    [...filteredData].sort((a, b) => {
      const aVal = a[sortColumn];
      const bVal = b[sortColumn];
      return sortDirection === 'asc' 
        ? aVal.localeCompare(bVal) 
        : bVal.localeCompare(aVal);
    })
  );
</script>
```

## Features

### Responsive Design

- Mobile-friendly sidebar (collapsible on small screens)
- Responsive grid layout for metric cards
- Adaptable data table for all screen sizes

### Theme Switching

- svelteForge theme (default, with custom oklch colors)
- Light/Dark/Neutral themes
- Custom theme support
- System preference detection
- Local storage persistence

### Drag-and-Drop

- Reorder widgets with drag-and-drop
- Persist widget positions
- Smooth animations
- Touch-friendly on mobile

### Accessible

- ARIA labels for screen readers
- Keyboard navigation support
- High contrast mode support
- Focus indicators

## Common Issues

### Theme not switching

Make sure to wrap your app with `ThemeProvider`:

```svelte
<ThemeProvider>
  <slot />
</ThemeProvider>
```

### Sidebar not showing

Ensure `AppShell` is properly configured:

```svelte
<AppShell>
  <AppSidebar>...</AppSidebar>
  <main>...</main>
</AppShell>
```

### Drag-and-Drop not working

Make sure `svelte-dnd-action` is installed:

```bash
bun add svelte-dnd-action
```

And the component uses the action:

```svelte
<div use:dndzone={{ items: widgets }} on:finalize={handleFinalize}>
  {#each widgets as widget}
    <div data-id={widget.id}>{widget.title}</div>
  {/each}
</div>
```

## Next Steps

After implementing this template:

1. **Add Charts** - Use `templates/charts/` if you need data visualization
2. **Add Authentication** - Use `templates/auth/` if you need user authentication
3. **Add Analytics** - Use `templates/analytics/` if you need analytics tracking
4. **Add User Management** - Use `templates/user-management/` if you need CRUD for users
5. **Add Real-time Updates** - Use WebSockets for live data
6. **Customize svelteForge Theme** - Customize svelteForge theme with your brand colors

---
**Use this meta-skill to create beautiful, responsive dashboards with drag-and-drop for any SvelteKit + SkeletonUI project.**

**Version**: 1.0.0  
**Tags**: sveltekit, dashboard, template, skeletonui, svelteforge, theming, responsive, dnd, drag-and-drop  
**Triggers**: create dashboard, dashboard template, generic dashboard, theme dashboard, admin template, svelteforge dashboard, gnu dashboard
