---
name: "sveltekit-server-actions"
description: "Server actions and progressive enhancement patterns for SvelteKit. Covers form actions, error handling, loading states, redirects, and best practices."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["sveltekit", "server-actions", "progressive-enhancement", "forms", "patterns"]
trigger_patterns:
  - "server action"
  - "progressive enhancement"
  - "form action"
  - "server-side form"
  - "action function"
  - "handle submit"
---

# SvelteKit Server Actions Pattern

Complete guide for building server actions with progressive enhancement, error handling, and loading states in SvelteKit.

## Use Case

Use this skill when:
- Creating form submissions (login, signup, settings)
- Implementing server-side data mutations
- Adding progressive enhancement (works without JavaScript)
- Building actions with loading states
- Handling errors and redirects
- Creating custom actions (not form-based)
- Managing action state and validation

## Server Actions Basics

### What Are Server Actions?

Server actions in SvelteKit are functions defined in `+page.server.ts` that handle form submissions and data mutations on the server.

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Server Actions** | Functions in `+page.server.ts` that handle POST requests |
| **Progressive Enhancement** | Forms work without JavaScript, enhanced with it |
| **Action Data** | Data passed from server to client after action runs |
| **Loading States** | Track submission status for better UX |
| **Error Handling** | Return validation errors and messages |

## Basic Server Action

### Simple Action Function

```typescript
// src/routes/login/+page.server.ts
import { fail, redirect } from '@sveltejs/kit';
import { db } from '$lib/db';
import { users } from '$lib/db/schema';
import { eq } from 'drizzle-orm';
import { hash } from '@node-rs/argon2';

export const actions = {
  default: async ({ request, cookies }) => {
    const formData = await request.formData();
    const email = formData.get('email') as string;
    const password = formData.get('password') as string;

    // Validate input
    if (!email || !password) {
      return fail(400, {
        error: 'Email and password are required'
      });
    }

    // Your business logic here...
    // 1. Find user
    // 2. Verify password
    // 3. Create session
    // 4. Set cookie

    
    // Redirect on success
    throw redirect(303, '/dashboard');
  }
};
```

### Named Actions

```typescript
// src/routes/settings/+page.server.ts
import { fail } from '@sveltejs/kit';
import { db } from '$lib/db';
import { users } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const actions = {
  updateProfile: async ({ request, locals }) => {
    if (!locals.user) {
      return fail(401, { error: 'Unauthorized' });
    }
    
    const formData = await request.formData();
    const name = formData.get('name') as string;
    const bio = formData.get('bio') as string;
    
    // Update profile
    await db.update(users)
      .set({ name, bio })
      .where(eq(users.id, locals.user.id));
    
    return { success: true, message: 'Profile updated' };
  },
  
  updateEmail: async ({ request, locals }) => {
    if (!locals.user) {
      return fail(401, { error: 'Unauthorized' });
    }
    
    const formData = await request.formData();
    const email = formData.get('email') as string;
    
    // Update email
    await db.update(users)
      .set({ email })
      .where(eq(users.id, locals.user.id));
    
    return { success: true, message: 'Email updated' };
  }
};
```

## Progressive Enhancement

### Basic Form (Works Without JavaScript)

```svelte
<!-- src/routes/login/+page.svelte -->
<script lang="ts">
  import type { ActionData, PageServerData } from './$types';
  
  let { form }: { form: ActionData } = $props();
</script>

<form method="POST">
  <input name="email" type="email" placeholder="Email" required />
  <input name="password" type="password" placeholder="Password" required />
  
  {#if form?.error}
    <p class="error">{form.error}</p>
  {/if}
  
  <button type="submit">Login</button>
</form>

<style>
  .error { color: red; }
</style>
```

### Enhanced Form (With JavaScript)

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  import type { ActionData, PageServerData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  
  // Loading state
  let isSubmitting = $state(false);
</script>

<form method="POST" use:enhance={() => {
    onsubmit: () => {
      isSubmitting = true;
    },
    onresult: () => {
      isSubmitting = false;
    }
  }}>
  <input name="email" type="email" placeholder="Email" required />
  <input name="password" type="password" placeholder="Password" required />
  
  {#if form?.error}
    <p class="error">{form.error}</p>
  {/if}
  
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Logging in...' : 'Login'}
  </button>
</form>

<style>
  .error { color: red; }
</style>
```

## Error Handling

### Validation Errors

```typescript
// src/routes/signup/+page.server.ts
import { fail } from '@sveltejs/kit';
import { z } from 'zod';

const signupSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'Password too short')
});

