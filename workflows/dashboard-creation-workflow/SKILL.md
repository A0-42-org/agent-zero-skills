---
name: "dashboard-creation-workflow"
description: "Multi-step workflow for creating a complete dashboard with drag-and-drop widgets, analytics, theming, and SvelteKit. Combines sveltekit-dnd-dashboard, sveltekit-analytics, sveltekit-theming, and sveltekit-bootstrap skills."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["sveltekit", "dashboard", "workflow", "multi-step", "dnd", "analytics", "theming"]
trigger_patterns:
  - "create dashboard"
  - "dashboard workflow"
  - "build dashboard"
  - "multi-step dashboard"
  - "admin dashboard"
  - "analytics dashboard"
---

# Dashboard Creation Workflow

Complete multi-step workflow for creating a functional dashboard with drag-and-drop widgets, analytics, theming, and SvelteKit integration.

## Use Case

Use this workflow when:
- Creating an admin dashboard for a SaaS application
- Building an analytics dashboard with charts and stats
- Implementing a user dashboard with customizable widgets
- Creating a management dashboard with sortable components
- Building any dashboard requiring drag-and-drop functionality

## Workflow Overview

This workflow guides you through creating a complete dashboard in 6 steps:

1. **Project Initialization** - Set up SvelteKit project with dependencies
2. **Database Schema** - Define database structure with Drizzle ORM
3. **Dashboard Layout** - Create responsive layout with sidebar
4. **Widget Components** - Build reusable widget components
5. **Drag-and-Drop** - Implement sortable widgets with svelte-dnd-action
6. **Analytics Integration** - Add analytics tracking and visualizations
7. **Theming** - Apply theme system with Skeleton UI

## Prerequisites Skills

Before using this workflow, ensure you have these skills:
- `sveltekit-bootstrap` - Project initialization
- `sveltekit-database` - Drizzle ORM setup
- `sveltekit-dnd-dashboard` - Drag-and-drop dashboard patterns
- `sveltekit-analytics` - Analytics tracking and dashboards
- `sveltekit-theming` - Theme management
- `sveltekit-components` - Reusable component patterns

## Step-by-Step Guide

### Step 1: Project Initialization

#### 1.1 Initialize SvelteKit Project

```bash
# Create new SvelteKit project with all required tools
npx sv create --types ts --install pnpm --template minimal --add eslint prettier tailwind="plugins:typography,forms" mcp="ide:opencode" devtools-json my-dashboard

cd my-dashboard

# Install required packages
pnpm add drizzle-orm better-auth zod svelte-dnd-action
pnpm add -D drizzle-kit

# Install database driver (choose one)
pnpm add postgres  # For PostgreSQL
# OR
pnpm add better-sqlite3  # For SQLite
```

#### 1.2 Configure Skeleton UI

Update `tailwind.config.js`:

```javascript
import { skeleton } from '@skeletonlabs/tailwindcss-plugin';

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {},
  },
  plugins: [
    skeleton({ themes: ['modern'] })
  ],
};
```

Create `src/routes/layout.css`:

```css
/* Tailwind CSS v4 - Using @tailwindcss/vite plugin */
@import 'tailwindcss';
/* Note: @skeletonlabs/skeleton CSS imports are not compatible with Tailwind v4 */
/* Use Skeleton components from @skeletonlabs/skeleton-svelte package instead */
```

#### 1.3 Configure Environment Variables

```env
# Database
DATABASE_URL=file:./sqlite.db

# BetterAuth
BETTER_AUTH_SECRET=$(openssl rand -base64 32)
BETTER_AUTH_URL=http://localhost:5173

# App
APP_URL=http://localhost:5173
```

### Step 2: Database Schema

#### 2.1 Define Schema

Create `src/lib/db/schema.ts`:

