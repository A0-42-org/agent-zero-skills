<script lang="ts">
  import type { Snippet } from 'svelte';
  import { page } from '$app/stores';
  import { AppShell, AppSidebar, AppSidebarHeader, AppSidebarBody, AppSidebarNav } from '@skeletonlabs/skeleton-svelte';
  import { LayoutDashboard, Settings, Activity } from 'lucide-svelte';

  interface Props {
    title: string;
    children: Snippet;
  }

  let { title, children }: Props = $props();

  const navItems = [
    { label: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    { label: 'Analytics', href: '/dashboard/analytics', icon: Activity },
    { label: 'Settings', href: '/dashboard/settings', icon: Settings },
  ];
</script>

<AppShell>
  <AppSidebar>
    <AppSidebarHeader>
      <div class="sidebar-header">
        <h2 class="sidebar-title">{title}</h2>
      </div>
    </AppSidebarHeader>
    <AppSidebarBody>
      <AppSidebarNav>
        {#each navItems as item}
          <a 
            href={item.href} 
            class:active={$page.url.pathname === item.href}
          >
            <svelte:component this={item.icon} class="w-5 h-5" />
            <span>{item.label}</span>
          </a>
        {/each}
      </AppSidebarNav>
    </AppSidebarBody>
  </AppSidebar>
  <main class="main-content">
    {@render children()}
  </main>
</AppShell>

<style>
  .sidebar-header {
    padding: 1rem;
  }
  .sidebar-title {
    font-size: 1.25rem;
    font-weight: 600;
  }
  .main-content {
    padding: 1.5rem;
    min-height: 100vh;
  }
  a {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.75rem 1rem;
    border-radius: 0.5rem;
    transition: all 0.2s;
  }
  a:hover {
    background-color: var(--color-surface-100);
  }
  a.active {
    background-color: var(--color-primary-500);
    color: white;
  }
</style>
