# SvelteKit Bootstrap - Project Initialization

Complete setup for new SvelteKit projects with TypeScript, ESLint, Prettier, Tailwind CSS v4, Playwright.

## Installation

### Option 1: Create new project from scratch

```bash
# Create new SvelteKit project with TypeScript
pnpm dlx sv create my-project --template skeleton --types typescript

cd my-project

# Install dependencies
pnpm install
```

### Option 2: Initialize existing project

If you have an existing project, install required dependencies:

```bash
# Core dependencies
pnpm add -D @sveltejs/kit svelte

# TypeScript
pnpm add -D typescript tslib

# ESLint
pnpm add -D eslint eslint-config-prettier eslint-plugin-svelte eslint-plugin-node @typescript-eslint/eslint-plugin @typescript-eslint/parser

# Prettier
pnpm add -D prettier prettier-plugin-svelte prettier-plugin-tailwindcss

# Tailwind CSS v4
pnpm add -D tailwindcss

# Playwright
pnpm add -D @playwright/test
```

## Configuration Files

### 1. package.json

Ensure your package.json has the following scripts:

```json
{
  "name": "my-project",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "vite dev",
    "build": "vite build",
    "preview": "vite preview",
    "check": "svelte-kit sync && svelte-check --tsconfig ./tsconfig.json",
    "check:watch": "svelte-kit sync && svelte-check --tsconfig ./tsconfig.json --watch",
    "lint": "eslint .",
    "format": "prettier --write .",
    "test": "playwright test",
    "test:ui": "playwright test --ui"
  },
  "devDependencies": {
    "@playwright/test": "^1.28.0",
    "@sveltejs/kit": "^2.0.0",
    "@sveltejs/vite-plugin-svelte": "^4.0.0",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "eslint": "^8.0.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-svelte": "^2.0.0",
    "prettier": "^3.0.0",
    "prettier-plugin-svelte": "^3.0.0",
    "prettier-plugin-tailwindcss": "^0.6.0",
    "svelte": "^5.0.0",
    "svelte-check": "^4.0.0",
    "tailwindcss": "^4.0.0",
    "tslib": "^2.6.0",
    "typescript": "^5.5.0",
    "vite": "^6.0.0"
  },
  "type": "module"
}
```

### 2. tsconfig.json

```json
{
  "extends": "./.svelte-kit/tsconfig.json",
  "compilerOptions": {
    "allowJs": true,
    "checkJs": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "skipLibCheck": true,
    "sourceMap": true,
    "strict": true,
    "moduleResolution": "bundler",
    "target": "ESNext",
    "module": "ESNext"
  }
}
```

### 3. svelte.config.js

```javascript
import adapter from '@sveltejs/adapter-auto';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter(),
    alias: {
      $lib: './src/lib',
      $components: './src/lib/components',
      $utils: './src/lib/utils',
      $stores: './src/lib/stores'
    }
  }
};

export default config;
```

### 4. vite.config.ts

```typescript
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import tailwindcss from 'tailwindcss';

export default defineConfig({
  plugins: [
    sveltekit(),
    tailwindcss()
  ],
  server: {
    port: 5173,
    host: true
  }
});
```

### 5. .prettierrc

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "none",
  "printWidth": 80,
  "plugins": ["prettier-plugin-svelte", "prettier-plugin-tailwindcss"],
  "overrides": [
    {
      "files": "*.svelte",
      "options": {
        "parser": "svelte"
      }
    }
  ]
}
```

### 6. eslint.config.js

```javascript
import js from '@eslint/js';
import globals from 'globals';
import { includeIgnoreFile } from '@eslint/compat';
import svelte from 'eslint-plugin-svelte';
import svelteParser from 'svelte-eslint-parser';
import typescript from '@typescript-eslint/eslint-plugin';
import typescriptParser from '@typescript-eslint/parser';
import prettier from 'eslint-config-prettier';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const gitignorePath = path.resolve(__dirname, '.gitignore');

export default [
  includeIgnoreFile(gitignorePath),
  js.configs.recommended,
  ...svelte.configs['flat/recommended'],
  ...typescript.configs.recommended,
  prettier,
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2021
      },
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        parser: typescriptParser
      }
    },
    plugins: {
      '@typescript-eslint': typescript
    },
    rules: {
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'warn'
    },
    files: ['**/*.svelte'],
    languageOptions: {
      parser: svelteParser
    }
  },
  {
    files: ['**/*.js', '**/*.ts'],
    languageOptions: {
      parser: typescriptParser
    }
  },
  {
    ignores: ['build/', '.svelte-kit/', 'dist/']
  }
];
```

### 7. playwright.config.ts

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:5173',
    trace: 'on-first-retry'
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] }
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] }
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] }
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] }
    }
  ],
  webServer: {
    command: 'pnpm run dev',
    url: 'http://localhost:5173',
    reuseExistingServer: !process.env.CI
  }
});
```

## Git Configuration

### .gitignore

```
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# OS
.DS_Store
Thumbs.db

# Dependencies
node_modules
.pnp
.pnp.js

# Build outputs
.svelte-kit
build
dist

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.idea
*.swp
*.swo
*~

# Testing
coverage
.nyc_output

# Misc
.vercel
.netlify

# Database
*.db
*.sqlite
```

## Project Structure

```
my-project/
├── src/
│   ├── routes/
│   │   ├── +page.svelte
│   │   ├── +layout.svelte
│   │   └── layout.css
│   ├── lib/
│   │   ├── components/
│   │   ├── utils/
│   │   ├── stores/
│   │   └── index.ts
│   ├── app.html
│   └── app.d.ts
├── static/
├── tests/
├── .svelte-kit/
├── tsconfig.json
├── svelte.config.js
├── vite.config.ts
├── eslint.config.js
├── .prettierrc
├── .gitignore
├── package.json
└── README.md
```

## Testing

After setup, verify:

1. `pnpm check` passes (no TypeScript errors)
2. `pnpm lint` passes (no ESLint errors)
3. `pnpm format` works (no Prettier errors)
4. `pnpm dev` starts without errors
5. `pnpm test` runs Playwright tests
6. Browser loads at http://localhost:5173

## Common Pitfalls

1. **TypeScript errors**: Ensure tsconfig.json extends from .svelte-kit/tsconfig.json
2. **ESLint errors**: Check that parser options are correct for .svelte files
3. **Vite errors**: Ensure tailwindcss plugin is imported in vite.config.ts
4. **SvelteKit 2**: Use Svelte 5 runes syntax ($state, $derived, $props)
5. **Playwright**: Ensure webServer command matches your dev script

---
**Bootstrap skill created. Next steps: Load better-auth-svelte and skeleton-ui-svelte for complete setup.**
