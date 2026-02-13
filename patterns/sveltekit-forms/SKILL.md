---
name: "sveltekit-forms"
description: "Form handling and validation patterns for SvelteKit. Covers Zod validation, server actions, error handling, progressive enhancement, and reusable form components."
version: "1.0.0"
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

Complete guide for building forms with validation, error handling, and server actions in SvelteKit.

## Use Case

Use this skill when:
- Creating forms with validation (login, signup, settings)
- Implementing server-side form processing
- Adding client-side validation with Zod
- Building reusable form components
- Handling form errors and success messages
- Implementing progressive enhancement (works without JS)
- Creating multi-step forms or wizards

## Installation

```bash
# Install Zod for validation
bun add zod

# Optional: Superforms for advanced form handling
bun add sveltekit-superforms
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
  <input name="email" type="email" placeholder="Email" />
  {#if errors.email}
    <span class="error">{errors.email}</span>
  {/if}
  
  <input name="password" type="password" placeholder="Password" />
  {#if errors.password}
    <span class="error">{errors.password}</span>
  {/if}
  
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Submit'}
  </button>
  
  {#if success}
    <p class="success">Form submitted successfully!</p>
  {/if}
</form>

<style>
  .error { color: red; font-size: 0.875rem; }
  .success { color: green; }
</style>
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
    errorMap: () => ({ message: 'You must accept the terms and conditions' })
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
  <input name="email" type="email" placeholder="Email" />
  {#if form?.errors?.email || clientErrors?.email}
    <span class="error">{form?.errors?.email || clientErrors?.email}</span>
  {/if}
  
  <input name="password" type="password" placeholder="Password" />
  {#if form?.errors?.password || clientErrors?.password}
    <span class="error">{form?.errors?.password || clientErrors?.password}</span>
  {/if}
  
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Login'}
  </button>
</form>

<style>
  .error { color: red; font-size: 0.875rem; }
</style>
```

## Reusable Form Components

### Input Field Component

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

