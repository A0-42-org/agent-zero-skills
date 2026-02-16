<script lang="ts">
  import { AppCard } from '@skeletonlabs/skeleton-svelte';
  import { TrendingUp, TrendingDown } from 'lucide-svelte';

  interface Props {
    title: string;
    value: string;
    trend: string;
    positive: boolean;
  }

  let { title, value, trend, positive }: Props = $props();

  const TrendIcon = $derived(positive ? TrendingUp : TrendingDown);
  const trendColor = $derived(positive ? 'text-green-500' : 'text-red-500');
</script>

<AppCard class="metric-card">
  <div class="metric-content">
    <p class="metric-title">{title}</p>
    <p class="metric-value">{value}</p>
    <div class="metric-trend {trendColor}">
      <TrendIcon class="w-4 h-4" />
      <span>{trend}</span>
    </div>
  </div>
</AppCard>

<style>
  .metric-card {
    border-radius: 0.5rem;
  }
  .metric-content {
    padding: 1rem;
  }
  .metric-title {
    font-size: 0.875rem;
    color: var(--color-surface-500);
    margin-bottom: 0.5rem;
  }
  .metric-value {
    font-size: 1.5rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
  }
  .metric-trend {
    display: flex;
    align-items: center;
    gap: 0.25rem;
    font-size: 0.875rem;
  }
</style>