export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    const data = Object.fromEntries(formData);
    
    // Validate with Zod
    const result = signupSchema.safeParse(data);
    
    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors
      });
    }
    
    // Process valid data...
    return { success: true };
  }
};
```

### Displaying Errors

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  import type { ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let isSubmitting = $state(false);
  
  const errors = $derived(form?.errors || {});
  const hasErrors = $derived(
    Object.keys(errors).length > 0
  );
</script>

{#if hasErrors}
  <div class="alert alert-error">
    Please fix the errors below.
  </div>
{/if}

<form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
  <div class="form-group">
    <label for="email">Email</label>
    <input name="email" type="email" id="email" />
    {#if errors.email}
      <span class="error">{errors.email}</span>
    {/if}
  </div>
  
  <div class="form-group">
    <label for="password">Password</label>
    <input name="password" type="password" id="password" />
    {#if errors.password}
      <span class="error">{errors.password}</span>
    {/if}
  </div>
  
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Sign Up'}
  </button>
</form>

<style>
  .alert-error {
    padding: 0.5rem;
    background: #fee2e2;
    color: #dc2626;
    border-radius: 0.25rem;
    margin-bottom: 1rem;
  }
  .form-group {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    margin-bottom: 1rem;
  }
  .error {
    color: red;
    font-size: 0.875rem;
  }
</style>
```

## Loading States

### Basic Loading State

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  
  let isSubmitting = $state(false);
</script>

<form method="POST" use:enhance={() => {
    onsubmit: () => {
      isSubmitting = true;
    },
    onresult: () => {
      isSubmitting = false;
    }
  }}>
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Submit'}
  </button>
</form>
```

### Advanced Loading State with Loading Component

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
  
  let isSubmitting = $state(false);
</script>

<form method="POST" use:enhance={() => {
    onsubmit: () => {
      isSubmitting = true;
    },
    onresult: () => {
      isSubmitting = false;
    }
  }}>
  <!-- Form fields -->
  
  <button type="submit" disabled={isSubmitting}>
    {#if isSubmitting}
      <LoadingSpinner />
    {:else}
      Submit
    {/if}
  </button>
</form>
```
## Redirects

### After Successful Action

```typescript
// src/routes/login/+page.server.ts
import { redirect } from '@sveltejs/kit';

export const actions = {
  default: async ({ request, cookies }) => {
    // Process login...
    
    // Redirect on success
    throw redirect(303, '/dashboard');
  }
};
```

### Conditional Redirect

```typescript
// src/routes/create/+page.server.ts
import { redirect } from '@sveltejs/kit';
import { db } from '$lib/db';
import { pages } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const actions = {
  default: async ({ request, locals }) => {
    if (!locals.user) {
      throw redirect(303, '/login');
    }
    
    const formData = await request.formData();
    const title = formData.get('title') as string;
    
    // Create page
    const [page] = await db.insert(pages).values({
      userId: locals.user.id,
      title,
      slug: title.toLowerCase().replace(/\s+/g, '-')
    }).returning();
    
    // Redirect to new page
    throw redirect(303, `/editor/${page.id}`);
  }
};
```
## Action Data Types

### Define Action Data Type

```typescript
// src/routes/login/$types.d.ts
export interface ActionData {
  error?: string;
  errors?: Record<string, string[]>;
  success?: boolean;
  message?: string;
}
```

### Load Action Data

```typescript
// src/routes/login/+page.server.ts
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
  return {
    user: locals.user
  };
};

export const actions: Actions = {
  default: async ({ request, cookies }) => {
    // Action logic...
  }
};
```

### Use Action Data in Component

```svelte
<!-- src/routes/login/+page.svelte -->
<script lang="ts">
  import type { PageData, ActionData } from './$types';
  
  let { data, form }: { data: PageData; form: ActionData } = $props();
</script>

{#if form?.error}
  <div class="alert alert-error">{form.error}</div>
{/if}

{#if form?.success}
  <div class="alert alert-success">{form.message}</div>
{/if}
```

## Multiple Actions on Same Page

### Named Actions

