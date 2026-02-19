# Authentication Templates (Optional)

These templates provide authentication functionality for your dashboard.

## Installation

Install BetterAuth:
```bash
bun add better-auth
```

## Components

### AuthProvider.svelte
Provider component that wraps your app with authentication context.

### ProtectedRoute.svelte
Higher-order component that protects routes requiring authentication.

## Usage

### Step 1: Configure BetterAuth

Create `src/lib/auth.ts`:

```typescript
import { betterAuth } from 'better-auth';

export const auth = betterAuth({
  database: {
    db: {
      type: 'sqlite',
      url: process.env.DATABASE_URL,
    },
  },
});
```

### Step 2: Wrap your app with AuthProvider

In `src/routes/+layout.svelte`:

```svelte
<script lang="ts">
  import AuthProvider from '$lib/components/AuthProvider.svelte';
  import ThemeProvider from '$lib/components/ThemeProvider.svelte';
</script>

<ThemeProvider>
  <AuthProvider>
    <slot />
  </AuthProvider>
</ThemeProvider>
```

### Step 3: Protect routes

In `src/routes/dashboard/+page.svelte`:

```svelte
<script lang="ts">
  import ProtectedRoute from '$lib/components/ProtectedRoute.svelte';
</script>

<ProtectedRoute>
  <!-- Dashboard content here -->
</ProtectedRoute>
```

## Customization

You can customize authentication providers, password policies, and session management by modifying the BetterAuth configuration.

---
**Use these templates to add authentication to your dashboard.**
