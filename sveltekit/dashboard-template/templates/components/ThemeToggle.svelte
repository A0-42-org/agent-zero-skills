<script lang="ts">
  import { getContext } from 'svelte';
  import { AppButton } from '@skeletonlabs/skeleton-svelte';
  import { Sun, Moon, Palette } from 'lucide-svelte';

  type Theme = 'light' | 'dark' | 'neutral' | 'svelteForge';

  interface ThemeContext {
    theme: Theme;
    setTheme: (theme: Theme) => void;
  }

  const { theme, setTheme } = getContext<ThemeContext>('theme');
  const THEMES: Theme[] = ['light', 'dark', 'neutral', 'svelteForge'];
</script>

<div class="theme-toggle">
  {#each THEMES as t}
    <AppButton 
      variant={theme === t ? 'filled' : 'ghost'}
      size="sm"
      onclick={() => setTheme(t)}
      aria-label="Switch to {t} theme"
    >
      {#if t === 'light'}
        <Sun class="w-4 h-4" />
      {:else if t === 'dark'}
        <Moon class="w-4 h-4" />
      {:else if t === 'svelteForge'}
        <Palette class="w-4 h-4" />
      {/if}
      <span class="theme-label">{t}</span>
    </AppButton>
  {/each}
</div>

<style>
  .theme-toggle {
    display: flex;
    gap: 0.5rem;
  }
  .theme-label {
    display: none;
  }
</style>
