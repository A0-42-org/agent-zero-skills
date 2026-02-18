# AGENTS.md - Agent Zero Skills Repository

## Build, Lint, and Test Commands

Skills are self-contained. For SvelteKit projects use:
```bash
bun install              # Install dependencies
bun dev                  # Start dev server
bun build                # Build project
bun check                # TypeScript type check
bun lint                 # Code linting
bun format               # Code formatting
```

Single test execution:
```bash
bun test                 # Run all tests
bun test --filter <name> # Run specific test suite
bun test <path>          # Run tests in directory
```

Database commands (Drizzle ORM):
```bash
npx drizzle-kit generate  # Generate migration files
npx drizzle-kit push      # Apply migrations (dev)
npx drizzle-kit migrate   # Apply migrations (prod)
```

## Code Style Guidelines

### Svelte 5 Standards

- **Runes Mode**: Always use Svelte 5 runes syntax (`$props`, `$derived`, `$state`, `$effect`)
- **Props Definition**:
  ```svelte
  <script lang="ts">
    interface Props {
      title: string;
      value: number;
    }

    let { title, value }: Props = $props();
  </script>
  ```

- **Derived State**:
  ```svelte
  const formattedValue = $derived(`${value.toLocaleString()}`);
  ```

### TypeScript Conventions

- **Strict Mode**: Always use TypeScript in strict mode
- **Interface Naming**: Use `Props` for component props, `State` for reactive state
- **Type Annotations**: Explicit types for function parameters, return values, and state
- **No `any` Types**: Avoid using `any` - use `unknown` or specific types instead

### Import Organization

```typescript
// 1. External libraries (organized alphabetically)
import { AppCard } from '@skeletonlabs/skeleton-svelte';
import { createAuthClient } from 'better-auth/svelte';

// 2. Internal library modules (relative imports)
import { db } from '$lib/db';
import * as schema from '$lib/db/schema';
```

### Svelte Component Structure

```svelte
<script lang="ts">
  // Imports
  // Interface Props
  // Reactive state declarations
  // Helper functions
  // Event handlers
</script>

<!-- HTML markup -->
<div>Content</div>

<style>
  /* CSS in scoped style blocks */
  .component-class {
    /* styles */
  }
</style>
```

### Naming Conventions

- **Components**: PascalCase (e.g., `MetricCard.svelte`, `DataTable.svelte`)
- **Files**: PascalCase for components, camelCase for utilities (e.g., `authClient.ts`)
- **Functions**: camelCase
- **Constants**: UPPER_SNAKE_CASE
- **Type Interfaces**: PascalCase with specific suffixes:
  - `Props` for component props
  - `State` for state objects
  - `Config` for configuration objects
- **Directories**: kebab-case for routing, PascalCase for modules

### Environment Variables

**Critical in SvelteKit**: Never use `process.env` directly. Always use `$env/dynamic/private`:

```typescript
import { env } from '$env/dynamic/private';

const databaseUrl = env.DATABASE_URL;
```

### Error Handling

- **Try/Catch**: Always wrap async operations in try/catch blocks
- **Logging**: Use `console.log()` for debug info, consider structured logging in production
- **Error Boundaries**: Create Svelte error boundaries for React-like error handling
- **User Feedback**: Display error messages to users using loading states and notifications

### CSS Organization

- **Tailwind CSS v4**: Use utility classes for layout and styling
- **Custom CSS**: Use `<style>` blocks with scoped selectors
- **CSS Variables**: Use theme variables from Skeleton UI (e.g., `var(--color-surface-500)`)
- **Responsive**: Use Tailwind breakpoints (sm:, md:, lg:, xl:, 2xl:)
- **Dark Mode**: Use `dark:` prefix for dark mode variants

### Database and API

**Drizzle ORM**: Schema definitions in `src/lib/db/schema.ts`, migrations in `drizzle/` directory, always use `$lib/db` imports. Use parameterized queries to prevent SQL injection.

## Agent-Specific Guidelines

### For Svelte Agents

When working with Svelte/SvelteKit skills:

1. **Use the `@svelte` agent** by default for all Svelte projects
2. **SvelteKit 2 + TypeScript (strict mode)**
3. **Svelte 5 runes** (`$props`, `$derived`, `$state`, `$effect`)
4. **Skeleton UI v4 + Tailwind CSS v4**
5. **BetterAuth + Drizzle ORM**
6. **PostgreSQL (default) / SQLite (dev/tests)**

### Creating New Skills

1. Use the `create-skill` skill: `skills_tool:load({ skill_name: "create-skill" })`
2. Place in appropriate category directory: `core/`, `features/`, `patterns/`, or `workflows/`
3. Follow SKILL.md standard format
4. Test thoroughly

## Common Pitfalls

1. **React imports in SvelteKit**: Always use `better-auth/svelte`, never `better-auth/react`
2. **Environment variables**: Use `$env/dynamic/private`, NOT `process.env` in SvelteKit
3. **Schema ID types**: `user.id`, `session.userId`, `account.id`, `account.userId` MUST be `text`, not `serial`
4. **Never use any**: Avoid TypeScript `any` types
5. **Svelte 5 syntax**: Always use runes (`$props`, `$derived`, `$state`, `$effect`)
6. **SQL injection**: Always use parameterized queries
7. **Database migrations**: Don't forget to generate and run Drizzle migrations
