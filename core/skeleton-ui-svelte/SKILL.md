# Skeleton UI v4 for SvelteKit

Setup Skeleton UI v4 with Tailwind CSS v4 for SvelteKit projects.

## Installation

```bash
bun add -D @skeletonlabs/skeleton @skeletonlabs/skeleton-svelte
```

## Configuration

### 1. Create skeleton.config.js

```javascript
// skeleton.config.js
import { cerberus } from '@skeletonlabs/skeleton';

export default {
  themes: [cerberus],
  structure: {
    base: [{ id: 'cerberus', name: 'Cerberus', description: 'Dark theme with luxury aesthetic' }],
    components: [],
    presets: []
  },
  themesPlugin: {
    strategy: 'default',
    auto: {
      cssPath: 'src/routes/layout.css',
      cssLayer: { base: 'base', components: 'components', utilities: 'utilities', theme: 'theme' }
    }
  }
};
```

### 2. Update src/app.html

Add `data-theme` attribute to html tag:

```html
<!doctype html>
<html lang="en" data-theme="cerberus">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%sveltekit.assets%/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    %sveltekit.head%
  </head>
  <body data-sveltekit-preload-data="hover">
    <div style="display: contents">%sveltekit.body%</div>
  </body>
</html>
```

### 3. Create src/routes/layout.css

**IMPORTANT**: Use correct import format:

```css
/* Tailwind CSS v4 */
@import 'tailwindcss';

/* Tailwind CSS plugins */
@plugin '@tailwindcss/forms';
@plugin '@tailwindcss/typography';

/* Skeleton UI v4 imports */
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';

/* Custom theme adjustments */
:root {
  --font-body: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}
```

**NOTE**: Do NOT import components from '@skeletonlabs/skeleton-svelte' in your Svelte files. Use Tailwind utility classes and Skeleton UI themes instead.

### 4. Update src/routes/+layout.svelte

Import CSS file:

```svelte
<script lang="ts">
  import '../layout.css';
</script>

<slot />
```

## CRITICAL: Tailwind CSS v4 + Svelte Best Practices


### ❌ What NOT to Do with Tailwind v4

**1. DO NOT use `@apply` with utility classes in Svelte `<style>` blocks**

```svelte
<!-- ❌ DON'T DO THIS -->
<style lang="postcss">
.my-class {
@apply flex justify-center gap-3;
}
</style>
```

**Problem with Tailwind v4:**
- Tailwind v4 does NOT correctly recognize utility classes in `@apply`
- Build fails with errors like: "Cannot apply unknown utility class"
- This is due to how Tailwind v4 processes plugins and directives


**2. DO NOT mix `@apply` and inline classes**

```svelte
<!-- ❌ PROBLEMATIC COMBINATION -->
<div class="@apply flex gap-3 p-4">
<!-- Content -->
</div>

<style lang="postcss">
.my-class {
@apply flex gap-3;
}
</style>
```

This creates confusion and increases code maintenance.

**3. DO NOT over-apply classes**

```svelte
<!-- ❌ TOO MANY INLINE CLASSES -->
<div
class="
    flex cursor-pointer items-center justify-center
    gap-2 rounded-lg px-6
    py-4 text-lg
    font-semibold transition-all
    duration-200
    hover:scale-105
    hover:shadow-lg
  "
>
<!-- Content -->
</div>
```

This makes code hard to read and maintain.

### ✅ What to DO Instead

**1. Use classes directly in HTML (RECOMMENDED)**

```svelte
<!-- ✅ USE INLINE CLASSES -->
<div
class="flex cursor-pointer items-center gap-2 rounded-lg px-6 py-4 text-lg font-semibold transition-all duration-200 hover:scale-105 hover:shadow-lg"
>
<!-- Content -->
</div>
```

**Advantages:**
- Faster to develop
- More readable code for beginners
- Less CSS files to maintain
- Very well supported by Tailwind v4

**2. Create custom CSS classes if necessary**

```svelte
<div class="card-button">
<!-- Content -->
</div>

<!-- ✅ CREATE CUSTOM CLASSES -->
<style lang="postcss">
.card-button {
display: flex;
align-items: center;
gap: 0.5rem;
padding: 1rem 1.5rem;
border-radius: 0.5rem;
font-size: 1.125rem;
font-weight: 600;
transition: all 0.2s ease;
}

.card-button:hover {
transform: scale(1.05);
box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
```

**Advantages:**
- Cleaner and maintainable code
- Ideal for reusable components
- Easier to modify later

**3. Use conditional classes intelligently**

```svelte
<!-- ✅ USE CONDITIONALS -->
<div
  class="flex items-center gap-2"
  class:px-6={usePadding}
  class:rounded-lg={useBorderRadius}
>
  <!-- Content -->
</div>

<div
  class="flex items-center gap-2"
  class="px-6 py-4 rounded-lg"
  class:text-lg={fontSize === 'large'}
  class:text-base={fontSize === 'normal'}
>
  <!-- Content -->
</div>
```

**Advantages:**
- Cleaner code
- Explicit conditions
- Helps with maintenance

**4. Group classes by utility**