```typescript
import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('user', {
  id: text('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull().$defaultFn(() => new Date()),
});

export const dashboardWidgets = sqliteTable('dashboard_widgets', {
  id: text('id').primaryKey(),
  userId: text('user_id').notNull().references(() => users.id),
  widgetType: text('widget_type').notNull(),
  position: integer('position').notNull(),
  settings: text('settings', { mode: 'json' }).$type<Record<string, any>>(),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull().$defaultFn(() => new Date()),
  updatedAt: integer('updated_at', { mode: 'timestamp' }).notNull().$defaultFn(() => new Date()),
});

export const analyticsEvents = sqliteTable('analytics_events', {
  id: text('id').primaryKey(),
  userId: text('user_id').notNull().references(() => users.id),
  eventType: text('event_type').notNull(),
  eventData: text('event_data', { mode: 'json' }).$type<Record<string, any>>(),
  timestamp: integer('timestamp', { mode: 'timestamp' }).notNull().$defaultFn(() => new Date()),
});
```

#### 2.2 Generate Database

```bash
# Generate migration
pnpm dlx drizzle-kit generate

# Apply migration
pnpm dlx drizzle-kit migrate
```

### Step 3: Dashboard Layout

#### 3.1 Create Dashboard Layout Component

Create `src/lib/components/DashboardLayout.svelte`:

```svelte
<script lang="ts">
  import type { Snippet } from 'svelte';
  import { page } from '$app/stores';
  import { AppShell, AppSidebar, AppSidebarHeader, AppSidebarBody, AppSidebarNav } from '@skeletonlabs/skeleton-svelte';

  interface Props {
    title: string;
    children: Snippet;
  }

  let { title, children }: Props = $props();

  const navItems = [
    { label: 'Dashboard', href: '/dashboard' },
    { label: 'Analytics', href: '/dashboard/analytics' },
    { label: 'Settings', href: '/dashboard/settings' },
  ];
</script>

<AppShell>
  <AppSidebar>
    <AppSidebarHeader>
      <h2>{title}</h2>
    </AppSidebarHeader>
    <AppSidebarBody>
      <AppSidebarNav>
        {#each navItems as item}
          <a href={item.href} class:active={$page.url.pathname === item.href}>
            {item.label}
          </a>
        {/each}
      </AppSidebarNav>
    </AppSidebarBody>
  </AppSidebar>
  <main>
    {@render children()}
  </main>
</AppShell>
```

### Step 4: Widget Components

#### 4.1 Create Widget Base Component

Create `src/lib/components/widgets/WidgetBase.svelte`:

```svelte
<script lang="ts">
  import type { Snippet } from 'svelte';
  // Note: AppCard replaced with HTML + Tailwind CSS

  interface Props {
    title: string;
    children: Snippet;
    onRemove?: () => void;
    onEdit?: () => void;
  }

  let { title, children, onRemove, onEdit }: Props = $props();
</script>

<div class="border rounded-lg shadow">
  <div class="widget-header p-4 border-b">
    <h3>{title}</h3>
    <div class="widget-actions">
      {#if onEdit}
        <button class="hover:bg-gray-100 text-gray-700 px-3 py-1.5 rounded text-sm" onclick={onEdit}>
          Edit
        </button>
      {/if}
      {#if onRemove}
        <button class="hover:bg-gray-100 text-gray-700 px-3 py-1.5 rounded text-sm" onclick={onRemove}>
          Remove
        </button>
      {/if}
    </div>
  </div>
  <div class="widget-content p-4">
    {@render children()}
  </div>
</div>

<style>
  .widget-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .widget-actions {
    display: flex;
    gap: 0.5rem;
  }
</style>
```

#### 4.2 Create Stat Widget

Create `src/lib/components/widgets/StatWidget.svelte`:

```svelte
<script lang="ts">
  import WidgetBase from './WidgetBase.svelte';
  import { AppProgressRadial } from '@skeletonlabs/skeleton-svelte';

  interface Props {
    title: string;
    value: number;
    label: string;
    trend?: number;
    onRemove?: () => void;
    onEdit?: () => void;
  }

  let { title, value, label, trend, onRemove, onEdit }: Props = $props();
  
  const trendColor = $derived(trend && trend > 0 ? 'text-green-500' : trend && trend < 0 ? 'text-red-500' : 'text-gray-500');
</script>

<WidgetBase {title} {onRemove} {onEdit}>
  <div class="stat-widget">
    <AppProgressRadial value={value} max={100}>
      <div class="stat-value">{value}%</div>
    </AppProgressRadial>
    <div class="stat-info">
      <p class="stat-label">{label}</p>
      {#if trend !== undefined}
        <p class="stat-trend {trendColor}">
          {trend > 0 ? '+' : ''}{trend}% from last month
        </p>
      {/if}
    </div>
  </div>
</WidgetBase>

<style>
  .stat-widget {
    display: flex;
    align-items: center;
    gap: 1rem;
  }
  .stat-value {
    font-size: 1.5rem;
    font-weight: 600;
  }
  .stat-label {
    font-size: 0.875rem;
    color: var(--color-surface-500);
  }
  .stat-trend {
    font-size: 0.875rem;
  }
</style>
```

