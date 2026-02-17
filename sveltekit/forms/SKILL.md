---
name: "sveltekit-forms"
description: "Form handling and validation patterns for SvelteKit. Covers Zod validation, server actions, error handling, progressive enhancement, and reusable form components."
version: "1.1.0"
author: "Agent Zero Team"
tags: ["sveltekit", "forms", "validation", "zod", "server-actions", "patterns"]
trigger_patterns:
  - "create form"
  - "form validation"
  - "zod form"
  - "server action form"
  - "form error handling"
  - "progressive enhancement"
---

# SvelteKit Forms Pattern

Complete guide for building forms with validation, error handling, and server actions in SvelteKit using Skeleton UI components.

## Use Case

Use this skill when:
- Creating forms with validation (login, signup, settings)
- Implementing server-side form processing
- Adding client-side validation with Zod
- Building reusable form components with Skeleton UI
- Handling form errors and success messages
- Implementing progressive enhancement (works without JS)
- Creating multi-step forms or wizards

## Installation

```bash
# Install Zod for validation
pnpm add zod

# Skeleton UI components are available via @skeletonlabs/skeleton-svelte
```

## Form Structure Template

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
    import type { ActionData } from './$types';

  // Form data interface
  interface FormData {
    email: string;
    password: string;
  }

  let { form }: { form: ActionData } = $props();
  
  // Form state
  let isSubmitting = $state(false);
  
  // Validation errors
  const errors = $derived(form?.errors || {});
  const success = $derived(form?.success);
</script>

<form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
  <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" placeholder="your@email.com" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  {#if errors.email}
    <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {errors.email}
</div>
  {/if}
  
  <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password" placeholder="•••••••••" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  {#if errors.password}
    <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Password Error</strong>
  {errors.password}
</div>
  {/if}
  
  <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
    {isSubmitting ? 'Submitting...' : 'Submit'}
  </button>
  
  {#if success}
    <div class="bg-green-50 border-green-200 text-green-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Success</strong>
  Form submitted successfully!
</div>
  {/if}
</form>
```

## Zod Validation

### Basic Validation Schema

```typescript
// src/lib/schemas.ts
import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters')
});

export type LoginFormData = z.infer<typeof loginSchema>;
```

### Advanced Validation Schema

```typescript
export const signupSchema = z.object({
  username: z
    .string()
    .min(3, 'Username must be at least 3 characters')
    .max(20, 'Username must be at most 20 characters')
    .regex(/^[a-zA-Z0-9_-]+$/, 'Username can only contain letters, numbers, hyphens, and underscores'),
  
  email: z.string().email('Invalid email address'),
  
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
    .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
    .regex(/[0-9]/, 'Password must contain at least one number'),
  
  confirmPassword: z.string(),
  
  terms: z.literal(true, {
    errorMap: () => ({ message: 'You must accept terms and conditions' })
  })
}).refine((data) => data.password === data.confirmPassword, {
  message: 'Passwords do not match',
  path: ['confirmPassword']
});

export type SignupFormData = z.infer<typeof signupSchema>;
```

### Server-Side Validation with Zod

```typescript
// src/routes/login/+page.server.ts
import { fail, redirect } from '@sveltejs/kit';
import { zod } from 'sveltekit-superforms';
import { loginSchema, type LoginFormData } from '$lib/schemas';

export const actions = {
  default: async ({ request, cookies }) => {
    const formData = await request.formData();
    const data = Object.fromEntries(formData) as unknown as LoginFormData;
    
    // Validate with Zod
    const result = loginSchema.safeParse(data);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors
      });
    }
    
    // Process valid data
    const { email, password } = result.data;
    
    // Your business logic here...
    
    return { success: true };
  }
};
```

## Server Actions

### Basic Server Action

```typescript
// src/routes/signup/+page.server.ts
import { fail } from '@sveltejs/kit';
import { signupSchema, type SignupFormData } from '$lib/schemas';
import { db } from '$lib/db';
import { users } from '$lib/db/schema';
import { eq } from 'drizzle-orm';
import { hash } from '@node-rs/argon2';

