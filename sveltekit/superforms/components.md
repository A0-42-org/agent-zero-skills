# SvelteKit Superforms - Components

Composants de formulaire réutilisables avec Superforms.

## Components

### InputField

Composant de champ de saisie réutilisable avec validation.

```svelte
<!-- src/lib/components/forms/InputField.svelte -->
<script lang="ts">
  let { name, label, type = 'text', placeholder = '', value, errors } = $props();
  
  const id = `field-${name}`;
</script>

<div class="form-field">
  {#if label}
    <label for={id}>{label}</label>
  {/if}
  
  <input 
    id={id} 
    name={name} 
    type={type} 
    placeholder={placeholder} 
    bind:value={value} 
    class:has-error={errors?.[name]}
  />
  
  {#if errors?.[name]}
    <span class="error-message">{errors[name]}</span>
  {/if}
</div>

<style>
  .form-field {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  label {
    font-weight: 500;
    font-size: 0.875rem;
  }
  
  input {
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 0.25rem;
  }
  
  input.has-error {
    border-color: #ef4444;
  }
  
  .error-message {
    color: #ef4444;
    font-size: 0.875rem;
  }
</style>
```

**Utilisation:**

```svelte
<script lang="ts">
  import InputField from '$lib/components/forms/InputField.svelte';
  import { superForm } from 'sveltekit-superforms';
  
  let { data } = $props();
  const { form, errors } = superForm(data.form);
</script>

<form method="POST">
  <InputField 
    name="email" 
    label="Email" 
    type="email" 
    placeholder="you@example.com"
    value={$form.email}
    errors={$errors}
  />
  
  <InputField 
    name="password" 
    label="Password" 
    type="password"
    value={$form.password}
    errors={$errors}
  />
  
  <button type="submit">Submit</button>
</form>
```

### Form

Composant de formulaire principal avec gestion des états.

```svelte
<!-- src/lib/components/forms/Form.svelte -->
<script lang="ts">
  import { superForm, type FormResult } from 'sveltekit-superforms';
  
  let { 
    form: dataForm,
    children,
    resetForm = false
  } = $props();
  
  const { 
    form, 
    errors, 
    enhance, 
    constraints, 
    tainted, 
    message, 
    formElement, 
    submitting 
  } = superForm(dataForm, {
    resetForm
  });
</script>

<form use:enhance class:submitting={$submitting}>
  {@render children({
    form: $form,
    errors: $errors,
    constraints: $constraints,
    tainted: $tainted,
    message: $message,
    submitting: $submitting
  })}
</form>

<style>
  form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }
  
  form.submitting {
    opacity: 0.5;
    pointer-events: none;
  }
</style>
```

**Utilisation:**

```svelte
<script lang="ts">
  import Form from '$lib/components/forms/Form.svelte';
  import InputField from '$lib/components/forms/InputField.svelte';
</script>

<Form form={data.form}>
  {#snippet children({ form, errors, submitting })}
    <InputField 
      name="email" 
      label="Email" 
      type="email"
      value={form.email}
      errors={errors}
    />
    
    <InputField 
      name="password" 
      label="Password" 
      type="password"
      value={form.password}
      errors={errors}
    />
    
    <button type="submit" disabled={submitting}>
      {submitting ? 'Submitting...' : 'Submit'}
    </button>
  {/snippet}
</Form>
```

### Checkbox

Composant de case à cocher.

```svelte
<!-- src/lib/components/forms/Checkbox.svelte -->
<script lang="ts">
  let { name, label, checked, errors } = $props();
  
  const id = `checkbox-${name}`;
</script>

<div class="checkbox-field">
  <label for={id}>
    <input 
      id={id} 
      name={name} 
      type="checkbox" 
      bind:checked={checked} 
      class:has-error={errors?.[name]}
    />
    <span>{label}</span>
  </label>
  
  {#if errors?.[name]}
    <span class="error-message">{errors[name]}</span>
  {/if}
</div>

<style>
  .checkbox-field {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }
  
  label {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    cursor: pointer;
  }
  
  input.has-error {
    accent-color: #ef4444;
  }
  
  .error-message {
    color: #ef4444;
    font-size: 0.875rem;
  }
</style>
```

### Select

Composant de sélection déroulante.

```svelte
<!-- src/lib/components/forms/Select.svelte -->
<script lang="ts">
  let { name, label, options, value, errors, placeholder = 'Select an option' } = $props();
  
  const id = `select-${name}`;
</script>

<div class="select-field">
  {#if label}
    <label for={id}>{label}</label>
  {/if}
  
  <select 
    id={id} 
    name={name} 
    bind:value={value} 
    class:has-error={errors?.[name]}
  >
    <option value="">{placeholder}</option>
    {#each options as option}
      <option value={option.value}>{option.label}</option>
    {/each}
  </select>
  
  {#if errors?.[name]}
    <span class="error-message">{errors[name]}</span>
  {/if}
</div>

<style>
  .select-field {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  label {
    font-weight: 500;
    font-size: 0.875rem;
  }
  
  select {
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 0.25rem;
  }
  
  select.has-error {
    border-color: #ef4444;
  }
  
  .error-message {
    color: #ef4444;
    font-size: 0.875rem;
  }
</style>
```

**Utilisation:**

```svelte
<script lang="ts">
  import Select from '$lib/components/forms/Select.svelte';
  import { superForm } from 'sveltekit-superforms';
  
  let { data } = $props();
  const { form, errors } = superForm(data.form);
  
  const countries = [
    { value: 'us', label: 'United States' },
    { value: 'fr', label: 'France' },
    { value: 'de', label: 'Germany' }
  ];
</script>

<form method="POST">
  <Select 
    name="country" 
    label="Country" 
    options={countries}
    value={$form.country}
    errors={$errors}
  />
  
  <button type="submit">Submit</button>
</form>
```

### TextArea

Composant de zone de texte multiligne.

```svelte
<!-- src/lib/components/forms/TextArea.svelte -->
<script lang="ts">
  let { name, label, placeholder = '', rows = 4, value, errors } = $props();
  
  const id = `textarea-${name}`;
</script>

<div class="textarea-field">
  {#if label}
    <label for={id}>{label}</label>
  {/if}
  
  <textarea 
    id={id} 
    name={name} 
    placeholder={placeholder} 
    rows={rows}
    bind:value={value} 
    class:has-error={errors?.[name]}
  ></textarea>
  
  {#if errors?.[name]}
    <span class="error-message">{errors[name]}</span>
  {/if}
</div>

<style>
  .textarea-field {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  label {
    font-weight: 500;
    font-size: 0.875rem;
  }
  
  textarea {
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 0.25rem;
    resize: vertical;
  }
  
  textarea.has-error {
    border-color: #ef4444;
  }
  
  .error-message {
    color: #ef4444;
    font-size: 0.875rem;
  }
</style>
```

## Utilisation

Voir le fichier SKILL.md pour la configuration de base.
