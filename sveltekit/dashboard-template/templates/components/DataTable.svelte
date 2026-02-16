<script lang="ts">
  import type { Snippet } from 'svelte';

  interface Props {
    data: Array<Record<string, any>>;
    columns?: string[];
    actions?: Snippet;
  }

  let { data, columns, actions }: Props = $props();

  const displayColumns = $derived(columns || Object.keys(data[0] || {}));
</script>

<table class="data-table">
  <thead>
    <tr>
      {#each displayColumns as column}
        <th>{column}</th>
      {/each}
      {#if actions}
        <th>Actions</th>
      {/if}
    </tr>
  </thead>
  <tbody>
    {#each data as row, index (row.id || index)}
      <tr>
        {#each displayColumns as column}
          <td>{row[column]}</td>
        {/each}
        {#if actions}
          <td>
            {@render actions(row)}
          </td>
        {/if}
      </tr>
    {/each}
  </tbody>
</table>

<style>
  .data-table {
    width: 100%;
    border-collapse: collapse;
  }
  .data-table th,
  .data-table td {
    padding: 0.75rem 1rem;
    text-align: left;
    border-bottom: 1px solid var(--color-surface-200);
  }
  .data-table th {
    font-weight: 600;
    color: var(--color-surface-600);
  }
  .data-table tbody tr:hover {
    background-color: var(--color-surface-100);
  }
</style>
