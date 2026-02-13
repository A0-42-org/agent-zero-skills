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

Add `data-theme` attribute to the html tag:

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

**IMPORTANT**: Use the correct import format:

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

Import the CSS file:

```svelte
<script lang="ts">
  import '../layout.css';
</script>

<slot />
```

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
4. **Custom CSS**: Import custom brand styles AFTER the main Skeleton UI imports
5. **Theme switching**: Use data-theme attribute on html element for theme switching

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

## Common Pitfalls

1. **Wrong import order**: Must follow: tailwindcss → plugins → skeleton → skeleton-svelte
2. **Component imports**: Do NOT import components from '@skeletonlabs/skeleton-svelte'
3. **CSS order**: Import custom CSS AFTER the main Skeleton UI imports
4. **Theme attribute**: Set data-theme on html element, not body
5. **Missing plugins**: Don't forget @tailwindcss/forms and @tailwindcss/typography plugins

---
**Skill updated with correct import format from Segre.vip project commit.**
