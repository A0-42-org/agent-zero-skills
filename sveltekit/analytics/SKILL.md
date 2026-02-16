# SvelteKit Analytics

Complete analytics system for SvelteKit projects including event tracking, dashboards, and statistics.

## Use Case

Implement comprehensive analytics for:
- Event tracking (page views, clicks, user actions)
- Dashboard analytics with charts and graphs
- Real-time statistics updates
- Click-through rate (CTR) calculation
- User engagement metrics
- Data export functionality
- Integration with SvelteKit actions


## Installation

```bash
# Optional: Chart libraries for dashboards
pnpm add chart.js svelte-chartjs

# Optional: ApexCharts for advanced visualizations
pnpm add apexcharts
```

## Database Schema (Drizzle ORM)

### Events Table
```typescript
// src/lib/db/schema.ts
import { pgTable, serial, text, timestamp, boolean, integer } from "drizzle-orm/pg-core";

export const events = pgTable("events", {
  id: serial("id").primaryKey(),
  userId: text("userId").notNull().references(() => users.id, { onDelete: "cascade" }),
  sessionId: text("sessionId").notNull(),
  type: text("type").notNull(), // 'page_view', 'click', 'cta_click', 'social_click'
  targetId: text("targetId").notNull(), // page ID, link ID, CTA ID
  targetUrl: text("targetUrl").notNull(),
  metadata: json("metadata").$type<Record<string, any>>(), // Custom data
  createdAt: timestamp("createdAt").notNull().defaultNow(),
});

export const pageViews = pgTable("page_views", {
  id: serial("id").primaryKey(),
  userId: text("userId").notNull().references(() => users.id, { onDelete: "cascade" }),
  pageId: text("pageId").notNull().references(() => pages.id, { onDelete: "cascade" }),
  viewCount: integer("viewCount").notNull().default(0),
  lastViewedAt: timestamp("lastViewedAt").notNull(),
  firstViewedAt: timestamp("firstViewedAt").notNull(),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
});

export const clicks = pgTable("clicks", {
  id: serial("id").primaryKey(),
  userId: text("userId").notNull().references(() => users.id, { onDelete: "cascade" }),
  pageId: text("pageId").notNull().references(() => pages.id, { onDelete: "cascade" }),
  elementId: text("elementId").notNull(), // Link ID, CTA ID, social ID
  elementUrl: text("elementUrl").notNull(),
  metadata: json("metadata").$type<Record<string, any>>(),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
});
```

## Server-Side Event Tracking

### Track Page View
```typescript
// src/routes/[username]/+page.server.ts
import { fail, redirect } from "@sveltejs/kit";
import { db } from "$lib/db";
import { events } from "$lib/db/schema";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ params, locals }) => {
  const username = params.username;
  
  if (!locals.user) {
    return { page: null };
  }
  
  // Find page by username
  const [page] = await db.select()
    .from(pages)
    .where(eq(pages.slug, username))
    .limit(1);
  
  if (!page) {
    throw error(404, "Page not found");
  }
  
  return { page };
};

export const actions = {
  trackView: async ({ request, locals }) => {
    if (!locals.user) {
      return fail(401, "Unauthorized");
    }
    
    await db.insert(events).values({
      userId: locals.user.id,
      type: "page_view",
      targetId: page.id,
      metadata: {
        userAgent: request.headers.get("user-agent"),
        referrer: request.headers.get("referer"),
        device: getDeviceType(request.headers.get("user-agent"))
      }
    });
    
    return { success: true };
  }
};

function getDeviceType(userAgent: string): string {
  // Simple device detection
  if (userAgent.includes("Mobile")) return "mobile";
  if (userAgent.includes("Tablet")) return "tablet";
  if (userAgent.includes("Windows")) return "desktop";
  return "unknown";
}
```

### Track Click
```typescript
// src/routes/[username]/+page.svelte
<script lang="ts">
  import { trackClick } from "$lib/analytics/actions";
  import { page } from "$lib/stores";
</script>

{#if page}
  <a 
    href="https://example.com"
    onclick={() => trackClick({
      pageId: page.id,
      elementId: "link-123",
      elementUrl: "https://example.com"
    })}
  >
    Click me
  </a>
{/if}
```

