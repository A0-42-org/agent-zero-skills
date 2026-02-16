# FontSource (Variable Fonts for SvelteKit)

FontSource skill for adding variable fonts to SvelteKit projects with Tailwind CSS and SkeletonUI. Use this skill when you need to add high-quality variable fonts to your project.

## Use Case

Use this skill when:
- Adding variable fonts to a SvelteKit project
- Configuring Tailwind CSS for custom fonts
- Using SkeletonUI with custom typography
- Building a project with multiple font families
- Need fonts for body text, headings, and code

## What is FontSource?

FontSource provides self-hostable variable fonts for the web. It's better than Google Fonts because:
- **Self-hostable** - No external requests to Google servers
- **Variable fonts** - Single file with all weights/styles
- **Better performance** - Faster loading with font-display: swap
- **Privacy** - No tracking from Google Fonts
- **Offline support** - Fonts work offline

## Popular FontSource Fonts

| Font | Package | Use Case | Weights |
|------|---------|-----------|---------|
| **Inter** | @fontsource-variable/inter | Body text, UI | 100-900 |
| **Space Grotesk** | @fontsource-variable/space-grotesk | Headings, Display | 300-700 |
| **Fira Code** | @fontsource-variable/fira-code | Code, Monospace | 300-700 |
| **Manrope** | @fontsource-variable/manrope | Subheadings | 200-800 |
| **Nunito** | @fontsource-variable/nunito | Friendly UI | 200-1000 |
| **JetBrains Mono** | @fontsource-variable/jetbrains-mono | Code | 100-800 |
| **Outfit** | @fontsource-variable/outfit | Modern Display | 100-900 |
| **Plus Jakarta Sans** | @fontsource-variable/plus-jakarta-sans | Modern UI | 200-800 |

## Installation

### Step 1: Install FontSource Packages

```bash
# Install individual fonts
pnpm add @fontsource-variable/inter @fontsource-variable/space-grotesk @fontsource-variable/fira-code

# Or install all commonly used fonts
pnpm add @fontsource-variable/inter @fontsource-variable/space-grotesk @fontsource-variable/fira-code @fontsource-variable/manrope @fontsource-variable/nunito
```

### Step 2: Import Fonts in CSS

Update `src/app.css`:

```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';

/* Import variable fonts */
@import "@fontsource-variable/inter/index.css";
@import "@fontsource-variable/space-grotesk/index.css";
@import "@fontsource-variable/fira-code/index.css";
@import "@fontsource-variable/manrope/index.css";
@import "@fontsource-variable/nunito/index.css";

/* Font families */
:root {
  --font-family-base: 'Inter Variable', sans-serif;
  --font-family-heading: 'Space Grotesk Variable', sans-serif;
  --font-family-code: 'Fira Code Variable', monospace;
  --font-family-subheading: 'Manrope Variable', sans-serif;
  --font-family-ui: 'Nunito Variable', sans-serif;
}
```

### Step 3: Configure Tailwind CSS

Update `tailwind.config.js`:

```javascript
import { skeleton } from '@skeletonlabs/tailwindcss-plugin';

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-family-base)', 'sans-serif'],
        heading: ['var(--font-family-heading)', 'sans-serif'],
        code: ['var(--font-family-code)', 'monospace'],
        subheading: ['var(--font-family-subheading)', 'sans-serif'],
        ui: ['var(--font-family-ui)', 'sans-serif'],
      },
    },
  },
  plugins: [
    skeleton({ themes: ['modern'] })
  ],
};
```

## Usage

### Basic Usage

```svelte
<!-- Body text -->
<p class="font-sans">This is body text with Inter font.</p>

<!-- Heading -->
<h1 class="font-heading">This is a heading with Space Grotesk font.</h1>

<!-- Code -->
<code class="font-code">const hello = 'world';</code>

<!-- Subheading -->
<h2 class="font-subheading">This is a subheading with Manrope font.</h2>

<!-- UI text -->
<button class="font-ui">Click me</button>
```

### Advanced Usage with CSS Variables

```svelte
<div class="custom-fonts">
  <h1 class="title">Custom Heading</h1>
  <p class="subtitle">Custom Subheading</p>
  <code class="font-code">const code = 'block';</code>
</div>

<style>
  .title {
    font-family: var(--font-family-heading);
    font-weight: 700;
  }
  .subtitle {
    font-family: var(--font-family-subheading);
    font-weight: 500;
  }
</style>
```

### Font Weights

Variable fonts support a range of weights. Use Tailwind's font-weight utilities:

