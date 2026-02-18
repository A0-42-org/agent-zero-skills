# SvelteKit Superforms - Base

Configuration de base avec SvelteKit Superforms + Zod (OBLIGATOIRE).

## Installation

```bash
pnpm add -D sveltekit-superforms zod
```

## Configuration

### Step 1: Définir le Schema Zod

```typescript
// src/lib/schemas.ts
import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters')
});

export type LoginFormData = z.infer<typeof loginSchema>;
```

### Step 2: Configurer +page.server.ts

```typescript
// src/routes/login/+page.server.ts
import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { fail } from '@sveltejs/kit';
import { loginSchema } from '$lib/schemas';

export const load = async () => {
  const form = await superValidate(zod(loginSchema));
  return { form };
};

export const actions = {
  default: async ({ request }) => {
    const form = await superValidate(request, zod(loginSchema));
    
    if (!form.valid) {
      return fail(400, { form });
    }
    
    console.log('Valid data:', form.data);
    return { form };
  }
};
```

### Step 3: Afficher le formulaire

```svelte
<!-- src/routes/login/+page.svelte -->
<script lang="ts">
  import { superForm } from 'sveltekit-superforms';
  
  let { data } = $props();
  const { form, errors, enhance } = superForm(data.form);
</script>

<form method="POST">
  <label for="email">Email</label>
  <input 
    id="email" 
    name="email" 
    type="email" 
    bind:value={$form.email} 
  />
  {#if $errors.email}
    <div class="error">{$errors.email}</div>
  {/if}
  
  <label for="password">Password</label>
  <input 
    id="password" 
    name="password" 
    type="password" 
    bind:value={$form.password} 
  />
  {#if $errors.password}
    <div class="error">{$errors.password}</div>
  {/if}
  
  <button type="submit">Login</button>
</form>
```

## Fonctionnalités Clés

- ✅ Validation automatique avec Zod
- ✅ Messages d'erreur automatiques
- ✅ État réactif du formulaire
- ✅ Gestion des submissions
- ✅ Types TypeScript automatiques
