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
  }

  let { data, title = 'Pie Chart' }: Props = $props();

  let canvas = $state<HTMLCanvasElement>();
  const colors = [
    'var(--color-primary-500)',
    'var(--color-success-500)',
    'var(--color-warning-500)',
    'var(--color-error-500)',
    'var(--color-info-500)',
  ];

  onMount(() => {
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2;
    const centerY = height / 2;
    const radius = Math.min(width, height) / 2 - 40;

    const total = data.reduce((sum, item) => sum + item.value, 0);

    ctx.clearRect(0, 0, width, height);

    let startAngle = 0;

    data.forEach((item, index) => {
      const sliceAngle = (item.value / total) * 2 * Math.PI;
      const color = colors[index % colors.length];

      ctx.fillStyle = color;
      ctx.beginPath();
      ctx.moveTo(centerX, centerY);
      ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
      ctx.closePath();
      ctx.fill();

      const labelAngle = startAngle + sliceAngle / 2;
      const labelX = centerX + Math.cos(labelAngle) * (radius * 0.7);
      const labelY = centerY + Math.sin(labelAngle) * (radius * 0.7);

      ctx.fillStyle = 'white';
      ctx.font = 'bold 14px sans-serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(item.label, labelX, labelY);

      startAngle += sliceAngle;
    });

    ctx.font = '12px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'middle';

    data.forEach((item, index) => {
      const legendY = 20 + index * 20;
      const color = colors[index % colors.length];

      ctx.fillStyle = color;
      ctx.fillRect(20, legendY, 15, 15);

      ctx.fillStyle = 'var(--color-surface-600)';
      ctx.fillText(`${item.label} (${((item.value / total) * 100).toFixed(1)}%)`, 45, legendY + 8);
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
