---
name: design-system
description: Extract design tokens from HTML/CSS and create a complete, reusable design system with Tailwind CSS and CSS custom properties
version: 1.0.0
author: OpenCode Team
tags:
  - design-system
  - design-tokens
  - tailwind
  - theming
  - sveltekit
trigger_patterns:
  - extract design system
  - create design system
  - design tokens
  - theme from html
---

# Design System Generator

Extract design tokens from existing HTML/CSS and generate a complete, reusable design system for SvelteKit projects.

## Usage

```
Use design-system skill to extract tokens from this landing page
```

## What Gets Extracted

### 1. Color Tokens

```css
:root {
  /* Primary */
  --color-primary-50: #eff6ff;
  --color-primary-100: #dbeafe;
  --color-primary-500: #3b82f6;
  --color-primary-600: #2563eb;
  --color-primary-900: #1e3a8a;

  /* Neutral */
  --color-neutral-50: #fafafa;
  --color-neutral-100: #f5f5f5;
  --color-neutral-900: #171717;

  /* Semantic */
  --color-success: #22c55e;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
}
```

### 2. Typography Tokens

```css
:root {
  /* Font Families */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', monospace;

  /* Font Sizes */
  --text-xs: 0.75rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 1.875rem;
  --text-4xl: 2.25rem;

  /* Line Heights */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.625;

  /* Font Weights */
  --font-normal: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;
}
```

### 3. Spacing Tokens

```css
:root {
  --space-0: 0;
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-12: 3rem;
  --space-16: 4rem;
  --space-24: 6rem;
}
```

### 4. Border Radius Tokens

```css
:root {
  --radius-sm: 0.25rem;
  --radius-md: 0.375rem;
  --radius-lg: 0.5rem;
  --radius-xl: 0.75rem;
  --radius-2xl: 1rem;
  --radius-full: 9999px;
}
```

### 5. Shadow Tokens

```css
:root {
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
  --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
}
```

### 6. Animation Tokens

```css
:root {
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 500ms;
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
}
```

## Tailwind Configuration

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: 'var(--color-primary-50)',
          100: 'var(--color-primary-100)',
          500: 'var(--color-primary-500)',
          600: 'var(--color-primary-600)',
          900: 'var(--color-primary-900)',
        },
        neutral: {
          50: 'var(--color-neutral-50)',
          100: 'var(--color-neutral-100)',
          900: 'var(--color-neutral-900)',
        },
      },
      fontFamily: {
        sans: ['var(--font-sans)'],
        mono: ['var(--font-mono)'],
      },
    },
  },
};

export default config;
```

## Output Files

### 1. `src/lib/styles/tokens.css`
All CSS custom properties

### 2. `src/lib/styles/theme.css`
Theme-specific overrides (light/dark)

### 3. `tailwind.config.ts`
Tailwind configuration with tokens

### 4. `src/lib/styles/README.md`
Documentation for design system

## Dark Mode Support

```css
/* src/lib/styles/theme.css */
:root {
  --color-bg: var(--color-neutral-50);
  --color-text: var(--color-neutral-900);
}

.dark {
  --color-bg: var(--color-neutral-900);
  --color-text: var(--color-neutral-50);
}
```

## Integration with SvelteKit

```svelte
<!-- src/app.html -->
<script lang="ts">
  import '../lib/styles/tokens.css';
  import '../lib/styles/theme.css';
</script>
```

## Usage in Components

```svelte
<button class="bg-primary-500 text-white px-4 py-2 rounded-lg shadow-md">
  Click me
</button>

<style>
  button {
    background: var(--color-primary-500);
    color: white;
    padding: var(--space-4);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-md);
  }
</style>
```

## Tips

1. **Extract from real designs** - Use actual project colors/spacing
2. **Use CSS variables** - Enables theming and dark mode
3. **Document usage** - Add examples in README
4. **Keep it DRY** - Don't duplicate Tailwind defaults
5. **Test dark mode** - Verify contrast ratios
