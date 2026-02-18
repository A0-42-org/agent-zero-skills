# SvelteKit Start Workflow

Complete workflow for initializing a SvelteKit project with modern stack: Svelte 5 runes, SkeletonUI v4, Tailwind CSS v4, Drizzle ORM, and BetterAuth.

## Use Case

Use this workflow when:
- Creating a new SvelteKit project from scratch
- Initializing a project with modern Svelte 5 stack
- Setting up a complete SaaS-ready application
- Building a production-ready SvelteKit application
- Need a standardized, opinionated SvelteKit setup

## Workflow Overview

This workflow guides you through creating a complete SvelteKit project in 6 steps:

1. **Project Initialization** - Create SvelteKit project with PNPM
2. **SkeletonUI v4 Setup** - Configure SkeletonUI with Tailwind CSS v4
3. **Database Setup** - Configure Drizzle ORM with SQLite/PostgreSQL
4. **Authentication** - Set up BetterAuth for user authentication
5. **Core Features** - Add optional features (forms, components, etc.)
6. **Project Structure** - Create recommended project structure

## Prerequisites Skills

This workflow calls these skills conditionally based on your needs:
- `sveltekit/bootstrap` - Project initialization (ALWAYS)
- `sveltekit/skeleton-ui` - SkeletonUI v4 setup (ALWAYS)
- `sveltekit/database` - Drizzle ORM database (OPTIONAL)
- `sveltekit/better-auth` - BetterAuth authentication (OPTIONAL)
- `sveltekit/forms` - Form handling with Zod (OPTIONAL)
- `sveltekit/components` - Reusable components (OPTIONAL)
- `sveltekit/theming` - Theme management (OPTIONAL)

## Step-by-Step Guide

### Step 1: Project Initialization

#### 1.1 Create SvelteKit Project

```bash
# Create new SvelteKit project with all required tools
npx sv create --types ts --install pnpm --template minimal --add eslint prettier tailwind="plugins:typography,forms" mcp="ide:opencode" devtools-json my-app

cd my-app

# Install required packages for optional features
pnpm add drizzle-orm zod nanoid
pnpm add -D drizzle-kit

# Install database driver (choose one)
pnpm add postgres  # For PostgreSQL
# OR
pnpm add better-sqlite3  # For SQLite
```

#### 1.2 Configure Project

Update `svelte.config.js`:

```javascript
import adapter from '@sveltejs/adapter-auto';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: vitePreprocess(),
  kit: {
    adapter: adapter(),
  },
};

export default config;
```

### Step 2: SkeletonUI v4 Setup

#### 2.1 Configure Tailwind CSS v4

Update `tailwind.config.js`:

```javascript
import { skeleton } from '@skeletonlabs/tailwindcss-plugin';

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {},
  },
  plugins: [
    skeleton({ themes: ['modern'] })
  ],
};
```

#### 2.2 Configure PostCSS

Update `postcss.config.js`:

```javascript
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
```

#### 2.3 Configure CSS

Create `src/app.css`:

```css
@import 'tailwindcss';
```

Update `src/app.html`:

```html
<!DOCTYPE html>
<html lang="en" data-theme="winter">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%sveltekit.assets%/favicon.png" />
    <meta name="viewport" content="width=device-width" />
    %sveltekit.head%
  </head>
  <body data-sveltekit-preload-data="hover">
    <div style="display: contents">%sveltekit.body%</div>
  </body>
</html>
```

### Step 3: Database Setup (OPTIONAL)

#### 3.1 Configure Drizzle ORM

Create `src/lib/db/schema.ts`:

```typescript
import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('user', {
  id: text('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull().$defaultFn(() => new Date()),
});
```

Create `src/lib/db/index.ts`:

```typescript
import { drizzle } from 'drizzle-orm/better-sqlite3';
import Database from 'better-sqlite3';
import * as schema from './schema';

const sqlite = new Database('sqlite.db');
export const db = drizzle(sqlite, { schema });
```

#### 3.2 Configure Drizzle Kit