```typescript
// src/lib/analytics/actions.ts
import { db } from "$lib/db";
import { events } from "$lib/db/schema";
export async function trackClick({
  pageId: number,
  elementId: string,
  elementUrl: string,
  metadata?: Record<string, any>
}) {
  const response = await fetch("/analytics/track-click", {
    method: "POST",
    body: JSON.stringify({ pageId, elementId, elementUrl, metadata })
  });
  
  return response.ok;
}
```

```typescript
// src/routes/analytics/+page.server.ts
import { fail } from "@sveltejs/kit";
import { db } from "$lib/db";
import { events } from "$lib/db/schema";
export const actions = {
  trackClick: async ({ request, locals }) => {
    if (!locals.user) {
      return fail(401, "Unauthorized");
    }
    
    const data = await request.formData();
    const pageId = parseInt(data.get("pageId") as string);
    const elementId = data.get("elementId") as string;
    const elementUrl = data.get("elementUrl") as string;
    
    await db.insert(events).values({
      userId: locals.user.id,
      type: "click",
      pageId,
      elementId,
      elementUrl,
      metadata: {
        timestamp: new Date().toISOString()
      }
    });
    
    return { success: true };
  }
};
```

## Client-Side Analytics

### Client-Side Tracking
```typescript
// src/lib/analytics/client.ts
import { browser } from "$app/environment";
export async function trackClientEvent(
  type: string,
  data: Record<string, any>
) {
  if (!browser) return;
  
  await fetch("/analytics/track", {
    method: "POST",
    body: JSON.stringify({ type, data })
  });
}
```

```svelte
<!-- src/routes/+page.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import { trackClientEvent } from "$lib/analytics/client";
  
  onMount(() => {
    // Track page view on load
    trackClientEvent("page_view", {
      path: window.location.pathname
    });
    
    // Track clicks
    document.addEventListener("click", async (e) => {
      const target = e.target as HTMLElement;
      const link = target.closest("a");
      if (link) {
        const url = (link as HTMLAnchorElement).href;
        await trackClientEvent("click", {
          url,
          text: target.textContent
        });
      }
    });
  });
</script>
```

## Dashboard Analytics

### Analytics Stats Component
```svelte
<!-- src/lib/components/analytics/StatsCard.svelte -->
<script lang="ts">
  interface Props {
    title: string;
    value: number;
    change?: number;
    trend?: "up" | "down";
    icon?: string;
  }
  
  let { title, value, change, trend, icon = "📈" }: Props = $props();
  
  const isPositive = trend === "up";
</script>

<div class="p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl">
  <div class="flex items-center justify-between">
    <div>
      <p class="text-white/60 text-sm">{title}</p>
      <p class="text-3xl font-bold text-white">{value}</p>
    </div>
    {#if change}
      <div class="flex items-center {isPositive ? 'text-green-500' : 'text-red-500'}">
        {#if isPositive}
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l-7 7m0 0"/>
          </svg>
        {:else}
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7 7m0 0"/>
          </svg>
        {/if}
        <span class="ml-1">{change > 0 ? '+' : ''}{Math.abs(change)}%</span>
      </div>
    {/if}
    <div class="text-2xl">{icon}</div>
  </div>
</div>
```

### Chart Component
```svelte
<!-- src/lib/components/analytics/ViewsChart.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import Chart from "chart.js/auto";
  import type { PageViewsData } from "$lib/analytics/types";
  
  interface Props {
    data: PageViewsData[];
  }
  
  let { data }: Props = $props();
  let canvasElement: HTMLCanvasElement;
  let chart: Chart;
  
  onMount(() => {
    chart = new Chart(canvasElement, {
      type: "line",
      data: {
        labels: data.map(d => new Date(d.date).toLocaleDateString()),
        datasets: [{
          label: "Views",
          data: data.map(d => d.views),
          borderColor: "#8b5cf6",
          backgroundColor: "rgba(139, 92, 246, 0.2)"
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          }
        }
      }
    });
    
    return () => {
      chart.destroy();
    };
  });
</script>

<div class="p-4 bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl h-80">
  <canvas bind:this={canvasElement}></canvas>
</div>
```