export const actions = {
  signup: async ({ request }) => {
    const formData = await request.formData();
    const data = Object.fromEntries(formData) as unknown as SignupFormData;
    
    // Validate
    const result = signupSchema.safeParse(data);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors
      });
    }
    
    const { username, email, password } = result.data;
    
    // Check if user exists
    const existingUser = await db.select().from(users).where(eq(users.email, email)).limit(1);
    
    if (existingUser.length > 0) {
      return fail(400, {
        errors: { email: ['Email already exists'] }
      });
    }
    
    // Hash password
    const passwordHash = await hash(password);
    
    // Create user
    await db.insert(users).values({
      username,
      email,
      passwordHash
    });
    
    return { success: true };
  }
};
```

### Server Action with Loading State

```typescript
// src/routes/settings/+page.server.ts
import { fail } from '@sveltejs/kit';
import { updateProfileSchema } from '$lib/schemas';
import { db } from '$lib/db';
import { users } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const actions = {
  updateProfile: async ({ request, locals }) => {
    if (!locals.user) {
      return fail(401, { errors: { form: ['Unauthorized'] } });
    }
    
    const formData = await request.formData();
    const data = Object.fromEntries(formData) as unknown as UpdateProfileFormData;
    
    // Validate
    const result = updateProfileSchema.safeParse(data);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors
      });
    }
    
    const { bio, avatarUrl } = result.data;
    
    // Update profile
    await db.update(users)
      .set({ bio, avatarUrl })
      .where(eq(users.id, locals.user.id));
    
    return { success: true, message: 'Profile updated successfully' };
  }
};
```

## Client-Side Validation

### Progressive Enhancement with enhance()

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  import { zodClient } from 'sveltekit-superforms';
    import { loginSchema, type LoginFormData } from '$lib/schemas';
  
  let { form }: { form: ActionData } = $props();
  
  // Form state
  let isSubmitting = $state(false);
  let clientErrors = $state<Record<string, string[]>>({});
  
  // Client-side validation
  function validateClient(formData: FormData) {
    const data = Object.fromEntries(formData) as unknown as LoginFormData;
    const result = loginSchema.safeParse(data);
    
    if (!result.success) {
      clientErrors = result.error.flatten().fieldErrors;
      return false;
    }
    
    clientErrors = {};
    return true;
  }
</script>

<form method="POST" use:enhance={() => {
    onsubmit: ({ formData }) => {
      if (!validateClient(formData)) {
        // Prevent submission if validation fails
        return;
      }
      isSubmitting = true;
    },
    onresult: () => {
      isSubmitting = false;
      clientErrors = {};
    }
  }}>
  <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" placeholder="your@email.com" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  {#if form?.errors?.email || clientErrors?.email}
    <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {form?.errors?.email || clientErrors?.email}
</div>
  {/if}
  
  <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password" placeholder="•••••••••" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  {#if form?.errors?.password || clientErrors?.password}
    <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Password Error</strong>
  {form?.errors?.password || clientErrors?.password}
</div>
  {/if}
  
  <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
    {isSubmitting ? 'Submitting...' : 'Login'}
  </button>
</form>
```

## Reusable Form Components

### Input Field Component with Skeleton UI

```svelte
<!-- src/lib/components/InputField.svelte -->
<script lang="ts">
    
  interface Props {
    name: string;
    label?: string;
    type?: string;
    placeholder?: string;
    required?: boolean;
    errors?: string[];
    value?: string;
  }
  
  let {
    name,
    label,
    type = 'text',
    placeholder,
    required = false,
    errors,
    value = ''
  }: Props = $props();
  
  const hasError = $derived(errors && errors.length > 0);
  const errorMessage = $derived(errors?.[0]);
</script>

<div>
  <div class="mb-4">
  <label for="input" class="block text-sm font-medium mb-1">Input</label>
  <input id="input" name="input" type="text"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  
  {#if hasError}
    <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Error</strong>
  {errorMessage}
</div>
  {/if}
</div>
```

### Form Component with Skeleton UI