Create `drizzle.config.ts`:

```typescript
import type { Config } from 'drizzle-kit';

export default {
  schema: './src/lib/db/schema.ts',
  out: './drizzle',
  driver: 'better-sqlite',
  dbCredentials: {
    url: 'sqlite.db',
  },
} satisfies Config;
```

#### 3.3 Generate Database

```bash
# Generate migration
pnpm dlx drizzle-kit generate

# Apply migration
pnpm dlx drizzle-kit migrate
```

### Step 4: Authentication Setup (OPTIONAL)

#### 4.1 Install BetterAuth

```bash
pnpm add better-auth
```

#### 4.2 Configure BetterAuth

Create `src/lib/auth/index.ts`:

```typescript
import { betterAuth } from 'better-auth';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';
import { db } from '$lib/db';

export const auth = betterAuth({
  database: drizzleAdapter(db, {
    provider: 'sqlite',
  }),
  emailAndPassword: {
    enabled: true,
  },
});
```

#### 4.3 Configure Environment Variables

Create `.env`:

```env
DATABASE_URL=file:./sqlite.db
BETTER_AUTH_SECRET=$(openssl rand -base64 32)
BETTER_AUTH_URL=http://localhost:5173
```

### Step 5: Core Features (OPTIONAL)

#### 5.1 Add Form Handling

```bash
pnpm add zod sveltekit-superforms
```

Create `src/lib/forms/schema.ts`:

```typescript
import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});
```

#### 5.2 Add Reusable Components

Create `src/lib/components/ui/Button.svelte`:

```svelte
<script lang="ts">
  import type { Snippet } from 'svelte';

  interface Props {
    children: Snippet;
    variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
    size?: 'sm' | 'md' | 'lg';
    onclick?: () => void;
    type?: 'submit' | 'button' | 'reset';
    disabled?: boolean;
  }

  let { children, variant = 'primary', size = 'md', onclick, type = 'button', disabled = false }: Props = $props();

  const variantClasses: Record<string, string> = {
    primary: 'bg-blue-500 hover:bg-blue-600 text-white',
    secondary: 'bg-gray-200 hover:bg-gray-300 text-gray-800',
    ghost: 'hover:bg-gray-100 text-gray-700',
    danger: 'bg-red-500 hover:bg-red-600 text-white'
  };

  const sizeClasses: Record<string, string> = {
    sm: 'px-2 py-1 text-sm',
    md: 'px-4 py-2',
    lg: 'px-6 py-3 text-lg'
  };

  $: baseClasses = `${variantClasses[variant]} ${sizeClasses[size]} rounded transition-colors ${disabled ? 'opacity-50 cursor-not-allowed' : ''}`;
</script>

<button {type} {disabled} class={baseClasses} on:click={onclick}>
  {@render children()}
</button>
```

#### 5.3 Add Theme Management

Create `src/lib/components/ThemeProvider.svelte`:

```svelte
<script lang="ts">
  import { setContext, onMount } from 'svelte';
  import { browser } from '$app/environment';

  type Theme = 'modern' | 'cerberus' | 'rocket';

  interface ThemeContext {
    theme: Theme;
    setTheme: (theme: Theme) => void;
  }

  const THEMES: Theme[] = ['modern', 'cerberus', 'rocket'];

  let theme = $state<Theme>('modern');

  function setTheme(newTheme: Theme) {
    theme = newTheme;
    if (browser) {
      localStorage.setItem('theme', newTheme);
      document.documentElement.setAttribute('data-theme', newTheme);
    }
  }

  onMount(() => {
    if (browser) {
      const savedTheme = localStorage.getItem('theme') as Theme;
      if (savedTheme && THEMES.includes(savedTheme)) {
        setTheme(savedTheme);
      }
    }
  });

  setContext<ThemeContext>('theme', { theme, setTheme });
</script>

<slot />
```

### Step 6: Project Structure

#### 6.1 Recommended Structure