#### 4.3 Create Chart Widget

Create `src/lib/components/widgets/ChartWidget.svelte`:

```svelte
<script lang="ts">
  import WidgetBase from './WidgetBase.svelte';

  interface ChartData {
    label: string;
    value: number;
  }

  interface Props {
    title: string;
    data: ChartData[];
    onRemove?: () => void;
    onEdit?: () => void;
  }

  let { title, data, onRemove, onEdit }: Props = $props();
  
  const maxValue = $derived(Math.max(...data.map(d => d.value)));
</script>

<WidgetBase {title} {onRemove} {onEdit}>
  <div class="chart-widget">
    {#each data as item}
      <div class="chart-bar">
        <div class="chart-bar-label">{item.label}</div>
        <div class="chart-bar-value" style="width: {(item.value / maxValue) * 100}%">
          {item.value}
        </div>
      </div>
    {/each}
  </div>
</WidgetBase>

<style>
  .chart-widget {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  .chart-bar {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  .chart-bar-label {
    width: 100px;
    font-size: 0.875rem;
  }
  .chart-bar-value {
    flex: 1;
    background-color: var(--color-primary-500);
    border-radius: 4px;
    padding: 0.25rem 0.5rem;
    color: white;
    font-size: 0.875rem;
  }
</style>
```

#### 4.4 Create List Widget

Create `src/lib/components/widgets/ListWidget.svelte`:

```svelte
<script lang="ts">
  import WidgetBase from './WidgetBase.svelte';

  interface ListItem {
    id: string;
    title: string;
    subtitle?: string;
  }

  interface Props {
    title: string;
    items: ListItem[];
    onRemove?: () => void;
    onEdit?: () => void;
  }

  let { title, items, onRemove, onEdit }: Props = $props();
</script>

<WidgetBase {title} {onRemove} {onEdit}>
  <div class="list-widget">
    {#each items as item}
      <div class="list-item">
        <div class="list-item-content">
          <p class="list-item-title">{item.title}</p>
          {#if item.subtitle}
            <p class="list-item-subtitle">{item.subtitle}</p>
          {/if}
        </div>
      </div>
    {/each}
  </div>
</WidgetBase>

<style>
  .list-widget {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  .list-item {
    padding: 0.5rem;
    border-radius: 4px;
    background-color: var(--color-surface-100);
  }
  .list-item-title {
    font-weight: 500;
  }
  .list-item-subtitle {
    font-size: 0.875rem;
    color: var(--color-surface-500);
  }
</style>
```

### Step 5: Drag-and-Drop Implementation

#### 5.1 Create Dashboard Page with Drag-and-Drop

Create `src/routes/dashboard/+page.svelte`:

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  import { dndzone } from 'svelte-dnd-action';
  import WidgetBase from '$lib/components/widgets/WidgetBase.svelte';
  import StatWidget from '$lib/components/widgets/StatWidget.svelte';
  import ChartWidget from '$lib/components/widgets/ChartWidget.svelte';
  import ListWidget from '$lib/components/widgets/ListWidget.svelte';
  // Note: AppButton and AppAlert replaced with HTML + Tailwind CSS
  import type { PageServerData, ActionData } from './$types';

  interface Widget {
    id: string;
    type: string;
    position: number;
    data: any;
  }

  let { data, form }: { data: PageServerData; form?: ActionData } = $props();
  
  let widgets = $state<Widget[]>(data.widgets || []);
  let isSaving = $state(false);
  
  const widgetComponents: Record<string, any> = {
    stat: StatWidget,
    chart: ChartWidget,
    list: ListWidget,
  };
  
  function handleDrop(e: any) {
    const { items } = e.detail;
    widgets = items.map((item: Widget, index: number) => ({
      ...item,
      position: index,
    }));
    
    // Auto-save positions
    savePositions();
  }
  
  async function savePositions() {
    isSaving = true;
    try {
      const response = await fetch('/dashboard/save-positions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ widgets: widgets.map(w => ({ id: w.id, position: w.position })) }),
      });
      if (!response.ok) throw new Error('Failed to save positions');
    } catch (error) {
      console.error('Error saving positions:', error);
    } finally {
      isSaving = false;
    }
  }
  
  function removeWidget(widgetId: string) {
    widgets = widgets.filter(w => w.id !== widgetId);
    savePositions();
  }
  
  function editWidget(widgetId: string) {
    // Navigate to edit page or open modal
    console.log('Edit widget:', widgetId);
  }