```svelte
<!-- src/lib/components/Form.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
    import InputField from './InputField.svelte';
  import type { ActionData } from './$types';
  
  interface Props {
    action: string;
    method?: 'POST' | 'GET';
    form?: ActionData;
  }
  
  let { action, method = 'POST', form }: Props = $props();
  
  let isSubmitting = $state(false);
  const errors = $derived(form?.errors || {});
  const success = $derived(form?.success);
</script>

<form
  action={action}
  method={method}
  use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}
>
  {@render children?.(errors)}
  
  <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
    {isSubmitting ? 'Submitting...' : 'Submit'}
  </button>
  
  {#if success}
    <div class="bg-green-50 border-green-200 text-green-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Success</strong>
  {success}
</div>
  {/if}
</form>
```

## Form Patterns

### Login Form with Skeleton UI

```svelte
<!-- src/routes/login/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
    import type { PageServerData, ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let isSubmitting = $state(false);
</script>

<div class="border rounded-lg shadow p-6">
  <h1 class="text-xl font-bold mb-4">Login</h1><form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
    <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" placeholder="your@email.com"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.email}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {form.errors.email}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password" placeholder="•••••••••"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.password}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Password Error</strong>
  {form.errors.password}
</div>
    {/if}
    
    <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
      {isSubmitting ? 'Logging in...' : 'Login'}
    </button>
    
    {#if form?.success}
      <div class="bg-green-50 border-green-200 text-green-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Success</strong>
  Logged in successfully!
</div>
    {/if}
  </form>
  
  <p>
    Don't have an account? <a href="/signup">Sign up</a>
  </p>

<form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
    <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" placeholder="your@email.com"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.email}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {form.errors.email}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password" placeholder="•••••••••"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.password}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Password Error</strong>
  {form.errors.password}
</div>
    {/if}
    
    <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
      {isSubmitting ? 'Logging in...' : 'Login'}
    </button>
    
    {#if form?.success}
      <div class="bg-green-50 border-green-200 text-green-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Success</strong>
  Logged in successfully!
</div>
    {/if}
  </form>
  
  <p>
    Don't have an account? <a href="/signup">Sign up</a>
  </p>
</div>
```

### Signup Form with Skeleton UI

```svelte
<!-- src/routes/signup/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
    import type { PageServerData, ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let isSubmitting = $state(false);
  
  const passwordsMatch = $state(true);
</script>

<div class="border rounded-lg shadow p-6">
  <h1 class="text-xl font-bold mb-4">Sign Up</h1><form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
    <div class="mb-4">
  <label for="username" class="block text-sm font-medium mb-1">Username</label>
  <input id="username" name="username" type="text" placeholder="yourusername"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.username}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Username Error</strong>
  {form.errors.username}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" placeholder="your@email.com"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.email}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {form.errors.email}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password" placeholder="•••••••••"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.password}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Password Error</strong>
  {form.errors.password}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="confirmPassword" class="block text-sm font-medium mb-1">Confirm Password</label>
  <input id="confirmPassword" name="confirmPassword" type="password" placeholder="•••••••••"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.confirmPassword}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Confirm Password Error</strong>
  {form.errors.confirmPassword}
</div>
    {/if}
    
    <div class="mb-4">
  <label class="flex items-center">
    <input type="checkbox" name="terms"required class="rounded mr-2" />
    <span class="text-sm">I agree to terms and conditions</span>
  </label>
</div>
    {#if form?.errors?.terms}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Terms Error</strong>
  {form.errors.terms}
</div>
    {/if}
    
    <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
      {isSubmitting ? 'Creating account...' : 'Sign Up'}
    </button>
    
    {#if form?.success}
      <div class="bg-green-50 border-green-200 text-green-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Success</strong>
  Account created successfully!
</div>
    {/if}
  </form>
  
  <p>
    Already have an account? <a href="/login">Login</a>
  </p>

<form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
    <div class="mb-4">
  <label for="username" class="block text-sm font-medium mb-1">Username</label>
  <input id="username" name="username" type="text" placeholder="yourusername"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.username}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Username Error</strong>
  {form.errors.username}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" placeholder="your@email.com"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.email}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {form.errors.email}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password" placeholder="•••••••••"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.password}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Password Error</strong>
  {form.errors.password}
</div>
    {/if}
    
    <div class="mb-4">
  <label for="confirmPassword" class="block text-sm font-medium mb-1">Confirm Password</label>
  <input id="confirmPassword" name="confirmPassword" type="password" placeholder="•••••••••"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
    {#if form?.errors?.confirmPassword}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Confirm Password Error</strong>
  {form.errors.confirmPassword}
</div>
    {/if}
    
    <div class="mb-4">
  <label class="flex items-center">
    <input type="checkbox" name="terms"required class="rounded mr-2" />
    <span class="text-sm">I agree to terms and conditions</span>
  </label>
</div>
    {#if form?.errors?.terms}
      <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Terms Error</strong>
  {form.errors.terms}
</div>
    {/if}
    
    <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
      {isSubmitting ? 'Creating account...' : 'Sign Up'}
    </button>
    
    {#if form?.success}
      <div class="bg-green-50 border-green-200 text-green-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Success</strong>
  Account created successfully!
</div>
    {/if}
  </form>
  
  <p>
    Already have an account? <a href="/login">Login</a>
  </p>
</div>
```

