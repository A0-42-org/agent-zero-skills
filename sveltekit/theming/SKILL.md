# SvelteKit Theming

Complete theming system for SvelteKit projects using Skeleton UI v4 and Tailwind CSS v4.

## Use Case

Implement comprehensive theming with:
- Native Skeleton UI themes (cerberus, modern, rocket, etc.)
- Custom brand themes (luxury, neon, svelteforge, etc.)
- Theme switching with persistence
- Dark/light mode support
- Responsive theming
- CSS variables customization
- Theme provider with Svelte context


## Installation

```bash
# Skeleton UI is already installed with sveltekit-bootstrap skill
# No additional packages needed
```

## Skeleton UI Native Themes

### Preset Themes

Skeleton UI includes curated themes that you can use out of the box:

- cerberus - Dark luxury theme
- modern - Clean minimal light theme
- rocket - Bold vibrant theme
- And many more available themes...


### Theme Selection

Themes are activated via `data-theme` attribute on the HTML element:

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
    <div style="display:contents">%sveltekit.body%</div>
  </body>
</html>
```

### Theme Switching
```svelte
<!-- ThemeSelector.svelte -->
<script lang="ts">
  const themes = ["cerberus", "modern", "rocket", "neon", "luxury"];
  
  let theme = $state(browser ? localStorage.getItem("theme") || "cerberus" : "cerberus");
  
  function setTheme(t: string) {
    theme = t;
    if (browser) {
      document.documentElement.setAttribute("data-theme", t);
      localStorage.setItem("theme", t);
    }
  }
  
  // Apply saved theme on load
  if (browser) {
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme && themes.includes(savedTheme)) {
      setTheme(savedTheme);
    }
  }
</script>