```typescript
// src/routes/settings/+page.server.ts
import { fail } from '@sveltejs/kit';
import type { Actions } from './$types';

export const actions: Actions = {
  updateProfile: async ({ request, locals }) => {
    if (!locals.user) return fail(401, { error: 'Unauthorized' });
    
    const formData = await request.formData();
    const name = formData.get('name') as string;
    const bio = formData.get('bio') as string;
    
    // Update logic...
    
    return { success: true, message: 'Profile updated' };
  },
  
  deleteAccount: async ({ request, locals }) => {
    if (!locals.user) return fail(401, { error: 'Unauthorized' });
    
    const formData = await request.formData();
    const confirmation = formData.get('confirmation') as string;
    
    if (confirmation !== 'DELETE') {
      return fail(400, { error: 'Type DELETE to confirm' });
    }
    
    // Delete account logic...
    
    return { success: true, message: 'Account deleted' };
  }
};
```

### Multiple Forms with Named Actions

```svelte
<!-- src/routes/settings/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
  import type { ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let isSubmittingProfile = $state(false);
  let isSubmittingDelete = $state(false);
</script>

<!-- Profile Update Form -->
<form method="POST" action="?/updateProfile" use:enhance={() => {
    onsubmit: () => { isSubmittingProfile = true; },
    onresult: () => { isSubmittingProfile = false; }
  }}>
  <input name="name" type="text" placeholder="Name" />
  <textarea name="bio" placeholder="Bio"></textarea>
  <button type="submit" disabled={isSubmittingProfile}>
    {isSubmittingProfile ? 'Updating...' : 'Update Profile'}
  </button>
</form>

<!-- Delete Account Form -->
<form method="POST" action="?/deleteAccount" use:enhance={() => {
    onsubmit: () => { isSubmittingDelete = true; },
    onresult: () => { isSubmittingDelete = false; }
  }}>
  <input name="confirmation" type="text" placeholder="Type DELETE to confirm" />
  <button type="submit" disabled={isSubmittingDelete} class="btn-danger">
    {isSubmittingDelete ? 'Deleting...' : 'Delete Account'}
  </button>
</form>

<style>
  .btn-danger {
    background: #dc2626;
    color: white;
  }
</style>
```
## enhance() Action Hook

### enhance() Parameters

```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  
  // enhance() hook
  <form method="POST" use:enhance={form => ({
    // Called before form is submitted
    onsubmit: ({
      formData,
      formElement,
      controller,
      cancel
    }) => {
      console.log('Submitting...', formData);
      // Cancel submission: cancel();
    },
    
    // Called when result is available
    onresult: ({
      result,
      update,
      formData
    }) => {
      console.log('Result:', result);
      // Update form data: update(formData);
    },
    
    // Called on error
    onerror: ({
      error
    }) => {
      console.error('Error:', error);
    },
    
    // Use GET instead of POST (for non-mutating actions)
    applyAction: false
  })}>
  <button type="submit">Submit</button>
</form>
```

### Custom enhance() for File Upload
```svelte
<script lang="ts">
  import { enhance } from '$app/forms';
  
  let isUploading = $state(false);
  let uploadProgress = $state(0);
</script>

<form method="POST" action="?/upload" use:enhance={form => ({
    onsubmit: async ({ formData, controller }) => {
      isUploading = true;
      
      // Track upload progress
      const file = formData.get('file') as File;
      const xhr = new XMLHttpRequest();
      
      xhr.upload.addEventListener('progress', (e) => {
        uploadProgress = (e.loaded / e.total) * 100;
      });
      
      xhr.upload.addEventListener('loadend', () => {
        isUploading = false;
        uploadProgress = 0;
      });
      
      controller.abort(); // Cancel default submission
      
      await fetch(form.action, {
        method: 'POST',
        body: formData
      });
    }
  })}>
  <input name="file" type="file" />
  <button type="submit" disabled={isUploading}>
    {isUploading ? `Uploading ${uploadProgress}%` : 'Upload'}
  </button>
</form>
```

## Best Practices

### 1. Always Validate on Server-Side

```typescript
// ✅ GOOD - Server-side validation
export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    const email = formData.get('email') as string;
    
    if (!email || !email.includes('@')) {
      return fail(400, { error: 'Invalid email' });
    }
    
    // Process valid data...
  }
};

// ❌ BAD - No validation
export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    // Process without validation!
  }
};
```

### 2. Use Proper HTTP Status Codes

