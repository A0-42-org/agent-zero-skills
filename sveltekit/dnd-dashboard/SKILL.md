---
name: dnd-dashboard
description: Drag and drop dashboard builder with sortable widgets and customizable layout.
version: 1.0.0
author: Agent Zero Team
tags:
  - drag-drop
  - dashboard
  - widgets
  - sortable
  - interactive
trigger_patterns:
  - drag drop dashboard
  - dnd dashboard
  - sortable dashboard
  - widget dashboard
---

# SvelteKit DnD Dashboard

Build sortable, customizable dashboards with drag-and-drop widgets for SvelteKit projects.

## Use Case

Create dashboards where users can:
- Organize widgets by dragging and dropping
- Customize widget content, size, and appearance
- Save widget positions and preferences
- Add/remove widgets dynamically
- Switch between layouts (grid/flex)

Perfect for:
- Admin dashboards
- Analytics dashboards
- User profile dashboards
- Settings pages
- Project management boards

## Installation

```bash
# Core dependency
pnpm add svelte-dnd-action

# Optional: Chart libraries for ChartWidget
pnpm add chart.js svelte-chartjs

# Optional: Icon libraries
pnpm add lucide-svelte
```

## Data Structure

### Widget Interface

```typescript
// Widget type for type checking
type WidgetType = 'stat' | 'chart' | 'list' | 'activity' | 'info';

type WidgetSize = 'small' | 'medium' | 'large' | 'wide';

interface Widget {
  id: string;
  type: WidgetType;
  title: string;
  content: Record<string, any>;
  size: WidgetSize;
  order: number;
  visible: boolean;
  column: number; // For multi-column layout (0, 1, 2...)
  userId: string; // For personalization
  createdAt: string;
  updatedAt: string;
}
```

### Dashboard Interface

```typescript
interface Dashboard {
  id: number;
  userId: string;
  name: string;
  layout: 'grid' | 'flex';
  columns: number; // For flex layout: 2, 3, 4...
  widgets: Widget[];
  createdAt: string;
  updatedAt: string;
}
```

## Database Schema (Drizzle ORM)

```typescript
// src/lib/db/schema.ts
import { pgTable, serial, text, timestamp, boolean, integer, json } from 'drizzle-orm/pg-core';

export const dashboards = pgTable('dashboards', {
  id: serial('id').primaryKey(),
  userId: text('userId')
    .notNull()
    .references(() => user.id, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  layout: text('layout').notNull().default('grid'),
  columns: integer('columns').notNull().default(3),
  createdAt: timestamp('createdAt').notNull().defaultNow(),
  updatedAt: timestamp('updatedAt').notNull().defaultNow(),
});

export const widgets = pgTable('widgets', {
  id: serial('id').primaryKey(),
  dashboardId: integer('dashboardId')
    .notNull()
    .references(() => dashboards.id, { onDelete: 'cascade' }),
  type: text('type').notNull(), // 'stat', 'chart', 'list', 'activity', 'info'
  title: text('title').notNull(),
  content: json('content').notNull().$type<Record<string, any>>(),
  size: text('size').notNull().default('medium'), // 'small', 'medium', 'large', 'wide'
  order: integer('order').notNull(),
  visible: boolean('visible').notNull().default(true),
  column: integer('column').notNull().default(0),
  createdAt: timestamp('createdAt').notNull().defaultNow(),
  updatedAt: timestamp('updatedAt').notNull().defaultNow(),
});
```

## Widget Components

### StatWidget - KPI Cards

```svelte
<!-- src/lib/components/dashboard/StatWidget.svelte -->
<script lang="ts">
  interface Props {
    widget: Widget;
  }
  
  let { widget }: Props = $props();
  
  const { title, value, change, trend } = widget.content;
  const isPositive = trend === 'up';
</script>

<div class="stat-widget p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl">
  <div class="flex items-center justify-between">
    <div>
      <p class="text-white/60 text-sm">{title || 'Metric'}</p>
      <p class="text-3xl font-bold text-white mt-1">{value || '0'}</p>
    </div>
    {#if change}
      <div class="flex items-center {isPositive ? 'text-green-500' : 'text-red-500'}">
        {#if isPositive}
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"></path>
          </svg>
        {:else}
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"></path>
          </svg>
        {/if}
        <span class="ml-1">{change}</span>
      </div>
    {/if}
  </div>
</div>
```

### ChartWidget - Graphiques

