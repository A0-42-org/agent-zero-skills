---
name: "sveltekit-performance"
description: "Performance optimization patterns for SvelteKit. Covers code splitting, lazy loading, SSR/CSR, caching, bundle optimization, image optimization, and database optimization."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["sveltekit", "performance", "optimization", "code-splitting", "caching", "ssr"]
trigger_patterns:
  - "performance optimization"
  - "code splitting"
  - "lazy loading"
  - "bundle optimization"
  - "cache strategy"
  - "ssr csr"
  - "image optimization"
---

# SvelteKit Performance Pattern

Complete guide for optimizing performance in SvelteKit applications with code splitting, lazy loading, caching, and more.

## Use Case

Use this skill when:
- Optimizing initial load time and bundle size
- Implementing lazy loading for components and routes
- Configuring SSR/CSR for optimal performance
- Setting up caching strategies for API responses
- Optimizing database queries and images
- Improving Core Web Vitals (LCP, FID, CLS)
- Reducing time to interactive (TTI)
- Building production-ready applications

## Installation

```bash
# Install performance tools
bun add -D @sveltejs/adapter-auto

# Optional: Performance monitoring
bun add @vercel/analytics
bun add -d @sveltejs/vite-plugin-svelte
```

## Core Web Vitals

### Key Metrics

| Metric | Target | Description |
|--------|--------|-------------|
| **LCP** (Largest Contentful Paint) | < 2.5s | Loading performance |
| **FID** (First Input Delay) | < 100ms | Interactivity |
| **CLS** (Cumulative Layout Shift) | < 0.1 | Visual stability |
| **FCP** (First Contentful Paint) | < 1.8s | First meaningful paint |
| **TTI** (Time to Interactive) | < 3.8s | Full interactivity |

### Measuring Performance

```typescript
// src/lib/analytics/measure.ts
import { onMount } from 'svelte';

export function measureWebVitals() {
  if (typeof window === 'undefined') return;
  
  // Use Web Vitals library or Performance API
  const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      console.log(entry.name, entry.startTime);
    }
  });
  
  observer.observe({ type: 'paint', buffered: true });
  observer.observe({ type: 'largest-contentful-paint', buffered: true });
}
```

## Code Splitting

### Dynamic Imports for Components

```svelte
<script lang="ts">
  // Lazy load component
  import { onMount } from 'svelte';
  
  let HeavyComponent: any;
  let showHeavy = $state(false);
  
  onMount(async () => {
    HeavyComponent = (await import('$lib/components/HeavyComponent.svelte')).default;
  });
</script>

<button onclick={() => showHeavy = true}>
  Load Heavy Component
</button>

{#if showHeavy && HeavyComponent}
  <svelte:component this={HeavyComponent} />
{/if}
```

### Dynamic Routes

```typescript
// src/routes/admin/+page.server.ts
import { redirect } from '@sveltejs/kit';

export const load: PageServerLoad = async ({ locals }) => {
  if (!locals.user?.isAdmin) {
    throw redirect(303, '/');
  }
  
  return { user: locals.user };
};
```

### Dynamic Imports in Server Actions

```typescript
// src/routes/actions/+page.server.ts
export const actions = {
  heavyAction: async () => {
    // Lazy load heavy module
    const { processLargeData } = await import('$lib/utils/heavy');
    
    return processLargeData();
  }
};
```

## Lazy Loading

### Lazy Loading Images

```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  
  let loaded = $state(false);
  
  onMount(() => {
    // Create Intersection Observer for lazy loading
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          loaded = true;
          observer.disconnect();
        }
      });
    });
    
    const img = document.querySelector('img');
    if (img) observer.observe(img);
  });
</script>

<img 
  src={loaded ? 'https://example.com/large.jpg' : 'data:image/svg+xml;base64,placeholder'}
  alt="Lazy loaded image"
  loading="lazy"
/>
```

### Lazy Loading Routes

```typescript
// src/routes/+layout.ts
export const prerender = false; // Disable prerendering for dynamic content
export const ssr = true; // Enable SSR for initial load
```

### Lazy Loading with Skeleton UI

