<script lang="ts">
  import { AppCard, AppButton, AppInput, AppSelect } from '@skeletonlabs/skeleton-svelte';

  interface User {
    id?: string;
    email: string;
    name?: string;
    role: string;
  }

  interface Props {
    user?: User;
    onSave: (user: User) => Promise<void>;
    onCancel?: () => void;
  }

  let { user, onSave, onCancel }: Props = $props();

  let email = $state(user?.email || '');
  let name = $state(user?.name || '');
  let role = $state(user?.role || 'user');
  let isSaving = $state(false);
  let error = $state<string | null>(null);

  const roles = [
    { value: 'user', label: 'User' },
    { value: 'admin', label: 'Admin' },
    { value: 'moderator', label: 'Moderator' },
  ];

  const isEditMode = $derived(!!user?.id);
  const isValid = $derived(
    email.length > 0 && email.includes('@') &&
    name.length > 0 &&
    role.length > 0
  );

  async function handleSubmit(e: Event) {
    e.preventDefault();

    if (!isValid) {
      error = 'Please fill in all required fields';
      return;
    }

    isSaving = true;
    error = null;

    try {
      await onSave({
        id: user?.id,
        email,
        name,
        role,
      });
    } catch (err) {
      error = err instanceof Error ? err.message : 'Failed to save user';
    } finally {
      isSaving = false;
    }
  }
</script>

<AppCard class="user-form">
  <div slot="header">
    <h2>{isEditMode ? 'Edit User' : 'Create User'}</h2>
  </div>

  <form onsubmit={handleSubmit}>
    <div class="form-fields">
      <div class="form-field">
        <label for="email">Email *</label>
        <AppInput 
          id="email" 
          type="email" 
          placeholder="user@example.com" 
          bind:value={email} 
          required 
        />
      </div>

      <div class="form-field">
        <label for="name">Name *</label>
        <AppInput 
          id="name" 
          type="text" 
          placeholder="John Doe" 
          bind:value={name} 
          required 
        />
      </div>

      <div class="form-field">
        <label for="role">Role *</label>
        <AppSelect 
          id="role" 
          name="role" 
          bind:value={role} 
          options={roles} 
          required 
        />
      </div>

      {#if error}
        <div class="form-error">{error}</div>
      {/if}
    </div>

    <div class="form-actions">
      {#if onCancel}
        <AppButton type="button" variant="ghost" onclick={onCancel}>
          Cancel
        </AppButton>
      {/if}
      <AppButton 
        type="submit" 
        disabled={!isValid || isSaving}
      >
        {isSaving ? 'Saving...' : isEditMode ? 'Update User' : 'Create User'}
      </AppButton>
    </div>
  </form>
</AppCard>

<style>
  .user-form {
    max-width: 500px;
  }
  .form-fields {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
  }
  .form-field {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  .form-field label {
    font-weight: 500;
    font-size: 0.875rem;
  }
  .form-error {
    padding: 0.75rem;
    background-color: var(--color-error-50);
    color: var(--color-error-600);
    border: 1px solid var(--color-error-200);
    border-radius: 0.25rem;
    font-size: 0.875rem;
  }
  .form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
    margin-top: 1.5rem;
    padding-top: 1.5rem;
    border-top: 1px solid var(--color-surface-200);
  }
</style>