<div class="input-field">
  {#if label}
    <label for={name}>
      {label}
      {#if required}
      <span class="required">*</span>
      {/if}
    </label>
  {/if}
  
  <input
    id={name}
    name={name}
    type={type}
    placeholder={placeholder}
    required={required}
    value={value}
    class:error={hasError}
  />
  
  {#if hasError}
    <span class="error-message">{errorMessage}</span>
  {/if}
</div>

<style>
  .input-field {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }
  .label {
    font-size: 0.875rem;
    font-weight: 500;
  }
  .required {
    color: red;
  }
  .input {
    padding: 0.5rem;
    border: 1px solid #e5e7eb;
    border-radius: 0.25rem;
  }
  .input.error {
    border-color: red;
  }
  .error-message {
    color: red;
    font-size: 0.75rem;
  }
</style>
```

### Form Component

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
  
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Submit'}
  </button>
  
  {#if success}
    <div class="success">{success}</div>
  {/if}
</form>

<style>
  .success {
    padding: 0.5rem;
    background: #d1fae5;
    color: #065f46;
    border-radius: 0.25rem;
  }
</style>
```

## Form Patterns

### Login Form

```svelte
<!-- src/routes/login/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
  import InputField from '$lib/components/InputField.svelte';
  import type { PageServerData, ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let isSubmitting = $state(false);
</script>

<div class="login-form">
  <h1>Login</h1>
  
  <form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
    <InputField
      name="email"
      label="Email"
      type="email"
      placeholder="your@email.com"
      required
      errors={form?.errors?.email}
    />
    
    <InputField
      name="password"
      label="Password"
      type="password"
      placeholder="•••••••••"
      required
      errors={form?.errors?.password}
    />
    
    <button type="submit" disabled={isSubmitting}>
      {isSubmitting ? 'Logging in...' : 'Login'}
    </button>
    
    {#if form?.success}
      <p class="success">Logged in successfully!</p>
    {/if}
  </form>
  
  <p>
    Don't have an account? <a href="/signup">Sign up</a>
  </p>
</div>

<style>
  .login-form {
    max-width: 24rem;
    margin: 2rem auto;
    padding: 1.5rem;
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
  }
  .success {
    color: green;
    padding: 0.5rem;
    background: #d1fae5;
    border-radius: 0.25rem;
  }
</style>
```

### Signup Form

```svelte
<!-- src/routes/signup/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms';
  import InputField from '$lib/components/InputField.svelte';
  import type { PageServerData, ActionData } from './$types';
  
  let { form }: { form: ActionData } = $props();
  let isSubmitting = $state(false);
  
  const passwordsMatch = $state(true);
</script>

<div class="signup-form">
  <h1>Sign Up</h1>
  
  <form method="POST" use:enhance={() => {
    onsubmit: () => { isSubmitting = true; },
    onresult: () => { isSubmitting = false; }
  }}>
    <InputField
      name="username"
      label="Username"
      placeholder="yourusername"
      required
      errors={form?.errors?.username}
    />
    
    <InputField
      name="email"
      label="Email"
      type="email"
      placeholder="your@email.com"
      required
      errors={form?.errors?.email}
    />
    
    <InputField
      name="password"
      label="Password"
      type="password"
      placeholder="•••••••••"
      required
      errors={form?.errors?.password}
    />
    
    <InputField
      name="confirmPassword"
      label="Confirm Password"
      type="password"
      placeholder="•••••••••"
      required
      errors={form?.errors?.confirmPassword}
    />
    
    <label class="checkbox-label">
      <input name="terms" type="checkbox" required />
      I agree to the terms and conditions
    </label>
    {#if form?.errors?.terms}
      <span class="error">{form.errors.terms[0]}</span>
    {/if}
    
    <button type="submit" disabled={isSubmitting}>
      {isSubmitting ? 'Creating account...' : 'Sign Up'}
    </button>
    
    {#if form?.success}
      <p class="success">Account created successfully!</p>
    {/if}
  </form>
  
  <p>
    Already have an account? <a href="/login">Login</a>
  </p>
</div>

<style>
  .signup-form {
    max-width: 24rem;
    margin: 2rem auto;
    padding: 1.5rem;
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
  }
  .checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
  }
  .success {
    color: green;
    padding: 0.5rem;
    background: #d1fae5;
    border-radius: 0.25rem;
  }
  .error {
    color: red;
    font-size: 0.75rem;
  }
</style>
```

## Error Handling

### Displaying Server Errors

```svelte
<script lang="ts">
  let { form }: { form: ActionData } = $props();
  
  const hasErrors = $derived(
    form?.errors && Object.keys(form.errors).length > 0
  );
  const globalError = $derived(form?.errors?.form?.[0]);
</script>

{#if globalError}
  <div class="alert alert-error">
    {globalError}
  </div>
{/if}

{#if hasErrors}
  <div class="alert alert-warning">
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
  <input name="email" type="email" required />
  <input name="password" type="password" required />
  <button type="submit">Login</button>
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
  <input name="email" type="email" required />
  <input name="password" type="password" required />
  <button type="submit" disabled={isSubmitting}>
    {isSubmitting ? 'Submitting...' : 'Login'}
  </button>
</form>
```

## Multi-Step Forms (Wizard)

### Wizard Component

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

<div class="wizard">
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
        <button type="button" onclick={prevStep}>Back</button>
      {/if}
      {#if currentStep < steps.length - 1}
        <button type="button" onclick={nextStep}>Next</button>
      {:else}
        <button type="submit">Create Page</button>
      {/if}
    </div>
  </form>
</div>

<style>
  .wizard {
    max-width: 32rem;
    margin: 0 auto;
    padding: 1.5rem;
  }
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

### 3. Use enhance() for Client-Side Enhancement

```svelte
<!-- ✅ GOOD -->
<form use:enhance={() => {
  onsubmit: () => { console.log('Submitting...'); },
  onresult: () => { console.log('Done!'); }
}}>
  <!-- Form fields -->
</form>

<!-- ❌ BAD - Manual fetch -->
<form onsubmit={handleSubmit}>
  <!-- Form fields -->
</form>
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
- [ ] Form tested with valid and invalid data


## Common Pitfalls

### 1. Not Validating on Server-Side
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
  <input name="email" />
</form>

<!-- ✅ GOOD - Show errors -->
<form method="POST">
  <input name="email" />
  {#if form?.errors?.email}
    <span class="error">{form.errors.email}</span>
  {/if}
</form>
```

### 4. Not Using enhance() for Client-Side Enhancement
```svelte
<!-- ❌ BAD - Manual fetch
<form onsubmit={async (e) => {
  e.preventDefault();
  const formData = new FormData(e.target);
  await fetch('/submit', { method: 'POST', body: formData });
}}>

<!-- ✅ GOOD - Use enhance() -->
<form method="POST" use:enhance={() => { onsubmit: () => {...} }}>
```

### 5. Not Providing Loading State
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

## Testing

After creating forms, verify:

1. Form works without JavaScript
2. Client-side validation works
3. Server-side validation works
4. Error messages display correctly
5. Loading state shows during submission
6. Success message displays on completion
7. Redirect works (if applicable)
8. Form is accessible (labels, keyboard navigation)
9. Password fields have proper type
10. CSRF protection enabled

---
**Use this skill to create forms with validation, error handling, and progressive enhancement in SvelteKit.**
