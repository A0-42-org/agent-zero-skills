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
pnpm add -D @sveltejs/adapter-auto

# Optional: Performance monitoring
pnpm add @vercel/analytics
pnpm add -d @sveltejs/vite-plugin-svelte
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

### Lazy Loading Routes

```typescript
// src/routes/+layout.ts
export const prerender = false; // Disable prerendering for dynamic content
export const ssr = true; // Enable SSR for initial load
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

## Bundle Optimization

### Vite Configuration (Tailwind CSS v4 + Skeleton UI v4.12.0)

```typescript
// vite.config.ts
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';
import skeleton from '@skeletonlabs/skeleton-svelte';

export default defineConfig({
  plugins: [
    sveltekit(),
    tailwindcss(),
    skeleton()
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['svelte'],
          // Skeleton UI v4.12.0 - the package still exists
          ui: ['@skeletonlabs/skeleton'],
          icons: ['lucide-svelte']
        }
      }
    }
  },
  server: {
    port: 5174,
    host: true
  }
});
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

### Image Compression

```bash
# Use Vite image optimization plugin
pnpm add -d vite-plugin-imagemin
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

### Index Optimization

```typescript
// src/lib/db/schema.ts
import { pgTable, index, serial, text, timestamp } from 'drizzle-orm/pg-core';

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

### Vercel Analytics

```typescript
// src/hooks.client.ts
import { inject } from '@vercel/analytics';

inject();
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

### 2. Enable SSR for Initial Load

```typescript
// ✅ GOOD - Enable SSR
export const ssr = true;

// ❌ BAD - Disable SSR
export const ssr = false;
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