```svelte
<!-- Thin -->
<p class="font-thin">Thin (100)</p>

<!-- Light -->
<p class="font-light">Light (300)</p>

<!-- Regular -->
<p class="font-normal">Regular (400)</p>

<!-- Medium -->
<p class="font-medium">Medium (500)</p>

<!-- Semibold -->
<p class="font-semibold">Semibold (600)</p>

<!-- Bold -->
<p class="font-bold">Bold (700)</p>

<!-- Extra Bold -->
<p class="font-extrabold">Extra Bold (800)</p>
```

## SkeletonUI Integration

### Configure SkeletonUI Font Variables

Update `src/app.css` with SkeletonUI font variables:

```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';

/* Import variable fonts */
@import "@fontsource-variable/inter/index.css";
@import "@fontsource-variable/space-grotesk/index.css";
@import "@fontsource-variable/fira-code/index.css";

/* Font families */
:root {
  --font-family-base: 'Inter Variable', sans-serif;
  --font-family-heading: 'Space Grotesk Variable', sans-serif;
  --font-family-code: 'Fira Code Variable', monospace;
}

/* SkeletonUI typography variables */
[data-theme='svelteForge'] {
  --base-font-family: var(--font-family-base);
  --heading-font-family: var(--font-family-heading);
  --base-font-weight: normal;
  --heading-font-weight: bold;
  --base-font-size: 1rem;
  --text-scaling: 1.067;
}
```

### Font Classes

Create font utility classes:

```css
.title {
  font-family: var(--font-family-heading) !important;
  font-weight: 700 !important;
}

.subtitle {
  font-family: var(--font-family-subheading) !important;
  font-weight: 500 !important;
}

.font-code {
  font-family: var(--font-family-code) !important;
}
```

## Performance Optimization

### Font Display Settings

Control how fonts load:

```css
@import "@fontsource-variable/inter/index.css";

/* Swap quickly */
@font-face {
  font-family: 'Inter Variable';
  font-display: swap; /* Quick swap */
}
```

Available `font-display` values:
- `auto` - Browser default
- `block` - Hidden until loaded
- `swap` - Quick swap with fallback
- `fallback` - Long timeout
- `optional` - Don't wait if not cached

### Subset Fonts (Optional)

For smaller font files, you can subset fonts (advanced):

```bash
# Install fonttools
pip install fonttools

# Subset font to include only Latin characters
pyftsubset Inter-Variable.ttf --text-file=latin.txt --output-file=Inter-Latin.ttf
```

## Best Practices

1. **Use variable fonts** - Single file with all weights/styles
2. **Self-host fonts** - No external requests
3. **Use font-display: swap** - Faster perceived performance
4. **Limit font families** - 2-3 font families max
5. **Use CSS variables** - Easier theming and maintenance
6. **Consider language support** - Include necessary character sets
7. **Test in different browsers** - Verify rendering consistency

## Common Issues

### Fonts not loading

1. Check if fonts are installed correctly:
```bash
ls node_modules/@fontsource-variable/
```

2. Verify CSS imports are correct:
```css
/* Correct */
@import "@fontsource-variable/inter/index.css";

/* Incorrect */
@import "@fontsource-variable/inter";
```

### Fonts not applying

1. Check Tailwind configuration:
```javascript
// Correct
fontFamily: {
  sans: ['var(--font-family-base)', 'sans-serif'],
}

// Incorrect
fontFamily: {
  sans: ['Inter', 'sans-serif'],
}
```

2. Check if CSS variables are defined:
```css
:root {
  --font-family-base: 'Inter Variable', sans-serif;
}
```

### Fonts looking different in browsers

1. Clear browser cache
2. Check font-face declarations
3. Verify font loading order
4. Test in multiple browsers

## Resources

- [FontSource Documentation](https://fontsource.org/docs/getting-started/install)
- [FontSource Fonts](https://fontsource.org/fonts)
- [Variable Fonts Guide](https://developer.chrome.com/docs/css/variable-fonts)
- [Tailwind CSS Typography](https://tailwindcss.com/docs/font-family)
- [SkeletonUI Typography](https://skeleton.dev/docs/styles/typography)

---
**Use this skill to add high-quality variable fonts to your SvelteKit project.**

**Version**: 1.0.0  
**Tags**: sveltekit, fonts, fontsource, variable-fonts, tailwind, typography, skeletonui  
**Triggers**: add fonts, fontsource, variable fonts, install fonts, typography, custom fonts, font setup, font configuration