```svelte
<!-- ✅ GROUP CLASSES BY TYPE -->
<div
class="
    /* Layout */
    flex cursor-pointer items-center
    /* Spacing & Shape */
    gap-2 rounded-lg px-6 py-4
    /* Typography */
    text-lg font-semibold
    /* Animation */
    transition-all duration-200
    /* Hover effects */
    hover:scale-105 hover:shadow-lg
  "
>
<!-- Content -->
</div>
```

## Guide to Choosing Approach

### When to use inline classes?
- ✅ For simple or unique components
- ✅ For less complex styles
- ✅ For rapid prototyping
- ✅ For layout components

### When to create custom classes?
- ✅ For reusable components
- ✅ For complex style patterns
- ✅ For themes or recurring variations
- ✅ When you need lots of context

### When to use `@apply` (if possible)?
- ✅ In global CSS files (not in Svelte)
- ✅ For creating reusable theme classes
- ✅ For complex CSS mixins

## Golden Rules for Tailwind v4 + Svelte

1. **AVOID `@apply` in Svelte components** - Use inline classes instead
2. **Keep inline styles in a single line** - Use backticks
3. **Group classes logically** - Even if not perfectly organized, it helps
4. **Use conditional classes** - `class:condition` instead of complex JS logic
5. **Create components with inline styles** - Svelte is made for this
6. **Keep global styles in `layout.css`** - Use `@import` there

## Custom Brand Styles

### Adding Custom CSS (e.g., svelteforge.css)

```css
/* src/routes/layout.css */
/* Tailwind CSS v4 */
@import 'tailwindcss';

/* Tailwind CSS plugins */
@plugin '@tailwindcss/forms';
@plugin '@tailwindcss/typography';

/* Skeleton UI v4 imports */
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';

/* Import custom brand styles */
@import "../lib/themes/brand-styles/svelteforge.css";

/* Custom theme adjustments */
:root {
  --font-body: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}
```

## Theme System

### Multiple Themes

```javascript
// skeleton.config.js
import { cerberus, modern, rocket } from '@skeletonlabs/skeleton';

export default {
  themes: [cerberus, modern, rocket],
  structure: {
    base: [
      { id: 'cerberus', name: 'Cerberus', description: 'Dark theme with luxury aesthetic' },
      { id: 'modern', name: 'Modern', description: 'Clean minimal light theme' },
      { id: 'rocket', name: 'Rocket', description: 'Bold vibrant theme' }
    ],
    components: [],
    presets: []
  },
  themesPlugin: {
    strategy: 'default',
    auto: {
      cssPath: 'src/routes/layout.css',
      cssLayer: { base: 'base', components: 'components', utilities: 'utilities', theme: 'theme' }
    }
  }
};
```

### Theme Switching

```svelte
<!-- src/lib/components/ThemeSelector.svelte -->
<script lang="ts">
  import { browser } from '$app/environment';
  
  let theme = browser ? document.documentElement.getAttribute('data-theme') || 'cerberus' : 'cerberus';
  
  function setTheme(t: string) {
    theme = t;
    if (browser) {
      document.documentElement.setAttribute('data-theme', t);
      localStorage.setItem('theme', t);
    }
  }
  
  if (browser) {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) setTheme(savedTheme);
  }
</script>

<select bind:value={theme} onchange={(e) => setTheme(e.currentTarget.value)}>
  <option value="cerberus">Cerberus</option>
  <option value="modern">Modern</option>
  <option value="rocket">Rocket</option>
</select>
```

## Important Notes

1. **Import order**: Must follow the order: tailwindcss → plugins → skeleton → skeleton-svelte
2. **No component imports**: Do NOT import components from '@skeletonlabs/skeleton-svelte' - they are not available as ES modules in SvelteKit 2
3. **Tailwind CSS v4**: Use Tailwind utility classes instead of importing components
4. **Custom CSS**: Import custom brand styles AFTER main Skeleton UI imports
5. **Theme switching**: Use data-theme attribute on html element for theme switching
6. **CRITICAL**: NEVER use `@apply` with utility classes in Svelte components - this causes build failures in Tailwind v4

## Common Patterns

### Glassmorphism Effect

```svelte
<div class="bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl p-6">
  Content
</div>
```

### Button Styles

```svelte
<button class="bg-purple-600 hover:bg-purple-700 text-white font-medium px-4 py-2 rounded-lg transition-colors">
  Button
</button>
```

### Input Styles

```svelte
<input
  class="bg-white/10 border border-white/20 rounded-lg px-4 py-2 text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-purple-500"
  placeholder="Enter text..."
/>
```

## Testing

Verify setup:
1. `bun check` passes (no TypeScript errors)
2. Dev server starts without errors
3. CSS imports work (check browser DevTools)
4. Theme switching works
5. Custom CSS loads correctly
6. Build succeeds with Tailwind v4 (no `@apply` errors)

## Common Pitfalls

1. **Wrong import order**: Must follow: tailwindcss → plugins → skeleton → skeleton-svelte
2. **Component imports**: Do NOT import components from '@skeletonlabs/skeleton-svelte'
3. **CSS order**: Import custom CSS AFTER main Skeleton UI imports
4. **Theme attribute**: Set data-theme on html element, not body
5. **Missing plugins**: Don't forget @tailwindcss/forms and @tailwindcss/typography plugins
6. **CRITICAL**: Using `@apply` with utility classes in Svelte components causes build failures in Tailwind v4

---
**Skill updated with critical Tailwind v4 + Svelte best practices.**
