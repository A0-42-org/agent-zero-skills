<script lang="ts">
  import { setContext, onMount } from 'svelte';
  import { browser } from '$app/environment';
  import { AppAlert, AppButton } from '@skeletonlabs/skeleton-svelte';

  interface User {
    id: string;
    email: string;
    name?: string;
  }

  interface AuthContext {
    user: User | null;
    loading: boolean;
    login: (email: string, password: string) => Promise<void>;
    logout: () => Promise<void>;
  }

  let user = $state<User | null>(null);
  let loading = $state(false);
  let error = $state<string | null>(null);

  async function login(email: string, password: string) {
    loading = true;
    error = null;

    try {
      // TODO: Replace with actual auth implementation
      const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      if (!response.ok) {
        throw new Error('Login failed');
      }

      const userData = await response.json();
      user = userData.user;

      if (browser) {
        localStorage.setItem('user', JSON.stringify(userData.user));
      }
    } catch (err) {
      error = err instanceof Error ? err.message : 'Login failed';
    } finally {
      loading = false;
    }
  }

  async function logout() {
    user = null;
    if (browser) {
      localStorage.removeItem('user');
    }
  }

  onMount(() => {
    if (browser) {
      const savedUser = localStorage.getItem('user');
      if (savedUser) {
        user = JSON.parse(savedUser);
      }
    }
  });

  setContext<AuthContext>('auth', { user, loading, login, logout });
</script>

{#if error}
  <AppAlert severity="error" title="Authentication Error">
    {error}
  </AppAlert>
{/if}

<slot />