### Analytics Dashboard Page
```svelte
<!-- src/routes/analytics/+page.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import Chart from "chart.js/auto";
  import StatsCard from "$lib/components/analytics/StatsCard";
  import ViewsChart from "$lib/components/analytics/ViewsChart";
  
  let stats = $state({
    totalViews: 0,
    totalClicks: 0,
    ctr: 0
  });
  
  onMount(async () => {
    // Fetch analytics data
    const response = await fetch("/analytics/stats");
    const data = await response.json();
    
    stats.totalViews = data.totalViews || 0;
    stats.totalClicks = data.totalClicks || 0;
    stats.ctr = data.ctr || 0;
  });
</script>

<svelte:head>
  <title>Analytics Dashboard</title>
</svelte:head>

<div class="container mx-auto p-4">
  <h1 class="text-2xl font-bold text-white mb-6">Analytics Dashboard</h1>
  
  <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
    <StatsCard title="Total Views" value={stats.totalViews} trend="up" icon="👁" />
    <StatsCard title="Total Clicks" value={stats.totalClicks} trend="up" icon="🖱️" />
    <StatsCard title="CTR" value={stats.ctr} trend={stats.ctr >= 0 ? "up" : "down"} icon="📊" />
  </div>
  
  <div class="mt-6">
    <h2 class="text-xl font-bold text-white mb-4">Views Over Time</h2>
    <ViewsChart data={pageViewsData} />
  </div>
</div>
```

```typescript
// src/routes/analytics/+page.server.ts
import { fail } from "@sveltejs/kit";
import { db } from "$lib/db";
import { events, pageViews, clicks } from "$lib/db/schema";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ request, locals }) => {
  if (!locals.user) {
    return fail(401, "Unauthorized");
  }
  
  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
  
  // Get page views (last 30 days)
  const viewsData = await db.select()
    .from(pageViews)
    .where(
      and(
        eq(pageViews.userId, locals.user.id),
        gte(pageViews.createdAt, thirtyDaysAgo)
      )
    )
    .orderBy(pageViews.createdAt);
  
  // Get total clicks
  const totalClicksResult = await db.select({ count: clicks.id })
    .from(clicks)
    .where(eq(clicks.userId, locals.user.id));
  const totalClicks = totalClicksResult[0].count;
  
  // Calculate CTR
  const totalViewsResult = await db.select({ count: pageViews.id })
    .from(pageViews)
    .where(eq(pageViews.userId, locals.user.id));
  const totalViews = totalViewsResult[0].count;
  const ctr = totalViews > 0 ? (totalClicks / totalViews) * 100 : 0;
  
  return {
    pageViewsData: viewsData,
    totalViews,
    totalClicks,
    ctr
  };
};
```

## Statistics Calculations

### CTR (Click-Through Rate)
```typescript
function calculateCTR(clicks: number, views: number): number {
  if (views === 0) return 0;
  return Math.round((clicks / views) * 100) / 100;
}
```

### Engagement Metrics
```typescript
function calculateEngagement(clicks: number, views: number): number {
  if (views === 0) return 0;
  // Average clicks per view
  const avgClicksPerView = clicks / views;
  // Engagement score (0-100)
  return Math.min(100, avgClicksPerView * 20);
}
```

## Real-Time Updates

### Server-Sent Events
```typescript
// src/lib/analytics/events.ts
import { browser } from "$app/environment";
import { writable } from "svelte/store";
export const analyticsEvents = writable({
  views: 0,
  clicks: 0,
  ctr: 0
});

// Update via WebSocket or polling
export function updateAnalytics() {
  analyticsEvents.update(current => ({
    ...current,
    views: current.views + 1
  }));
}
```

```svelte
<!-- Using in components -->
<script lang="ts">
  import { analyticsEvents } from "$lib/analytics/events";
  
  $effect(() => {
    // Auto-update stats
  });
</script>
```

