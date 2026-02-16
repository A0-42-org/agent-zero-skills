# Charts Templates (Optional)

These templates provide chart components for visualizing data in your dashboard.

## Installation

No additional installation required - these charts use Canvas API.

Alternatively, install Chart.js for more advanced features:
```bash
pnpm add chart.js
```

## Components

### LineChart.svelte
Line chart for displaying trends over time.

### BarChart.svelte
Bar chart for comparing categories.

### PieChart.svelte
Pie chart for showing proportions.

## Usage

```svelte
<script lang="ts">
  import LineChart from '$lib/components/LineChart.svelte';
  import BarChart from '$lib/components/BarChart.svelte';
  import PieChart from '$lib/components/PieChart.svelte';

  const lineData = [
    { x: 'Jan', y: 10 },
    { x: 'Feb', y: 20 },
    { x: 'Mar', y: 15 },
  ];

  const barData = [
    { label: 'Category A', value: 30 },
    { label: 'Category B', value: 50 },
    { label: 'Category C', value: 20 },
  ];

  const pieData = [
    { label: 'Segment A', value: 30 },
    { label: 'Segment B', value: 50 },
    { label: 'Segment C', value: 20 },
  ];
</script>

<LineChart data={lineData} title="Revenue over time" />
<BarChart data={barData} title="Sales by category" />
<PieChart data={pieData} title="User distribution" />
```

## Customization

You can customize colors, labels, and chart options by modifying the components.

---
**Use these templates to add charts to your dashboard.**