```svelte
<script lang="ts">
  import { Skeleton } from '@skeletonlabs/skeleton';
  
  let Component: any = null;
  let loading = $state(true);
  
  onMount(async () => {
    // Lazy load with delay for skeleton
    await new Promise(resolve => setTimeout(resolve, 300));
    Component = (await import('$lib/components/MyComponent.svelte')).default;
    loading = false;
  });
</script>

{#if loading}
  <Skeleton>
    <div class="h-64 w-full" />
  </Skeleton>
{:else if Component}
  <svelte:component this={Component} />
{/if}
```

## SSR/CSR Optimization

### Configure SSR per Route

```typescript
// src/routes/+page.server.ts (Always SSR)
export const ssr = true;
export const prerender = false;

// src/routes/about/+page.ts (Static prerender)
export const prerender = true;

// src/routes/dashboard/+page.ts (CSR only)
export const ssr = false;
```

### Hybrid SSR/CSR

```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  
  let mounted = $state(false);
  
  onMount(() => {
    mounted = true;
  });
</script>

<!-- Rendered on server -->
<h1>My Page</h1>

<!-- Rendered on client only -->
{#if mounted}
  <ClientOnlyComponent />
{/if}
```

### Client-Only Component

```svelte
<!-- src/lib/components/ClientOnly.svelte -->
<script lang="ts">
  import { onMount } from 'svelte';
  
  let mounted = $state(false);
  
  onMount(() => {
    mounted = true;
  });
</script>

{#if mounted}
  {@render children?.()}
{/if}
```

## Caching Strategies

### HTTP Caching Headers

```typescript
// src/routes/api/cached/+server.ts
import { json } from '@sveltejs/kit';

export async function GET({ url }) {
  const data = await fetchData(url.searchParams.toString());
  
  return json(data, {
    headers: {
      'Cache-Control': 'public, max-age=3600, s-maxage=3600'
    }
  });
}
```

### Cache-Control Directives

| Directive | Description | Use Case |
|-----------|-------------|----------|
| `public` | Cacheable by CDN and browser | Static assets, public APIs |
| `private` | Cacheable by browser only | User-specific data |
| `no-cache` | Validate with origin before use | Dynamic content |
| `no-store` | Never cache | Sensitive data |
| `max-age=3600` | Cache for 1 hour | Stable data |
| `s-maxage=3600` | CDN cache for 1 hour | CDN optimization |

### Caching API Responses

```typescript
// src/lib/api/cache.ts
const cache = new Map<string, { data: any; expiry: number }>();

export async function cachedFetch<T>(
  key: string,
  fetcher: () => Promise<T>,
  ttl: number = 60000 // 1 minute
): Promise<T> {
  const cached = cache.get(key);
  
  if (cached && Date.now() < cached.expiry) {
    return cached.data;
  }
  
  const data = await fetcher();
  cache.set(key, {
    data,
    expiry: Date.now() + ttl
  });
  
  return data;
}
```

### Using Cached Fetch

```typescript
// src/routes/api/users/+server.ts
import { cachedFetch } from '$lib/api/cache';

export async function GET() {
  const users = await cachedFetch('users', async () => {
    return await db.select().from(users);
  }, 30000); // 30 seconds
  
  return json(users);
}
```

## Bundle Optimization

### Vite Configuration

```typescript
// vite.config.ts
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [sveltekit()],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['svelte'],
          ui: ['@skeletonlabs/skeleton'],
          icons: ['lucide-svelte']
        }
      }
    }
  }
});
```

### Tree Shaking

```typescript
// ✅ GOOD - Tree shakable
import { Button } from '@skeletonlabs/skeleton';

// ❌ BAD - Imports entire library
import * as Skeleton from '@skeletonlabs/skeleton';
```

### Code Splitting by Route

```typescript
// svelte.config.js
export default {
  kit: {
    adapter: adapter(),
    paths: {
      base: '/my-app'
    },
    // Split chunks by route
    inlineStyleThreshold: 0
  }
};
```

## Image Optimization

### Responsive Images

```svelte
<script lang="ts">
  const imageSizes = [400, 800, 1200, 1600];
  const srcset = imageSizes
    .map(size => `/images/photo-${size}.jpg ${size}w`)
    .join(', ');
</script>

<img 
  src="/images/photo-800.jpg"
  srcset={srcset}
  sizes="(max-width: 800px) 100vw, 50vw"
  alt="Responsive image"
  loading="lazy"
/>
```