## Error Handling with Skeleton UI

### Displaying Server Errors

```svelte
<script lang="ts">
    import type { ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  
  const hasErrors = $derived(
    form?.errors && Object.keys(form.errors).length > 0
  );
  const globalError = $derived(form?.errors?.form?.[0]);
</script>

{#if globalError}
  <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Error</strong>
  {globalError}
</div>
{/if}

{#if hasErrors}
  <div class="bg-yellow-50 border-yellow-200 text-yellow-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Warning</strong>
  Please fix the errors below.
</div>
{/if}
```

### Handling Redirect After Success

```typescript
// src/routes/login/+page.server.ts
import { fail, redirect } from '@sveltejs/kit';
import { loginSchema } from '$lib/schemas';

export const actions = {
  default: async ({ request, cookies }) => {
    const formData = await request.formData();
    const data = Object.fromEntries(formData);
    
    const result = loginSchema.safeParse(data);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors
      });
    }
    
    // Process login...
    
    // Redirect on success
    throw redirect(303, '/dashboard');
  }
};
```

## Progressive Enhancement

### Form Works Without JavaScript

The form should work without JavaScript:

```svelte
<form method="POST" action="/login">
  <!-- This works without JavaScript -->
  <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">Login</button>
</form>
```

### Enhanced with JavaScript

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
    
  let isSubmitting = $state(false);
</script>

<form method="POST" action="/login" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
  <!-- Enhanced with JavaScript -->
  <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  <div class="mb-4">
  <label for="password" class="block text-sm font-medium mb-1">Password</label>
  <input id="password" name="password" type="password"required class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  <button type="submit"disabled class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
    {isSubmitting ? 'Submitting...' : 'Login'}
  </button>
</form>
```

## Multi-Step Forms (Wizard)

### Wizard Component with Skeleton UI

```svelte
<!-- src/routes/create/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
    import type { PageServerData, ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let currentStep = $state(0);
  const steps = [
    'Profile',
    'Links',
    'Theme',
    'Review'
  ];
  
  function nextStep() {
    if (currentStep < steps.length - 1) {
      currentStep += 1;
    }
  }
  
  function prevStep() {
    if (currentStep > 0) {
      currentStep -= 1;
    }
  }
</script>

<div class="border rounded-lg shadow p-6">
<div class="steps">
    {#each steps as step, index}
      <div class="step" class:active={index === currentStep}>
        {step}
      </div>
    {/each}
  </div>
  
  <form method="POST" action="/create" use:enhance>
    {#if currentStep === 0}
      <!-- Profile step -->
    {:else if currentStep === 1}
      <!-- Links step -->
    {:else if currentStep === 2}
      <!-- Theme step -->
    {:else if currentStep === 3}
      <!-- Review step -->
    {/if}
    
    <div class="actions">
      {#if currentStep > 0}
        <button type="submit" class="border border-gray-300 text-gray-700 hover:bg-gray-50 px-4 py-2 rounded">Back</button>
      {/if}
      {#if currentStep < steps.length - 1}
        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">Next</button>
      {:else}
        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">Create Page</button>
      {/if}
    </div>
  </form>

</div>

<style>
  .steps {
    display: flex;
    justify-content: space-between;
    margin-bottom: 1.5rem;
  }
  .step {
    flex: 1;
    text-align: center;
    padding: 0.5rem;
    font-size: 0.875rem;
    color: #6b7280;
  }
  .step.active {
    font-weight: 600;
    color: #8b5cf6;
  }
  .actions {
    display: flex;
    justify-content: space-between;
    margin-top: 1.5rem;
  }
</style>
```

## Best Practices

### 1. Always Use Server-Side Validation

```typescript
// ✅ GOOD - Server-side validation
export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    const result = loginSchema.safeParse(formData);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors
      });
    }
    // Process valid data...
  }
};
```

### 2. Use Progressive Enhancement

```svelte
<!-- ✅ GOOD - Works without JavaScript -->
<form method="POST" action="/login">
  <!-- Form fields -->