```svelte
<!-- src/lib/components/dashboard/ChartWidget.svelte -->
<script lang="ts">
  import { onMount } from 'svelte';
  import { Chart } from 'chart.js/auto';
  import type { Widget } from '$lib/types';
  
  interface Props {
    widget: Widget;
  }
  
  let { widget }: Props = $props();
  let canvasElement: HTMLCanvasElement;
  let chart: Chart;
  
  onMount(() => {
    const { type, data, options } = widget.content;
    chart = new Chart(canvasElement, {
      type: type || 'bar',
      data: data || { labels: [], datasets: [] },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: { color: 'white' }
          }
        },
        scales: {
          y: {
            ticks: { color: 'white/60' },
            grid: { color: 'white/10' }
          },
          x: {
            ticks: { color: 'white/60' },
            grid: { color: 'white/10' }
          }
        },
        ...options
      }
    });
    
    return () => {
      chart.destroy();
    };
  });
</script>

<div class="chart-widget p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl h-80">
  <h3 class="text-white font-bold mb-4">{widget.title}</h3>
  <div class="h-full">
    <canvas bind:this={canvasElement}></canvas>
  </div>
</div>
```

### ListWidget - Listes de Données

```svelte
<!-- src/lib/components/dashboard/ListWidget.svelte -->
<script lang="ts">
  import type { Widget } from '$lib/types';
  
  interface Props {
    widget: Widget;
  }
  
  let { widget }: Props = $props();
  const { items = [] } = widget.content;
</script>

<div class="list-widget p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl">
  <h3 class="text-white font-bold mb-4">{widget.title}</h3>
  <div class="space-y-2">
    {#each items as item}
      <div class="flex items-center justify-between p-3 bg-white/5 rounded-xl">
        <div class="flex items-center gap-3">
          {#if item.icon}
            <span class="text-xl">{item.icon}</span>
          {/if}
          <div>
            <p class="text-white font-medium">{item.title}</p>
            {#if item.description}
              <p class="text-white/60 text-sm">{item.description}</p>
            {/if}
          </div>
        </div>
        {#if item.badge}
          <span class="px-2 py-1 bg-purple-600 text-white text-xs rounded-full">{item.badge}</span>
        {/if}
      </div>
    {/each}
  </div>
</div>
```

### ActivityWidget - Timeline/Feed d'Activité

```svelte
<!-- src/lib/components/dashboard/ActivityWidget.svelte -->
<script lang="ts">
  import type { Widget } from '$lib/types';
  
  interface Props {
    widget: Widget;
  }
  
  let { widget }: Props = $props();
  const { activities = [] } = widget.content;
</script>

<div class="activity-widget p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl">
  <h3 class="text-white font-bold mb-4">{widget.title}</h3>
  <div class="space-y-4">
    {#each activities as activity}
      <div class="flex gap-3">
        <div class="flex-shrink-0 w-8 h-8 bg-purple-600 rounded-full flex items-center justify-center text-white text-xs font-bold">
          {activity.icon || '📌'}
        </div>
        <div class="flex-1">
          <p class="text-white font-medium">{activity.title}</p>
          <p class="text-white/60 text-sm">{activity.description}</p>
          <p class="text-white/40 text-xs mt-1">{activity.time}</p>
        </div>
      </div>
    {/each}
  </div>
</div>
```

### InfoWidget - Cartes d'Information

```svelte
<!-- src/lib/components/dashboard/InfoWidget.svelte -->
<script lang="ts">
  import type { Widget } from '$lib/types';
  
  interface Props {
    widget: Widget;
  }
  
  let { widget }: Props = $props();
  const { description, link } = widget.content;
</script>

<div class="info-widget p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl">
  <h3 class="text-white font-bold mb-2">{widget.title}</h3>
  <p class="text-white/60 text-sm mb-4">{description}</p>
  {#if link}
    <a href={link.url} class="inline-flex items-center text-purple-400 hover:text-purple-300 text-sm">
      {link.label}
      <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
      </svg>
    </a>
  {/if}
</div>
```

## Drag-and-Drop with svelte-dnd-action

### Basic DnD Pattern