```typescript
// ✅ GOOD - Correct status codes
return fail(400, { error: 'Bad request' });  // Bad request
return fail(401, { error: 'Unauthorized' });  // Unauthorized
return fail(403, { error: 'Forbidden' });    // Forbidden
return fail(404, { error: 'Not found' });    // Not found

// ❌ BAD - Wrong status codes
return fail(200, { error: 'Bad request' });  // Should be 400
```

### 3. Always Return Error Messages

```typescript
// ✅ GOOD - Return error messages
return fail(400, {
  errors: {
    email: ['Invalid email address'],
    password: ['Password too short']
  }
});

// ❌ BAD - No error messages
return fail(400);
```

### 4. Use Progressive Enhancement

```svelte
<!-- ✅ GOOD - Works without JavaScript -->
<form method="POST" action="/submit">
  <button type="submit">Submit</button>
</form>

<!-- ❌ BAD - Doesn't work without JavaScript -->
<form onsubmit={handleSubmit}>
  <button type="submit">Submit</button>
</form>
```

### 5. Use enhance() for Client-Side Enhancement

```svelte
<!-- ✅ GOOD - Use enhance() -->
<form method="POST" use:enhance={() => { onsubmit: () => {...} }}>
  <button type="submit">Submit</button>
</form>

<!-- ❌ BAD - Manual fetch -->
<form onsubmit={async (e) => {
  e.preventDefault();
  await fetch('/submit', { method: 'POST', body: new FormData(e.target) });
}}>
  <button type="submit">Submit</button>
</form>
```

## Common Pitfalls

### 1. Not Validating on Server-Side
```typescript
// ❌ BAD - No validation
export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    // Process without validation!
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

### 2. Not Using Progressive Enhancement
```svelte
<!-- ❌ BAD - Doesn't work without JavaScript -->
<form onsubmit={handleSubmit}>
  <button type="submit">Submit</button>
</form>

<!-- ✅ GOOD - Works without JavaScript -->
<form method="POST" action="/submit" use:enhance={() => { onsubmit: () => {...} }}>
  <button type="submit">Submit</button>
</form>
```

### 3. Not Handling Errors Properly
```svelte
<!-- ❌ BAD - No error display -->
<form method="POST">
  <button type="submit">Submit</button>
</form>

<!-- ✅ GOOD - Show errors -->
<form method="POST">
  <button type="submit">Submit</button>
  {#if form?.error}
    <div class="error">{form.error}</div>
  {/if}
</form>
```

### 4. Not Providing Loading States
```svelte
<!-- ❌ BAD - No loading state -->
<form method="POST">
  <button type="submit">Submit</button>
</form>

<!-- ✅ GOOD - Show loading -->
<script lang="ts">
  let isSubmitting = $state(false);
</script>
<form method="POST" use:enhance={() => { onsubmit: () => { isSubmitting = true; } }}>
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Submit'}
  </button>
</form>
```

### 5. Using Wrong HTTP Methods
```typescript
// ❌ BAD - GET for mutations
export const actions = {
  default: async ({ url }) => {
    const id = url.searchParams.get('id');
    // Delete item with GET (DANGEROUS!)
    await db.delete(items).where(eq(items.id, id));
  }
};

// ✅ GOOD - POST/PUT/DELETE for mutations
export const actions = {
  delete: async ({ request }) => {
    const formData = await request.formData();
    const id = formData.get('id');
    // Delete item with POST
    await db.delete(items).where(eq(items.id, id));
  }
};
```
## Checklist

Before finishing a server action:

- [ ] Action defined in `+page.server.ts`
- [ ] Server-side validation implemented
- [ ] Proper HTTP status codes used
- [ ] Error messages returned
- [ ] Progressive enhancement enabled
- [ ] Loading states provided
- [ ] Redirects handled correctly
- [ ] Action types defined
- [ ] Form action attribute set
- [ ] CSRF protection enabled (SvelteKit default)

## Testing

After creating server actions, verify:

1. Form works without JavaScript
2. Server-side validation works
3. Error messages display correctly
4. Loading state shows during submission
5. Success message displays on completion
6. Redirect works (if applicable)
7. Form is accessible (labels, keyboard navigation)
8. CSRF protection enabled
9. Multiple named actions work
10. File uploads work (if applicable)

---
**Use this skill to create server actions with progressive enhancement, error handling, and loading states in SvelteKit.**