</script>

<div class="dashboard">
  <div class="dashboard-header">
    <h1>Dashboard</h1>
    <button class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded" onclick={() => window.location.href = '/dashboard/widgets'}>
      Add Widget
    </button>
  </div>
  
  {#if form?.success}
    <AppAlert severity="success" title="Success">
      {form.success}
    </AppAlert>
  {/if}
  
  {#if form?.error}
    <AppAlert severity="error" title="Error">
      {form.error}
    </AppAlert>
  {/if}
  
  <div class="dashboard-grid" use:dndzone={{ items: widgets, dropTargetClass: 'drop-target' }} on:consider={handleDrop} on:finalize={handleDrop}>
    {#each widgets as widget (widget.id)}
      <div class="dashboard-widget" data-id={widget.id}>
        <svelte:component 
          this={widgetComponents[widget.type]}
          title={widget.data.title}
          {...widget.data.props}
          onRemove={() => removeWidget(widget.id)}
          onEdit={() => editWidget(widget.id)}
        />
      </div>
    {/each}
  </div>
  
  {#if isSaving}
    <div class="saving-indicator">Saving...</div>
  {/if}
</div>

<style>
  .dashboard {
    padding: 1.5rem;
  }
  .dashboard-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .dashboard-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1rem;
  }
  .dashboard-widget {
    cursor: move;
  }
  .drop-target {
    opacity: 0.5;
  }
  .saving-indicator {
    position: fixed;
    bottom: 1rem;
    right: 1rem;
    padding: 0.5rem 1rem;
    background-color: var(--color-surface-200);
    border-radius: 4px;
  }
</style>
```

#### 5.2 Create Server Actions

Create `src/routes/dashboard/+page.server.ts`:

```typescript
import { fail } from '@sveltejs/kit';
import { db } from '$lib/db';
import { dashboardWidgets } from '$lib/db/schema';
import { eq, and } from 'drizzle-orm';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
  const userId = locals.user?.id;
  if (!userId) throw redirect(303, '/login');
  
  const widgets = await db.select().from(dashboardWidgets)
    .where(eq(dashboardWidgets.userId, userId))
    .orderBy(dashboardWidgets.position);
  
  return { widgets };
};

export const actions: Actions = {
  savePositions: async ({ request, locals }) => {
    const userId = locals.user?.id;
    if (!userId) return fail(401, { error: 'Unauthorized' });
    
    const data = await request.json();
    const { widgets } = data;
    
    // Update positions
    for (const widget of widgets) {
      await db.update(dashboardWidgets)
        .set({ position: widget.position })
        .where(
          and(
            eq(dashboardWidgets.id, widget.id),
            eq(dashboardWidgets.userId, userId)
          )
        );
    }
    
    return { success: 'Positions saved' };
  },
};
```

### Step 6: Analytics Integration

#### 6.1 Create Analytics Tracking

Create `src/lib/analytics/actions.ts`:

```typescript
import { db } from '$lib/db';
import { analyticsEvents } from '$lib/db/schema';
import { nanoid } from 'nanoid';

type EventType = 'page_view' | 'widget_click' | 'widget_edit' | 'widget_remove' | 'widget_add';

interface EventData {
  page?: string;
  widgetId?: string;
  widgetType?: string;
  [key: string]: any;
}

export async function trackEvent(
  userId: string,
  eventType: EventType,
  eventData: EventData
) {
  await db.insert(analyticsEvents).values({
    id: nanoid(),
    userId,
    eventType,
    eventData,
  });
}

export async function getPageViews(userId: string, days: number = 30) {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const events = await db.select().from(analyticsEvents)
    .where(and(
      eq(analyticsEvents.userId, userId),
      eq(analyticsEvents.eventType, 'page_view'),
      gte(analyticsEvents.timestamp, startDate)
    ));
  
  return events.length;
}

export async function getWidgetStats(userId: string, days: number = 30) {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const events = await db.select().from(analyticsEvents)
    .where(and(
      eq(analyticsEvents.userId, userId),
      gte(analyticsEvents.timestamp, startDate)
    ));
  
  const widgetClicks = events.filter(e => e.eventType === 'widget_click').length;
  const widgetEdits = events.filter(e => e.eventType === 'widget_edit').length;
  const widgetRemoves = events.filter(e => e.eventType === 'widget_remove').length;
  
  return { widgetClicks, widgetEdits, widgetRemoves };
}
```

#### 6.2 Create Analytics Page

Create `src/routes/dashboard/analytics/+page.svelte`:

```svelte
<script lang="ts">
  import WidgetBase from '$lib/components/widgets/WidgetBase.svelte';
  import StatWidget from '$lib/components/widgets/StatWidget.svelte';
  import ChartWidget from '$lib/components/widgets/ChartWidget.svelte';
  import { getPageViews, getWidgetStats } from '$lib/analytics/actions';
  import type { PageServerData } from './$types';

  let { data }: { data: PageServerData } = $props();
  
  const stats = $derived(data.stats);
  const chartData = $derived(data.chartData);
</script>

<div class="analytics">
  <h1>Analytics</h1>
  
  <div class="analytics-grid">
    <StatWidget
      title="Page Views"
      value={stats.pageViews}
      label="Last 30 days"
      trend={stats.pageViewsTrend}
    />
    
    <StatWidget
      title="Widget Clicks"
      value={stats.widgetClicks}
      label="Last 30 days"
      trend={stats.widgetClicksTrend}
    />
    
    <ChartWidget
      title="Page Views Over Time"
      data={chartData}
    />
  </div>
</div>

<style>
  .analytics {
    padding: 1.5rem;
  }
  .analytics-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1rem;
  }
</style>
```

### Step 7: Theming

#### 7.1 Create Theme Provider

Create `src/lib/components/ThemeProvider.svelte`:

```svelte
<script lang="ts">
  import { setContext, onMount } from 'svelte';
  import { browser } from '$app/environment';

  type Theme = 'modern' | 'cerberus' | 'rocket';

  interface ThemeContext {
    theme: Theme;
    setTheme: (theme: Theme) => void;
  }

  const THEMES: Theme[] = ['modern', 'cerberus', 'rocket'];
  
  let theme = $state<Theme>('modern');

  function setTheme(newTheme: Theme) {
    theme = newTheme;
    if (browser) {
      localStorage.setItem('theme', newTheme);
      document.documentElement.setAttribute('data-theme', newTheme);
    }
  }

  onMount(() => {
    if (browser) {
      const savedTheme = localStorage.getItem('theme') as Theme;
      if (savedTheme && THEMES.includes(savedTheme)) {
        setTheme(savedTheme);
      }
    }
  });

  setContext<ThemeContext>('theme', { theme, setTheme });
</script>

<slot />
```

#### 7.2 Create Theme Selector

Create `src/lib/components/ThemeSelector.svelte`:

```svelte
<script lang="ts">
  import { getContext } from 'svelte';
  import type { ThemeContext } from './ThemeProvider.svelte';
  import { AppSelect } from '@skeletonlabs/skeleton-svelte';

  type Theme = 'modern' | 'cerberus' | 'rocket';
  
  const { theme, setTheme } = getContext<ThemeContext>('theme');
  
  const themes = [
    { value: 'modern', label: 'Modern' },
    { value: 'cerberus', label: 'Cerberus' },
    { value: 'rocket', label: 'Rocket' },
  ];
</script>

<div class="theme-selector">
  <AppSelect 
    name="theme" 
    bind:value={theme}
    options={themes}
    label="Theme"
  />
</div>
```

## Dashboard Checklist

Before completing the dashboard:

### Step 1: Project Initialization
- [ ] SvelteKit project created
- [ ] Dependencies installed (Skeleton UI, Drizzle ORM, BetterAuth, svelte-dnd-action)
- [ ] Skeleton UI configured
- [ ] Environment variables set up

### Step 2: Database Schema
- [ ] Database schema defined with Drizzle ORM
- [ ] Migration generated and applied
- [ ] Database connected successfully

### Step 3: Dashboard Layout
- [ ] Dashboard layout component created
- [ ] Sidebar navigation implemented
- [ ] Responsive design working

### Step 4: Widget Components
- [ ] Widget base component created
- [ ] Stat widget component created
- [ ] Chart widget component created
- [ ] List widget component created
- [ ] Widgets are reusable and configurable

### Step 5: Drag-and-Drop
- [ ] Drag-and-drop implemented with svelte-dnd-action
- [ ] Widget reordering works
- [ ] Auto-save positions implemented
- [ ] Server actions for saving positions

### Step 6: Analytics Integration
- [ ] Analytics tracking system set up
- [ ] Events tracked (page views, widget clicks)
- [ ] Analytics page created with stats
- [ ] Chart visualizations working

### Step 7: Theming
- [ ] Theme provider created
- [ ] Theme selector implemented
- [ ] Theme switching works
- [ ] Theme persistence (localStorage)

### Testing
- [ ] All widgets render correctly
- [ ] Drag-and-drop functions smoothly
- [ ] Analytics data is accurate
- [ ] Theme switching works
- [ ] Responsive design on mobile/tablet/desktop
- [ ] Zero TypeScript errors

## Common Pitfalls

### 1. Not Using Skeleton UI Components
```svelte
<!-- ❌ BAD - Custom components without styling -->
<div class="card">
  <h3>Title</h3>
</div>

<!-- ✅ GOOD - HTML + Tailwind CSS (AppCard removed in v4) -->
<div class="border rounded-lg shadow p-4">
  <h3 class="font-medium">Title</h3>
</div>
```

### 2. Not Using svelte-dnd-action Correctly
```svelte
<!-- ❌ BAD - Wrong library -->
<DndContext onDragEnd={handleDragEnd}>
  <SortableContext items={widgets}>
    {#each widgets as widget}
      <SortableWidget widget={widget} />
    {/each}
  </SortableContext>
</DndContext>

<!-- ✅ GOOD - svelte-dnd-action -->
<div use:dndzone={{ items: widgets }} on:finalize={handleFinalize}>
  {#each widgets as widget}
    <div data-id={widget.id}>{widget.title}</div>
  {/each}
</div>
```

### 3. Not Using Svelte 5 Runes
```svelte
<!-- ❌ BAD - Old syntax -->
<script>
  export let title = '';
  let value = 0;
  $: doubled = value * 2;
</script>

<!-- ✅ GOOD - Svelte 5 runes -->
<script lang="ts">
  interface Props {
    title?: string;
    value?: number;
  }
  
  let { title = '', value = 0 }: Props = $props();
  const doubled = $derived(value * 2);
</script>
```

### 4. Not Implementing Auto-Save
```typescript
// ❌ BAD - No auto-save
function handleDrop(e: any) {
  widgets = e.detail.items;
}

// ✅ GOOD - Auto-save on drop
function handleDrop(e: any) {
  widgets = e.detail.items.map((item: Widget, index: number) => ({
    ...item,
    position: index,
  }));
  savePositions();
}
```

### 5. Not Using Server Actions Correctly
```typescript
// ❌ BAD - Wrong load function signature
export const load: PageServerLoad = async ({ url }) => {
  // Missing locals parameter
};

// ✅ GOOD - Correct signature with locals
export const load: PageServerLoad = async ({ locals }) => {
  const userId = locals.user?.id;
  if (!userId) throw redirect(303, '/login');
};
```

## Next Steps

After completing this workflow, you can:

1. **Add More Widgets** - Create custom widget types (calendar, notes, etc.)
2. **Advanced Analytics** - Add more analytics features (funnels, cohorts)
3. **Real-time Updates** - Add WebSocket support for real-time updates
4. **Export Data** - Add functionality to export analytics data
5. **Custom Themes** - Create custom brand themes
6. **Dashboard Templates** - Create pre-configured dashboard templates

---
**Use this workflow to create complete, functional dashboards with drag-and-drop widgets, analytics, and theming in SvelteKit.**
