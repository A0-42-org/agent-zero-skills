<script lang="ts">
  import { onMount } from 'svelte';
  import { AppCard } from '@skeletonlabs/skeleton-svelte';

  interface ChartData {
    label: string;
    value: number;
  }

  interface Props {
    data: ChartData[];
    title?: string;
    color?: string;
  }

  let { data, title = 'Bar Chart', color = 'var(--color-primary-500)' }: Props = $props();

  let canvas = $state<HTMLCanvasElement>();

  onMount(() => {
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const width = canvas.width;
    const height = canvas.height;
    const padding = 40;

    const maxValue = Math.max(...data.map(d => d.value)) * 1.1;

    const barWidth = (width - 2 * padding) / data.length * 0.7;
    const barGap = (width - 2 * padding) / data.length * 0.3;

    ctx.clearRect(0, 0, width, height);

    ctx.strokeStyle = 'var(--color-surface-200)';
    ctx.lineWidth = 1;

    for (let i = 0; i <= 5; i++) {
      const y = padding + (i * (height - 2 * padding) / 5);
      ctx.beginPath();
      ctx.moveTo(padding, y);
      ctx.lineTo(width - padding, y);
      ctx.stroke();
    }

    ctx.fillStyle = color;

    data.forEach((item, index) => {
      const x = padding + index * (barWidth + barGap) + barGap / 2;
      const barHeight = (item.value / maxValue) * (height - 2 * padding);
      const y = height - padding - barHeight;

      ctx.fillRect(x, y, barWidth, barHeight);
    });

    ctx.fillStyle = 'var(--color-surface-600)';
    ctx.font = '12px sans-serif';
    ctx.textAlign = 'center';

    data.forEach((item, index) => {
      const x = padding + index * (barWidth + barGap) + barGap / 2 + barWidth / 2;
      ctx.fillText(item.label, x, height - 10);

      const barHeight = (item.value / maxValue) * (height - 2 * padding);
      const y = height - padding - barHeight - 5;
      ctx.fillText(item.value.toString(), x, y);
    });
  });
</script>

<AppCard class="chart-card">
  {#if title}
    <div class="chart-title">{title}</div>
  {/if}
  <div class="chart-container">
    <canvas 
      bind:this={canvas} 
      width="600" 
      height="400" 
      class="chart-canvas"
    />
  </div>
</AppCard>

<style>
  .chart-card {
    border-radius: 0.5rem;
  }
  .chart-title {
    padding: 1rem;
    font-weight: 600;
    border-bottom: 1px solid var(--color-surface-200);
  }
  .chart-container {
    padding: 1rem;
    overflow-x: auto;
  }
  .chart-canvas {
    max-width: 100%;
  }
</style>