## Export Functionality

### Export CSV
```typescript
// src/routes/analytics/export/+page.server.ts
import { fail } from "@sveltejs/kit";
import { db } from "$lib/db";
import { events, pageViews, clicks } from "$lib/db/schema";
import type { PageServerLoad } from "./$types";
export const load: PageServerLoad = async ({ request, locals }) => {
  if (!locals.user) {
    return fail(401, "Unauthorized");
  }
  
  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
  
  const data = await db.select()
    .from(pageViews)
    .where(
      and(
        eq(pageViews.userId, locals.user.id),
        gte(pageViews.createdAt, thirtyDaysAgo)
      )
    )
    .orderBy(pageViews.createdAt);
  
  const csv = [
    "Date,Views,First Viewed,Last Viewed",
  ].concat(
      data.map(row => [
        row.createdAt.toISOString(),
        row.viewCount,
        row.firstViewedAt?.toISOString(),
        row.lastViewedAt?.toISOString()
      ])
    );
  
  return new Response(csv.join("\n"), {
    headers: {
      "Content-Type": "text/csv",
      "Content-Disposition": "attachment; filename=analytics-export.csv"
    }
  });
};
```

### Export JSON
```typescript
// src/routes/analytics/export/+page.server.ts
export const load: PageServerLoad = async ({ request, locals }) => {
  if (!locals.user) {
    return fail(401, "Unauthorized");
  }
  
  const data = await db.select()
    .from(pageViews)
    .where(eq(pageViews.userId, locals.user.id));
  
  return new Response(JSON.stringify(data, null, 2), {
    headers: {
      "Content-Type": "application/json",
      "Content-Disposition": "attachment; filename=analytics-export.json"
    }
  });
};
```

## Integration with Segre.vip Project

### Page Analytics Integration
```typescript
// Add pageId tracking to blocks
await db.insert(pageViews).values({
  userId: user.id,
  pageId: page.id,
  viewCount: 1,
  createdAt: new Date()
});
```

### User Analytics
```typescript
// src/lib/analytics/user.ts
import { db } from "$lib/db";
import { events, pageViews, clicks } from "$lib/db/schema";
export async function getUserStats(userId: string) {
  const [user] = await db.select().from(users).where(eq(users.id, userId)).limit(1);
  
  if (!user) return null;
  
  // Get total views
  const totalViews = await db.select({ count: pageViews.id }).from(pageViews).where(eq(pageViews.userId, userId));
  
  // Get total clicks
  const totalClicks = await db.select({ count: clicks.id }).from(clicks).where(eq(clicks.userId, userId));
  
  return {
    totalViews: totalViews[0].count,
    totalClicks: totalClicks[0].count
  };
}
```

## Testing

After setup, verify:
1. `pnpm check` passes (no TypeScript errors)
2. Dev server starts without errors
3. Database tables created successfully
4. Event tracking works (events are logged)
5. Dashboard loads analytics data correctly
6. Charts render properly
7. Export functionality works (CSV/JSON)
8. CTR calculations are accurate
9. Real-time updates work (if implemented)
10. Integration with Segre.vip project works

## Common Pitfalls

1. **Server-side vs client-side**: Use server-side tracking for accurate data, client-side for UX features
2. **Missing authentication check**: Always verify `locals.user` before tracking events
3. **Device detection**: Don't rely on user-agent for accurate device tracking
4. **CTR calculation**: Handle division by zero (check `views > 0`)
5. **Performance**: Don't query too much data at once - use pagination
6. **Date handling**: Always use UTC timestamps and convert for display
7. **Export functionality**: Ensure proper Content-Type headers for CSV/JSON downloads
8. **Chart.js initialization**: Destroy charts on component unmount to prevent memory leaks
9. **Database indexes**: Create indexes on frequently queried columns (userId, pageId, createdAt)
10. **TypeScript types**: Ensure proper typing for all database queries and API responses

---
**Use this skill to implement comprehensive analytics with event tracking, dashboards, and statistics.**