```svelte
<!-- src/routes/dashboard/+page.svelte -->
<script lang="ts">
  import { flip } from 'svelte/transition';
  import { dndzone } from 'svelte-dnd-action';
  import type { Widget } from '$lib/types';
  
  let widgets = $state<Widget[]>([]);
  let isSaving = $state(false);
  let saveTimeout: ReturnType<typeof setTimeout> | null = null;
  
  function debounce(fn: () => void, delay: number) {
    if (saveTimeout) clearTimeout(saveTimeout);
    saveTimeout = setTimeout(fn, delay);
  }
  
  function handleConsider(e: any) {
    console.log('DND consider:', e.detail);
  }
  
  function handleFinalize(e: any) {
    console.log('DND finalize:', e.detail);
    widgets = e.detail.items;
    lastUpdated = new Date();
    debouncedSave();
  }
  
  async function debouncedSave() {
    debounce(async () => {
      isSaving = true;
      const formData = new FormData();
      formData.append('widgets', JSON.stringify(widgets));
      await fetch('/dashboard', { method: 'POST', body: formData });
      isSaving = false;
    }, 500);
  }
</script>

<div 
  class="space-y-2"
  use:dndzone={{ 
    items: widgets,
    dropFromOthersDisabled: true,
    dragDisabled: false
  }}
  on:consider={handleConsider}
  on:finalize={handleFinalize}
>
  {#each widgets as widget (widget.id)}
    <div transition:flip|local class="widget-container">
      <svelte:component 
        this={getWidgetComponent(widget.type)} 
        {widget} 
      />
    </div>
  {/each}
</div>
```

### Multi-Column DnD

```svelte
<script lang="ts">
  import { dndzone } from 'svelte-dnd-action';
  
  const columns = $state([
    { id: 0, widgets: [] as Widget[] },
    { id: 1, widgets: [] as Widget[] },
    { id: 2, widgets: [] as Widget[] }
  ]);
  
  function handleFinalize(e: any, columnId: number) {
    const column = columns.find(c => c.id === columnId);
    if (column) {
      column.widgets = e.detail.items;
      // Save to database...
    }
  }
</script>

<div class="grid grid-cols-3 gap-4">
  {#each columns as column (column.id)}
    <div 
      class="column-container"
      use:dndzone={{ 
        items: column.widgets,
        dropFromOthersDisabled: false
      }}
      on:finalize={(e) => handleFinalize(e, column.id)}
    >
      {#each column.widgets as widget (widget.id)}
        <svelte:component 
          this={getWidgetComponent(widget.type)} 
          {widget} 
        />
      {/each}
    </div>
  {/each}
</div>
```

## Dashboard Layout

### Grid Layout

```css
/* src/routes/dashboard/+page.css */
.dashboard-grid {
  display: grid;
  gap: 1rem;
}

.dashboard-grid.columns-2 {
  grid-template-columns: repeat(2, 1fr);
}

.dashboard-grid.columns-3 {
  grid-template-columns: repeat(3, 1fr);
}

.dashboard-grid.columns-4 {
  grid-template-columns: repeat(4, 1fr);
}

/* Responsive */
@media (max-width: 768px) {
  .dashboard-grid.columns-2,
  .dashboard-grid.columns-3,
  .dashboard-grid.columns-4 {
    grid-template-columns: 1fr;
  }
}
```

```svelte
<!-- Grid layout component -->
<div class="dashboard-grid columns-{dashboard.columns}">
  {#each widgets as widget (widget.id)}
    <div class="widget-wrapper">
      <svelte:component 
        this={getWidgetComponent(widget.type)} 
        {widget} 
      />
    </div>
  {/each}
</div>
```

### Flex Layout

```svelte
<!-- Flex layout component -->
<div class="dashboard-flex columns-{dashboard.columns}">
  {#each widgets as widget (widget.id)}
    <div class="widget-wrapper">
      <svelte:component 
        this={getWidgetComponent(widget.type)} 
        {widget} 
      />
    </div>
  {/each}
</div>
```

```css
.dashboard-flex {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.dashboard-flex.columns-2 .widget-wrapper {
  flex: 0 0 calc(50% - 0.5rem);
}

.dashboard-flex.columns-3 .widget-wrapper {
  flex: 0 0 calc(33.333% - 0.666rem);
}

.dashboard-flex.columns-4 .widget-wrapper {
  flex: 0 0 calc(25% - 0.75rem);
}

/* Responsive */
@media (max-width: 768px) {
  .dashboard-flex .widget-wrapper {
    flex: 0 0 100%;
  }
}
```

## CRUD Operations

### Server Actions

