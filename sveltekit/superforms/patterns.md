# SvelteKit Superforms - Patterns

Patterns de formulaire avancés avec Superforms.

## Patterns Disponibles

### 1. Login Form

```typescript
// src/lib/schemas.ts
import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  remember: z.boolean().optional()
});
```

```typescript
// src/routes/login/+page.server.ts
import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { fail, redirect } from '@sveltejs/kit';
import { loginSchema } from '$lib/schemas';

export const load = async () => {
  const form = await superValidate(zod(loginSchema));
  return { form };
};

export const actions = {
  default: async ({ request, cookies }) => {
    const form = await superValidate(request, zod(loginSchema));
    
    if (!form.valid) {
      return fail(400, { form });
    }
    
    // Authenticate user
    const user = await authenticateUser(form.data.email, form.data.password);
    
    if (form.data.remember) {
      cookies.set('session', user.token, {
        path: '/',
        maxAge: 60 * 60 * 24 * 30 // 30 days
      });
    } else {
      cookies.set('session', user.token, {
        path: '/',
        maxAge: 60 * 60 * 24 // 1 day
      });
    }
    
    throw redirect(302, '/dashboard');
  }
};
```

### 2. Signup Form

```typescript
// src/lib/schemas.ts
export const signupSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  confirmPassword: z.string()
}).refine(data => data.password === data.confirmPassword, {
  message: 'Passwords do not match',
  path: ['confirmPassword']
});
```

```typescript
// src/routes/signup/+page.server.ts
import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { fail } from '@sveltejs/kit';
import { signupSchema } from '$lib/schemas';

export const load = async () => {
  const form = await superValidate(zod(signupSchema));
  return { form };
};

export const actions = {
  default: async ({ request }) => {
    const form = await superValidate(request, zod(signupSchema));
    
    if (!form.valid) {
      return fail(400, { form });
    }
    
    // Create user
    await createUser({
      name: form.data.name,
      email: form.data.email,
      password: form.data.password
    });
    
    return { success: true, form };
  }
};
```

### 3. Multi-Step Wizard

```typescript
// src/lib/schemas.ts
export const step1Schema = z.object({
  firstName: z.string().min(2),
  lastName: z.string().min(2)
});

export const step2Schema = z.object({
  address: z.string().min(5),
  city: z.string().min(2),
  zipCode: z.string().regex(/^\d{5}$/)
});

export const step3Schema = z.object({
  termsAccepted: z.boolean().refine(val => val === true, {
    message: 'You must accept the terms'
  })
});
```

```svelte
<!-- src/routes/wizard/+page.svelte -->
<script lang="ts">
  import { superForm } from 'sveltekit-superforms';
  import { z } from 'zod';
  import { step1Schema, step2Schema, step3Schema } from '$lib/schemas';
  
  let { data } = $props();
  let currentStep = $state(1);
  
  const schemas = {
    1: step1Schema,
    2: step2Schema,
    3: step3Schema
  };
  
  const { form, errors, enhance, validate } = superForm(data.form, {
    validators: schemas,
    SPA: true,
    invalidateAll: false
  });
  
  async function nextStep() {
    const result = await validate();
    if (result.valid) {
      currentStep++;
    }
  }
  
  function prevStep() {
    currentStep--;
  }
</script>

{#if currentStep === 1}
  <h2>Personal Information</h2>
  <form method="POST">
    <label>First Name</label>
    <input name="firstName" bind:value={$form.firstName} />
    {#if $errors.firstName}<span class="error">{$errors.firstName}</span>{/if}
    
    <label>Last Name</label>
    <input name="lastName" bind:value={$form.lastName} />
    {#if $errors.lastName}<span class="error">{$errors.lastName}</span>{/if}
    
    <button type="button" on:click={nextStep}>Next</button>
  </form>
{/if}

{#if currentStep === 2}
  <h2>Address</h2>
  <form method="POST">
    <label>Address</label>
    <input name="address" bind:value={$form.address} />
    {#if $errors.address}<span class="error">{$errors.address}</span>{/if}
    
    <label>City</label>
    <input name="city" bind:value={$form.city} />
    {#if $errors.city}<span class="error">{$errors.city}</span>{/if}
    
    <button type="button" on:click={prevStep}>Previous</button>
    <button type="button" on:click={nextStep}>Next</button>
  </form>
{/if}

{#if currentStep === 3}
  <h2>Confirm</h2>
  <form method="POST" use:enhance>
    <label>
      <input type="checkbox" name="termsAccepted" bind:checked={$form.termsAccepted} />
      Accept terms
    </label>
    {#if $errors.termsAccepted}<span class="error">{$errors.termsAccepted}</span>{/if}
    
    <button type="button" on:click={prevStep}>Previous</button>
    <button type="submit">Submit</button>
  </form>
{/if}
```

### 4. Password Reset

```typescript
// src/lib/schemas.ts
export const requestResetSchema = z.object({
  email: z.string().email('Invalid email address')
});

export const resetPasswordSchema = z.object({
  token: z.string(),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  confirmPassword: z.string()
}).refine(data => data.password === data.confirmPassword, {
  message: 'Passwords do not match',
  path: ['confirmPassword']
});
```

```typescript
// src/routes/reset-password/[token]/+page.server.ts
import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { fail } from '@sveltejs/kit';
import { resetPasswordSchema } from '$lib/schemas';

export const load = async ({ params }) => {
  const form = await superValidate({ token: params.token }, zod(resetPasswordSchema));
  return { form };
};

export const actions = {
  default: async ({ request }) => {
    const form = await superValidate(request, zod(resetPasswordSchema));
    
    if (!form.valid) {
      return fail(400, { form });
    }
    
    await resetPassword(form.data.token, form.data.password);
    return { success: true, form };
  }
};
```

### 5. Profile Update

```typescript
// src/lib/schemas.ts
export const profileSchema = z.object({
  name: z.string().min(2).optional(),
  email: z.string().email().optional(),
  bio: z.string().max(500).optional(),
  avatar: z.any().optional()
});
```

```typescript
// src/routes/profile/+page.server.ts
import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { fail } from '@sveltejs/kit';
import { profileSchema } from '$lib/schemas';

export const load = async ({ locals }) => {
  const user = await getUser(locals.user.id);
  const form = await superValidate(user, zod(profileSchema));
  return { form };
};

export const actions = {
  default: async ({ request, locals }) => {
    const form = await superValidate(request, zod(profileSchema));
    
    if (!form.valid) {
      return fail(400, { form });
    }
    
    await updateUser(locals.user.id, form.data);
    return { success: true, form };
  }
};
```

## Utilisation

Voir le fichier SKILL.md pour la configuration de base.
