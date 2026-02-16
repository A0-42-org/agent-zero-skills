<script lang="ts">
  import { setContext, onMount } from 'svelte';
  import { browser } from '$app/environment';
  import { AppButton } from '@skeletonlabs/skeleton-svelte';

  type Theme = 'light' | 'dark' | 'neutral' | 'svelteForge';

  interface ThemeContext {
    theme: Theme;
    setTheme: (theme: Theme) => void;
  }

  const THEMES: Theme[] = ['light', 'dark', 'neutral', 'svelteForge'];

  let theme = $state<Theme>('svelteForge');

  function setTheme(newTheme: Theme) {
    theme = newTheme;
    if (browser) {
      localStorage.setItem('theme', newTheme);
      document.documentElement.setAttribute('data-theme', newTheme);
    }
  }

  onMount(() => {
    if (browser) {
      const savedTheme = localStorage.getItem('theme') as Theme;
      if (savedTheme && THEMES.includes(savedTheme)) {
        setTheme(savedTheme);
      } else {
        // Default to svelteForge theme
        setTheme('svelteForge');
      }
    }
  });

  setContext<ThemeContext>('theme', { theme, setTheme });
</script>

<slot />