### Image Compression

```bash
# Use Vite image optimization plugin
bun add -d vite-plugin-imagemin
```

```typescript
// vite.config.ts
import { sveltekit } from '@sveltejs/kit/vite';
import imagemin from 'vite-plugin-imagemin';

export default defineConfig({
  plugins: [
    sveltekit(),
    imagemin({
      gifsicle: { optimizationLevel: 7 },
      optipng: { optimizationLevel: 7 },
      mozjpeg: { quality: 80 },
      svgo: {
        plugins: [
          { name: 'removeViewBox', active: false },
          { name: 'removeEmptyAttrs', active: true }
        ]
      }
    })
  ]
});
```

### WebP Conversion

```svelte
<script lang="ts">
  // Use modern image formats
  const imageSrc = '/images/photo.webp';
  const fallbackSrc = '/images/photo.jpg';
</script>

<picture>
  <source srcset={imageSrc} type="image/webp" />
  <img src={fallbackSrc} alt="Optimized image" />
</picture>
```

## Database Optimization

### Query Optimization

```typescript
// ✅ GOOD - Select only needed columns
const users = await db
  .select({ id: users.id, name: users.name })
  .from(users)
  .limit(10);

// ❌ BAD - Select all columns
const users = await db.select().from(users).limit(10);
```

### Index Optimization

```typescript
// src/lib/db/schema.ts
import { pgTable, index } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull(),
  name: text('name').notNull(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
}, (table) => ({
  emailIndex: index('email_index').on(table.email),
  createdAtIndex: index('created_at_index').on(table.createdAt)
}));
```

### Connection Pooling

```typescript
// src/lib/db.ts
import { drizzle } from 'drizzle-orm/postgres-js';
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20, // Max connections
  idleTimeoutMillis: 30000
});

export const db = drizzle(pool);
```

### Batch Operations

```typescript
// ✅ GOOD - Batch insert
await db.insert(users).values([
  { name: 'Alice', email: 'alice@example.com' },
  { name: 'Bob', email: 'bob@example.com' },
  { name: 'Charlie', email: 'charlie@example.com' }
]);

// ❌ BAD - Multiple inserts
for (const user of users) {
  await db.insert(users).values(user);
}
```

## Performance Monitoring

### Web Vitals Tracking

```typescript
// src/lib/analytics/web-vitals.ts
export function trackWebVitals() {
  if (typeof window === 'undefined') return;
  
  // Track LCP
  new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      if (entry.entryType === 'largest-contentful-paint') {
        console.log('LCP:', entry.startTime);
      }
    }
  }).observe({ type: 'largest-contentful-paint', buffered: true });
  
  // Track FID
  new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      if (entry.entryType === 'first-input') {
        console.log('FID:', entry.processingStart - entry.startTime);
      }
    }
  }).observe({ type: 'first-input', buffered: true });
  
  // Track CLS
  new PerformanceObserver((list) => {
    let cls = 0;
    for (const entry of list.getEntries()) {
      if (!entry.hadRecentInput) {
        cls += entry.value;
      }
    }
    console.log('CLS:', cls);
  }).observe({ type: 'layout-shift', buffered: true });
}
```
### Vercel Analytics
```typescript
// src/hooks.client.ts
import { inject } from '@vercel/analytics';

inject();
```

## Preloading Resources

### Preload Critical Resources

```svelte
<script lang="ts">
  // Preload fonts
  <link rel="preload" href="/fonts/inter.woff2" as="font" type="font/woff2" crossorigin />
  
  // Preload critical CSS
  <link rel="preload" href="/styles/critical.css" as="style" />
  
  // Prefetch next pages
  <link rel="prefetch" href="/about" />
  <link rel="prefetch" href="/contact" />
</script>
```

### Prefetching Links

```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  
  let links = $state([
    { href: '/about', label: 'About' },
    { href: '/services', label: 'Services' },
    { href: '/contact', label: 'Contact' }
  ]);
  
  onMount(() => {
    // Prefetch links on hover
    links.forEach(link => {
      const element = document.querySelector(`a[href="${link.href}"]`);
      if (element) {
        element.addEventListener('mouseenter', () => {
          const prefetchLink = document.createElement('link');
          prefetchLink.rel = 'prefetch';
          prefetchLink.href = link.href;
          document.head.appendChild(prefetchLink);
        });
      }
    });
  });
</script>

<nav>
  {#each links as link}
    <a href={link.href}>{link.label}</a>
  {/each}
</nav>
```
## Best Practices

