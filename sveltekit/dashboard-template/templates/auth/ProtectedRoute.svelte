<script lang="ts">
  import type { Snippet } from 'svelte';
  import { getContext } from 'svelte';
  import { goto } from '$app/navigation';
  import { AppCard, AppButton } from '@skeletonlabs/skeleton-svelte';

  interface User {
    id: string;
    email: string;
    name?: string;
  }

  interface AuthContext {
    user: User | null;
  }

  interface Props {
    children: Snippet;
    fallback?: Snippet;
  }

  let { children, fallback }: Props = $props();
  const { user } = getContext<AuthContext>('auth');

  $effect(() => {
    if (!user) {
      goto('/login');
    }
  });
</script>

{#if user}
  {@render children()}
{:else if fallback}
  {@render fallback()}
{:else}
  <AppCard class="protected-route">
    <h2>Authentication Required</h2>
    <p>Please log in to access this page.</p>
    <AppButton onclick={() => goto('/login')}>Go to Login</AppButton>
  </AppCard>
{/if}

<style>
  .protected-route {
    max-width: 400px;
    margin: 2rem auto;
    padding: 2rem;
    text-align: center;
  }
  .protected-route h2 {
    margin-bottom: 1rem;
  }
  .protected-route p {
    margin-bottom: 1.5rem;
    color: var(--color-surface-500);
  }
</style>
