<script lang="ts">
  import { onMount } from 'svelte';
  import { AppCard } from '@skeletonlabs/skeleton-svelte';

  interface ChartData {
    x: string;
    y: number;
  }

  interface Props {
    data: ChartData[];
    title?: string;
    color?: string;
  }

  let { data, title = 'Line Chart', color = 'var(--color-primary-500)' }: Props = $props();

  let canvas = $state<HTMLCanvasElement>();

  onMount(() => {
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const width = canvas.width;
    const height = canvas.height;
    const padding = 40;

    const maxValue = Math.max(...data.map(d => d.y)) * 1.1;
    const minValue = Math.min(...data.map(d => d.y)) * 0.9;

    const xScale = (width - 2 * padding) / (data.length - 1);
    const yScale = (height - 2 * padding) / (maxValue - minValue);

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

    ctx.strokeStyle = color;
    ctx.lineWidth = 2;
    ctx.beginPath();

    data.forEach((point, index) => {
      const x = padding + index * xScale;
      const y = height - padding - (point.y - minValue) * yScale;

      if (index === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
    });

    ctx.stroke();

    ctx.fillStyle = color;
    data.forEach((point, index) => {
      const x = padding + index * xScale;
      const y = height - padding - (point.y - minValue) * yScale;

      ctx.beginPath();
      ctx.arc(x, y, 4, 0, Math.PI * 2);
      ctx.fill();
    });

    ctx.fillStyle = 'var(--color-surface-600)';
    ctx.font = '12px sans-serif';
    ctx.textAlign = 'center';

    data.forEach((point, index) => {
      const x = padding + index * xScale;
      ctx.fillText(point.x, x, height - 10);
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