<select bind:value={theme} onchange={(e) => setTheme(e.currentTarget.value)}>
  {#each themes as t}
    <option value={t}>{t}</option>
  {/each}
</select>
```

## Custom Brand Themes

### Creating Custom Themes

You can create custom themes using Skeleton UI\'s theme properties and CSS variables:

```css
/* src/lib/themes/brand-styles/luxury.css */
:root[data-theme="luxury"] {
  /* Primary Colors */
  --color-primary-500: #d4af37;
  --color-primary-foreground: #000000;
  
  /* Secondary Colors */
  --color-secondary-500: #f5f5dc;
  --color-secondary-foreground: #000000;
  
  /* Background */
  --color-background-950: #0a0a0a;
  --color-foreground: #ffffff;
  
  /* Glass Effect */
  --glass-bg: rgba(20, 20, 20, 0.8);
  --glass-border: rgba(255, 255, 255, 0.1);
  --glass-blur: 20px;
  
  /* Gradients */
  --gradient-primary: linear-gradient(135deg, #d4af37, #f5f5dc, #ffd700);
  
  /* Fonts */
  --font-body: "Playfair Display", "Georgia", serif;
  --font-heading: "Cormorant Garamond", "Georgia", serif;
}

/* Glassmorphism utility */
.glass {
  background: var(--glass-bg);
  backdrop-filter: blur(var(--glass-blur));
  -webkit-backdrop-filter: blur(var(--glass-blur));
  border: 1px solid var(--glass-border);
}

/* Gradient text */
.gradient-text {
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}
```

### Integrating Custom Themes

Import custom theme CSS files in your layout:

```css
/* src/routes/layout.css */
@import "tailwindcss";
@plugin "@tailwindcss/forms";
@plugin "@tailwindcss/typography";

@import "@skeletonlabs/skeleton";
@import "@skeletonlabs/skeleton-svelte";

/* Import custom brand styles */
@import "../lib/themes/brand-styles/luxury.css";
@import "../lib/themes/brand-styles/neon.css";
@import "../lib/themes/brand-styles/svelteforge.css";
```

## Theme Provider Pattern

### Svelte Context Approach

```svelte
<!-- ThemeProvider.svelte -->
<script lang="ts">
  import { setContext } from "svelte";
  import { browser } from "$app/environment";
  
  const themes = ["cerberus", "modern", "rocket", "luxury", "neon"];
  
  interface ThemeContext {
    get theme(): string;
    setTheme(theme: string): void;
    themes: string[];
  }
  
  let theme = $state(browser ? localStorage.getItem("theme") || "cerberus" : "cerberus");
  
  function setTheme(t: string) {
    theme = t;
    if (browser) {
      document.documentElement.setAttribute("data-theme", t);
      localStorage.setItem("theme", t);
    }
  }
  
  // Initialize theme on load
  if (browser) {
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme && themes.includes(savedTheme)) {
      setTheme(savedTheme);
    }
  }
  
  setContext("theme", {
    get theme() { return theme; },
    setTheme,
    themes
  });
</script>

<slot />
```

### Using Theme in Components

```svelte
<!-- In child components -->
<script lang="ts">
  import { getContext } from "svelte";
  
  const theme = getContext("theme");
</script>

<div class="bg-primary-500 text-white">
  Current theme: {theme.theme}
</div>
```

## CSS Variables Reference

### Color Properties

Skeleton UI uses the `@theme` directive to define theme properties:

```css
/* Primary colors */
--color-primary-50 to --color-primary-950
--color-primary-contrast-50 to --color-primary-contrast-950


/* Secondary colors */
--color-secondary-50 to --color-secondary-950
--color-secondary-contrast-50 to --color-secondary-contrast-950


/* Neutral/Surface colors */
--color-surface-50-950
--color-surface-contrast-50-950


/* Background colors */
--body-background-color
--body-background-color-dark
```

### Using Theme Properties in Tailwind

```svelte
<!-- You can use theme properties as Tailwind arbitrary values -->
<div class="bg-[var(--color-primary-500)] text-[var(--color-primary-foreground)]">
  Primary color background
</div>

<div class="border-[var(--color-surface-200-800)]">
  Surface border
</div>
```

### Spacing Properties

```css
--spacing: 1rem; /* Base spacing multiplier */
```

### Typography Properties

```css
/* Base typography */
--base-font-color
--base-font-color-dark
--base-font-family
--base-font-size
--base-line-height
--base-font-weight
--base-font-style
--base-letter-spacing


/* Heading typography */
--heading-font-color
--heading-font-color-dark
--heading-font-family
--heading-font-size
--heading-line-height
--heading-font-weight
--heading-font-style
--heading-letter-spacing


/* Anchor/link typography */
--anchor-font-color
--anchor-font-color-dark
--anchor-font-family
--anchor-font-size
--anchor-line-height
--anchor-font-weight
--anchor-font-style
--anchor-letter-spacing
--anchor-text-decoration
--anchor-text-decoration-active
--anchor-text-decoration-focus
--anchor-text-decoration-hover
```

### Radius Properties

```css
--radius-base: 0.5rem;
--radius-container: 1rem;
```

## Dark Mode with Skeleton UI

### System Mode (Default)

Uses CSS `prefers-color-scheme` to match OS settings:

```html
<!-- In app.html -->
<html data-mode="system">
```

### Manual Mode Selection

```html
<!-- Toggle between light and dark -->
<html data-mode="dark">
```

### Using Dark Variant

```css
/* Apply different styles for dark mode */
@variant dark (&:where([data-mode=dark], .dark)) {
  --color-background-950: #0a0a0a;
  --color-foreground: #ffffff;
}

@variant light (&:where([data-mode=light], .light)) {
  --color-background-950: #ffffff;
  --color-foreground: #000000;
}
```

## Color Pairing

Skeleton UI supports color pairing between light and dark modes:

```css
/* These colors automatically adapt based on mode */
--color-primary-50-950-shade-50
--color-primary-50-950-shade-100
--color-primary-50-950-shade-200
/* ... */
```

## Theme Variants

### Per-Theme Styling

You can style elements differently per theme:

```css
/* Apply different background for cerberus theme */
.theme-cerberus .card {
  background: #1a1a1a;
}

/* Apply different background for neon theme */
.theme-neon .card {
  background: #0a0a0a;
}
```

### Component Theme Styling

```svelte
<!-- Use Tailwind arbitrary values with theme properties -->
<Card class="bg-[var(--color-surface-100-900)] theme-cerberus:bg-red-500">
  Content
</Card>
```

## Custom Theme Examples

### Luxury Theme

```css
:root[data-theme="luxury"] {
  /* Gold accents */
  --color-primary-500: #d4af37;
  --color-primary-foreground: #000000;
  
  /* Dark background */
  --color-background-950: #050505;
  --color-foreground: #f5f5dc;
  
  /* Glass effect */
  --glass-bg: rgba(20, 20, 20, 0.85);
  --glass-border: rgba(212, 175, 55, 0.2);
  --glass-blur: 24px;
  
  /* Elegant fonts */
  --font-body: "Playfair Display", serif;
  --font-heading: "Cormorant Garamond", serif;
}
```

### Neon Theme

```css
:root[data-theme="neon"] {
  /* Bright primary */
  --color-primary-500: #ff00ff;
  --color-primary-foreground: #000000;
  
  /* Vibrant secondary */
  --color-secondary-500: #00ffff;
  --color-secondary-foreground: #000000;
  
  /* Dark background */
  --color-background-950: #000000;
  --color-foreground: #ffffff;
  
  /* Neon effects */
  --neon-glow: 0 0 10px var(--color-primary-500), 0 0 20px var(--color-primary-500);
  --neon-text-glow: 0 0 5px var(--color-primary-500), 0 0 10px var(--color-primary-500);
  
  /* Modern fonts */
  --font-body: "Orbitron", sans-serif;
  --font-heading: "Rajdhani", sans-serif;
}

/* Neon glow utilities */
.neon-glow {
  box-shadow: var(--neon-glow);
}

.neon-text-glow {
  text-shadow: var(--neon-text-glow);
}
```

### SvelteForge Theme

```css
:root[data-theme="svelteforge"] {
  /* Svelte orange */
  --color-primary-500: #ff3e00;
  --color-primary-foreground: #000000;
  
  /* Dark background */
  --color-background-950: #0f0f0f;
  --color-foreground: #ffffff;
  
  /* Subtle borders */
  --glass-border: rgba(255, 62, 0, 0.15);
  --glass-blur: 16px;
  
  /* Tech fonts */
  --font-body: system-ui, sans-serif;
  --font-heading: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}
```

## Skeleton UI Component Theming

### Using Theme Properties with Components

Skeleton components automatically use theme properties:

```svelte
<!-- Button with theme-aware colors -->
<AppButton variant="filled">
  Click me
</AppButton>

<!-- Card with surface color -->
<Card class="bg-surface-100-900">
  Content
</Card>
```

### Custom Component Styling

```svelte
<!-- Override component styles with CSS variables -->
<style>
  :root[data-theme="luxury"] .custom-card {
    background: var(--color-primary-500);
  }
</style>

<div class="custom-card">Luxury styled card</div>
```

## Best Practices

### CSS Organization

```
src/routes/
├── layout.css           # Global styles and theme imports
└── +layout.svelte         # Root layout with ThemeProvider
```

### Theme Switching Best Practices

1. Use `localStorage` for persistence
2. Apply theme on `document.documentElement`
3. Handle initial load to prevent FOUC (Flash of Unstyled Content)
4. Use Svelte 5 runes (`$state`) for reactive theme state
5. Provide theme context for child components

### Performance Considerations

1. Minimize CSS variables to improve performance
2. Use CSS custom properties for dynamic values
3. Avoid inline styles - use CSS classes
4. Leverage Tailwind CSS JIT compilation
5. Use `prefers-color-scheme` for system defaults

## Common Pitfalls

1. **Wrong import order**: Must follow: tailwindcss → plugins → skeleton → skeleton-svelte → custom themes
2. **Missing data-theme**: Theme won\'t apply without `data-theme` attribute on HTML
3. **CSS variable naming**: Must use Skeleton UI\'s property naming convention (`--color-primary-500`)
4. **TypeScript errors**: Ensure CSS variables are properly typed if using strict mode
5. **FOUC issue**: Always set initial theme on page load to prevent flash
6. **Not updating DOM**: Must set `data-theme` on `document.documentElement`, not just `body`
7. **Broken theme persistence**: Use `localStorage` properly with fallback to default

## Testing

After setup, verify:

1. `bun check` passes (no TypeScript errors)
2. Dev server starts without errors
3. Theme switching works (all themes apply correctly)
4. Theme persists across page refreshes
5. Dark/light mode toggles correctly
6. CSS variables are accessible in browser DevTools
7. Custom brand styles load after Skeleton UI imports
8. Responsive theming works on mobile/tablet/desktop

---
**Use this skill to implement comprehensive theming with Skeleton UI v4 and Tailwind CSS v4.**