### 1. Use Dynamic Imports
```typescript
// ✅ GOOD - Dynamic import
const Component = await import('$lib/components/Heavy.svelte');

// ❌ BAD - Static import
import HeavyComponent from '$lib/components/Heavy.svelte';
```

### 2. Enable SSR for Initial Load
```typescript
// ✅ GOOD - Enable SSR
export const ssr = true;

// ❌ BAD - Disable SSR
export const ssr = false;
```

### 3. Use Proper Caching Headers
```typescript
// ✅ GOOD - Set cache headers
return json(data, {
  headers: {
    'Cache-Control': 'public, max-age=3600'
  }
});

// ❌ BAD - No cache headers
return json(data);
```

### 4. Optimize Images
```svelte
<!-- ✅ GOOD - Optimized image -->
<img 
  src="/images/photo.webp"
  srcset="/images/photo-800.jpg 800w, /images/photo-1600.jpg 1600w"
  sizes="(max-width: 800px) 100vw, 50vw"
  loading="lazy"
  alt="Optimized image"
/>

<!-- ❌ BAD - Unoptimized image -->
<img src="/large-photo.jpg" alt="Large photo" />
```

### 5. Use Code Splitting
```typescript
// ✅ GOOD - Code split
export const actions = {
  heavyAction: async () => {
    const { process } = await import('$lib/utils/heavy');
    return process();
  }
};

// ❌ BAD - No code split
import { process } from '$lib/utils/heavy';
```

## Performance Checklist

Before deploying, verify:

- [ ] Dynamic imports used for heavy components
- [ ] SSR enabled for initial load
- [ ] Proper caching headers set
- [ ] Images optimized (WebP, responsive)
- [ ] Database queries optimized
- [ ] Indexes created for frequently queried columns
- [ ] Connection pooling configured
- [ ] Bundle size analyzed and optimized
- [ ] Web Vitals tracking implemented
- [ ] Critical resources preloaded
- [ ] Lazy loading implemented for non-critical resources

## Common Pitfalls

### 1. No Code Splitting
```typescript
// ❌ BAD - No code splitting
import HeavyComponent from '$lib/components/Heavy.svelte';

// ✅ GOOD - Dynamic import
const Component = await import('$lib/components/Heavy.svelte');
```

### 2. Disabling SSR Unnecessarily
```typescript
// ❌ BAD - SSR disabled
export const ssr = false;

// ✅ GOOD - SSR enabled
export const ssr = true;
```
### 3. No Caching Headers
```typescript
// ❌ BAD - No cache headers
export async function GET() {
  return json(data);
}

// ✅ GOOD - Cache headers set
export async function GET() {
  return json(data, {
    headers: {
      'Cache-Control': 'public, max-age=3600'
    }
  });
}
```

### 4. Unoptimized Images
```svelte
<!-- ❌ BAD - Unoptimized image -->
<img src="/large-photo.jpg" alt="Large photo" />

<!-- ✅ GOOD - Optimized image -->
<img 
  src="/images/photo.webp"
  srcset="/images/photo-800.jpg 800w, /images/photo-1600.jpg 1600w"
  sizes="(max-width: 800px) 100vw, 50vw"
  loading="lazy"
  alt="Optimized image"
/>
```

### 5. No Database Indexes
```typescript
// ❌ BAD - No indexes
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull()
});

// ✅ GOOD - Index on email
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull(),
}, (table) => ({
  emailIndex: index('email_index').on(table.email)
}));
```

## Testing

After optimizing performance, verify:

1. Lighthouse score > 90
2. Core Web Vitals within targets
3. Bundle size is reasonable (< 200KB)
4. Images load progressively
5. Initial load time < 2.5s
6. Time to interactive < 3.8s
7. Caching headers are set correctly
8. Database queries are fast (< 100ms)
9. Lazy loading works correctly
10. SSR/CSR configured appropriately

---
**Use this skill to optimize performance in SvelteKit applications with code splitting, caching, and best practices.**
