# Analytics Templates (Optional)

These templates provide analytics tracking and visualization for your dashboard.

## Components

### tracking.ts
Analytics tracking functions for tracking user events, page views, and widget interactions.

## Usage

```typescript
import { trackEvent, getPageViews, getWidgetStats } from '$lib/analytics/tracking';

// Track page view
await trackEvent(userId, 'page_view', { page: '/dashboard' });

// Track widget click
await trackEvent(userId, 'widget_click', { widgetId: 'widget-1' });

// Get page views
const pageViews = await getPageViews(userId, 30); // last 30 days


// Get widget stats
const stats = await getWidgetStats(userId, 30);
```

### Create analytics page

Create `src/routes/dashboard/analytics/+page.server.ts`:

```typescript
import { getPageViews, getWidgetStats } from '$lib/analytics/tracking';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
  const userId = locals.user?.id;
  if (!userId) throw redirect(303, '/login');

  const pageViews = await getPageViews(userId, 30);
  const stats = await getWidgetStats(userId, 30);

  return { pageViews, stats };
};
```

## Customization

You can add more analytics features like:
- Funnels
- Cohorts
- Heatmaps
- Real-time events

---
**Use these templates to add analytics to your dashboard.**