</form>

<!-- Enhanced with JavaScript -->
<form method="POST" action="/login" use:enhance={() => { onsubmit: () => {...} }}>
  <!-- Form fields -->
</form>
```

### 3. Use Tailwind CSS for Styling

```svelte
<!-- ✅ GOOD - Use Skeleton UI components -->
<div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
<button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">Submit</button>
<div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Error</strong>
  Error message
</div>


<!-- ❌ BAD - Custom components -->
<input name="email" type="email" />
<button>Submit</button>
<div class="error">Error message</div>
```

### 4. Return Proper Error Responses

```typescript
// ✅ GOOD
return fail(400, {
  errors: {
    email: ['Invalid email address'],
    password: ['Password too short']
  }
});

// ❌ BAD
return fail(400, 'Invalid data');
```

## Form Checklist

Before finishing a form:

- [ ] Zod schema defined with proper validation
- [ ] Server action validates input with Zod
- [ ] Error messages are user-friendly
- [ ] Form works without JavaScript (progressive enhancement)
- [ ] Loading state on submission
- [ ] Success/redirect on completion
- [ ] Accessible labels for all inputs
- [ ] Password fields have proper type
- [ ] CSRF protection (handled by SvelteKit)
- [ ] Tailwind CSS styling for all form elements

## Common Pitfalls

### 1. Not Using Skeleton UI Components
```svelte
<!-- ❌ BAD - Custom components -->
<input name="email" type="email" class="custom-input" />
<div class="error">{form.errors.email}</div>

<!-- ✅ GOOD - Skeleton UI components -->
<div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
<div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Error</strong>
  {form.errors.email}
</div>
```

### 2. Not Validating on Server-Side
```typescript
// ❌ BAD - No validation
export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    // Process data directly without validation!
  }
};

// ✅ GOOD - Validate first
export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    const result = schema.safeParse(formData);
    if (!result.success) {
      return fail(400, { errors: result.error.flatten().fieldErrors });
    }
    // Process valid data...
  }
};
```

### 3. Not Using Progressive Enhancement
```svelte
<!-- ❌ BAD - Doesn't work without JavaScript -->
<form onsubmit={handleSubmit}>
  <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">Submit</button>
</form>

<!-- ✅ GOOD - Works without JavaScript -->
<form method="POST" action="/submit" use:enhance={() => { onsubmit: () => {...} }}>
  <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">Submit</button>
</form>
```

### 4. Not Handling Errors Properly
```svelte
<!-- ❌ BAD - No error display -->
<form method="POST">
  <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
</form>

<!-- ✅ GOOD - Show errors with Skeleton UI -->
<form method="POST">
  <div class="mb-4">
  <label for="email" class="block text-sm font-medium mb-1">Email</label>
  <input id="email" name="email" type="email" class="border border-gray-300 rounded px-3 py-2 w-full" />
</div>
  {#if form?.errors?.email}
    <div class="bg-red-50 border-red-200 text-red-700 border p-3 rounded">
  <strong class="block font-medium mb-1">Email Error</strong>
  {form.errors.email}
</div>
  {/if}
</form>
```

## Testing

After creating forms, verify:

1. Form works without JavaScript
2. Client-side validation works
3. Server-side validation works
4. Error messages display correctly with Skeleton UI
5. Loading state shows during submission
6. Success message displays on completion
7. Redirect works (if applicable)
8. Form is accessible (labels, keyboard navigation)
9. Password fields have proper type
10. CSRF protection enabled

---
**Use this skill to create forms with validation, error handling, and Skeleton UI components in SvelteKit.**
