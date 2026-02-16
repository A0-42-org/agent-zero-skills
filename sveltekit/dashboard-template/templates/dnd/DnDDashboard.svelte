<script lang="ts">
  import { dndzone } from 'svelte-dnd-action';
  import { AppCard } from '@skeletonlabs/skeleton-svelte';
  import { GripVertical, X } from 'lucide-svelte';

  interface Widget {
    id: string;
    title: string;
    type: 'metric' | 'chart' | 'list' | 'text';
    data: any;
  }

  interface Props {
    title?: string;
    widgets?: Widget[];
    onUpdate?: (widgets: Widget[]) => void;
  }

  let { title = 'Widgets', widgets = [], onUpdate }: Props = $props();


  function handleDrop(e: any) {
    const { items } = e.detail;
    widgets = items;
    onUpdate?.(widgets);
  }

  function removeWidget(widgetId: string) {
    widgets = widgets.filter(w => w.id !== widgetId);
    onUpdate?.(widgets);
  }
</script>

<div class="dnd-dashboard">
  {#if title}
    <h2 class="dnd-title">{title}</h2>
  {/if}
  <div class="dnd-grid" use:dndzone={{ items: widgets, dropTargetClass: 'drop-target' }} on:finalize={handleDrop}>
    {#each widgets as widget (widget.id)}
      <div class="dnd-widget" data-id={widget.id}>
        <AppCard class="widget-card">
          <div class="widget-header">
            <div class="widget-drag-handle">
              <GripVertical class="w-5 h-5" />
            </div>
            <h3 class="widget-title">{widget.title}</h3>
            <button 
              class="widget-remove" 
              onclick={() => removeWidget(widget.id)}
              aria-label="Remove widget"
            >
              <X class="w-5 h-5" />
            </button>
          </div>
          <div class="widget-content">
            <p class="widget-type">Type: {widget.type}</p>
            <pre class="widget-data">{JSON.stringify(widget.data, null, 2)}</pre>
          </div>
        </AppCard>
      </div>
    {/each}
  </div>
</div>

<style>
  .dnd-dashboard {
    padding: 1.5rem 0;
  }
  .dnd-title {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 1rem;
  }
  .dnd-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1rem;
  }
  .dnd-widget {
    cursor: move;
  }
  .widget-card {
    transition: box-shadow 0.2s;
  }
  .widget-card:hover {
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  .widget-header {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding-bottom: 0.5rem;
    border-bottom: 1px solid var(--color-surface-200);
  }
  .widget-drag-handle {
    color: var(--color-surface-400);
    cursor: move;
  }
  .widget-drag-handle:hover {
    color: var(--color-surface-600);
  }
  .widget-title {
    flex: 1;
    font-weight: 600;
  }
  .widget-remove {
    background: none;
    border: none;
    color: var(--color-surface-400);
    cursor: pointer;
    padding: 0.25rem;
    border-radius: 0.25rem;
    transition: all 0.2s;
  }
  .widget-remove:hover {
    background-color: var(--color-error-50);
    color: var(--color-error-500);
  }
  .widget-content {
    padding-top: 0.75rem;
  }
  .widget-type {
    font-size: 0.75rem;
    color: var(--color-surface-500);
    margin-bottom: 0.5rem;
  }
  .widget-data {
    font-size: 0.75rem;
    color: var(--color-surface-600);
    overflow-x: auto;
  }
  .drop-target {
    opacity: 0.5;
  }
</style>