```typescript
// src/routes/dashboard/+page.server.ts
import { fail } from '@sveltejs/kit';
import { db } from '$lib/db';
import { dashboards, widgets as widgetsTable } from '$lib/db/schema';
import { eq, and } from 'drizzle-orm';

// Load dashboard with widgets
export async function load({ params, request, locals }) {
  const dashboardId = parseInt(params.id);
  
  const dashboard = await db.select().from(dashboards).where(eq(dashboards.id, dashboardId)).limit(1);
  
  if (!dashboard.length) {
    throw error(404, 'Dashboard not found');
  }
  
  const widgets = await db.select()
    .from(widgetsTable)
    .where(eq(widgetsTable.dashboardId, dashboardId))
    .orderBy(widgetsTable.order);
  
  return {
    dashboard: dashboard[0],
    widgets: widgets.map(w => ({
      ...w,
      content: w.content as Record<string, any>
    }))
  };
}

// Update widget positions
export const actions = {
  updateWidgets: async ({ request }) => {
    const formData = await request.formData();
    const dashboardId = parseInt(formData.get('dashboardId') as string);
    const widgets = JSON.parse(formData.get('widgets') as string);
    
    // Delete all widgets for dashboard
    await db.delete(widgetsTable).where(eq(widgetsTable.dashboardId, dashboardId));
    
    // Re-insert widgets with new positions
    for (const widget of widgets) {
      await db.insert(widgetsTable).values({
        dashboardId,
        type: widget.type,
        title: widget.title,
        content: widget.content,
        size: widget.size,
        order: widget.order,
        column: widget.column,
        visible: widget.visible
      });
    }
    
    return { success: true };
  },
  
  addWidget: async ({ request }) => {
    const formData = await request.formData();
    const dashboardId = parseInt(formData.get('dashboardId') as string);
    const type = formData.get('type') as string;
    
    // Create new widget
    const newWidget = await db.insert(widgetsTable).values({
      dashboardId,
      type,
      title: 'New Widget',
      content: {},
      order: 0,
      column: 0,
      visible: true
    }).returning();
    
    return { success: true, widget: newWidget[0] };
  },
  
  deleteWidget: async ({ request }) => {
    const formData = await request.formData();
    const widgetId = parseInt(formData.get('widgetId') as string);
    
    await db.delete(widgetsTable).where(eq(widgetsTable.id, widgetId));
    
    return { success: true };
  },
  
  toggleWidgetVisibility: async ({ request }) => {
    const formData = await request.formData();
    const widgetId = parseInt(formData.get('widgetId') as string);
    const visible = formData.get('visible') === 'true';
    
    await db.update(widgetsTable)
      .set({ visible })
      .where(eq(widgetsTable.id, widgetId));
    
    return { success: true };
  }
};
```

## Auto-Save Positions

### Debounce Pattern (500ms)

```typescript
let widgets = $state<Widget[]>([]);
let isSaving = $state(false);
let lastSaved = $state<Date | null>(null);
let saveTimeout: ReturnType<typeof setTimeout> | null = null;

function debounce(fn: () => void, delay: number) {
  if (saveTimeout) clearTimeout(saveTimeout);
  saveTimeout = setTimeout(fn, delay);
}

async function saveWidgets() {
  isSaving = true;
  try {
    const formData = new FormData();
    formData.append('dashboardId', dashboardId.toString());
    formData.append('widgets', JSON.stringify(widgets));
    
    const response = await fetch('/dashboard', {
      method: 'POST',
      body: formData
    });
    
    lastSaved = new Date();
  } catch (error) {
    console.error('Save failed:', error);
  } finally {
    isSaving = false;
  }
}

// Auto-save on widget changes
$effect(() => {
  debounce(saveWidgets, 500);
});
```

## Testing

After setup, verify:

1. `pnpm check` passes (no TypeScript errors)
2. Dev server starts without errors
3. Drag-and-drop works smoothly
4. Widget positions are saved to database
5. Auto-save debounces correctly (500ms delay)
6. Multi-column layout works
7. Add/remove widgets functions correctly
8. Widget visibility toggle works
9. Layout switch (grid/flex) works
10. Responsive design (mobile/tablet/desktop)

## Common Pitfalls

1. **Wrong drag-drop library**: Use `svelte-dnd-action`, NOT `@dnd-kit` (React-only)
2. **Event handlers**: Use `on:consider`, `on:finalize`, NOT `onconsider`, `onfinalize`
3. **Missing key**: Always use `each widgets as widget (widget.id)` for proper reactivity
4. **Debounce too short**: 500ms is optimal, 100ms will cause too many requests
5. **Missing flip transition**: Add `transition:flip|local` for smooth drag-drop
6. **Type casting**: Widgets from DB need type casting: `content as Record<string, any>`
7. **Server action types**: Use proper TypeScript types for form data
8. **Widget component resolution**: Use `getWidgetComponent(type)` function to map types to components
9. **Multi-column ordering**: Remember to update `column` field when dragging between columns
10. **Layout responsiveness**: Test mobile/tablet breakpoints for grid/flex layouts

---
**Use this skill to build sortable, customizable dashboards with drag-and-drop widgets.**