```
src/
├── routes/           # SvelteKit routes
│   ├── (app)/       # Layout routes
│   ├── (auth)/      # Authentication routes
│   └── api/         # API routes
├── lib/
│   ├── db/          # Database
│   │   ├── schema.ts
│   │   └── index.ts
│   ├── auth/        # Authentication
│   │   └── index.ts
│   ├── forms/       # Form schemas
│   │   └── schema.ts
│   ├── components/  # Reusable components
│   │   └── ui/
│   └── utils/       # Utility functions
├── app.css          # Global CSS
└── app.html         # HTML template
```

#### 6.2 Environment Variables

Create `.env.example`:

```env
# Database
DATABASE_URL=file:./sqlite.db

# BetterAuth
BETTER_AUTH_SECRET=your-secret-here
BETTER_AUTH_URL=http://localhost:5173

# App
APP_URL=http://localhost:5173
```

## Workflow Checklist

### Step 1: Project Initialization
- [ ] SvelteKit project created
- [ ] PNPM installed and configured
- [ ] SkeletonUI v4 installed
- [ ] Tailwind CSS v4 installed

### Step 2: SkeletonUI Setup
- [ ] Tailwind configured
- [ ] PostCSS configured
- [ ] CSS imports configured
- [ ] App shell configured

### Step 3: Database Setup (OPTIONAL)
- [ ] Drizzle ORM installed
- [ ] Database schema defined
- [ ] Drizzle kit configured
- [ ] Database migration generated and applied

### Step 4: Authentication Setup (OPTIONAL)
- [ ] BetterAuth installed
- [ ] Authentication configured
- [ ] Environment variables set

### Step 5: Core Features (OPTIONAL)
- [ ] Form handling configured (Zod)
- [ ] Reusable components created
- [ ] Theme management configured

### Step 6: Project Structure
- [ ] Recommended structure created
- [ ] Environment variables documented
- [ ] README created

## Common Pitfalls

### 1. Not Using Svelte 5 Runes
```svelte
<!-- ❌ BAD - Old syntax -->
<script>
  export let title = '';
  let value = 0;
  $: doubled = value * 2;
</script>

<!-- ✅ GOOD - Svelte 5 runes -->
<script lang="ts">
  interface Props {
    title?: string;
    value?: number;
  }

  let { title = '', value = 0 }: Props = $props();
  const doubled = $derived(value * 2);
</script>
```

### 2. Not Using Tailwind CSS v4
```css
/* ❌ BAD - Tailwind CSS v3 syntax */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* ✅ GOOD - Tailwind CSS v4 syntax */
@import 'tailwindcss';
```

### 3. Using Obsolete SkeletonUI Components
```svelte
<!-- ❌ BAD - Obsolete components -->
<AppCard>
  <h3 slot="header">Title</h3>
</AppCard>

<!-- ✅ GOOD - HTML + Tailwind CSS -->
<div class="border rounded-lg shadow p-6">
  <h1 class="text-xl font-bold mb-4">Title</h1>
  <p>Content goes here</p>
</div>
```

### 4. Not Using Server Actions
```typescript
// ❌ BAD - API routes
import { json } from '@sveltejs/kit';

export async function POST({ request }) {
  const data = await request.json();
  return json({ success: true });
}

// ✅ GOOD - Server actions
export const actions = {
  default: async ({ request }) => {
    const data = await request.formData();
    return { success: true };
  },
};
```

## Next Steps

After completing this workflow, you can:

1. **Add More Features** - Use other skills like `sveltekit/analytics`, `sveltekit/dnd-dashboard`, `sveltekit/tiptap`
2. **Create Components** - Build reusable components using `sveltekit/components` skill
3. **Add Forms** - Implement form handling with `sveltekit/forms` skill
4. **Add Theming** - Add theme management with `sveltekit/theming` skill
5. **Deploy** - Use `devops/dokploy` skill for deployment
6. **Add Git** - Use `devops/gh-cli` skill for Git/GitHub workflow

---
**Use this workflow to create complete, modern SvelteKit applications with Svelte 5 runes, SkeletonUI v4, Tailwind CSS v4, and optional database/authentication.**
