<script lang="ts">
  import { AppCard, AppButton, AppInput } from '@skeletonlabs/skeleton-svelte';
  import { Edit, Trash2, Search, Plus } from 'lucide-svelte';

  interface User {
    id: string;
    email: string;
    name?: string;
    role: string;
    createdAt: Date;
  }

  interface Props {
    users: User[];
    onEdit?: (user: User) => void;
    onDelete?: (userId: string) => void;
    onCreate?: () => void;
  }

  let { users, onEdit, onDelete, onCreate }: Props = $props();

  let searchTerm = $state('');
  let sortColumn = $state<keyof User>('name');
  let sortDirection = $state<'asc' | 'desc'>('asc');

  const filteredUsers = $derived(
    users.filter(user => 
      user.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.role.toLowerCase().includes(searchTerm.toLowerCase())
    )
  );

  const sortedUsers = $derived(
    [...filteredUsers].sort((a, b) => {
      const aVal = a[sortColumn];
      const bVal = b[sortColumn];

      if (aVal < bVal) return sortDirection === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortDirection === 'asc' ? 1 : -1;
      return 0;
    })
  );

  function handleSort(column: keyof User) {
    if (sortColumn === column) {
      sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
      sortColumn = column;
      sortDirection = 'asc';
    }
  }
</script>

<AppCard class="user-list">
  <div class="user-list-header">
    <div class="user-list-title">
      <h2>Users</h2>
      <span class="user-count">{sortedUsers.length} users</span>
    </div>
    {#if onCreate}
      <AppButton onclick={onCreate}>
        <Plus class="w-4 h-4" />
        Add User
      </AppButton>
    {/if}
  </div>

  <div class="user-list-search">
    <AppInput 
      type="text" 
      placeholder="Search users..." 
      bind:value={searchTerm} 
      class="search-input"
    >
      <Search class="search-icon" />
    </AppInput>
  </div>

  <div class="user-table-container">
    <table class="user-table">
      <thead>
        <tr>
          <th class:sorted={sortColumn === 'name'} onclick={() => handleSort('name')}>
            Name
            {#if sortColumn === 'name'}
              <span class="sort-indicator">{sortDirection === 'asc' ? '↑' : '↓'}</span>
            {/if}
          </th>
          <th class:sorted={sortColumn === 'email'} onclick={() => handleSort('email')}>
            Email
            {#if sortColumn === 'email'}
              <span class="sort-indicator">{sortDirection === 'asc' ? '↑' : '↓'}</span>
            {/if}
          </th>
          <th class:sorted={sortColumn === 'role'} onclick={() => handleSort('role')}>
            Role
            {#if sortColumn === 'role'}
              <span class="sort-indicator">{sortDirection === 'asc' ? '↑' : '↓'}</span>
            {/if}
          </th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {#each sortedUsers as user (user.id)}
          <tr class="user-row">
            <td class="user-name">{user.name || '—'}</td>
            <td class="user-email">{user.email}</td>
            <td class="user-role">
              <span class="role-badge">{user.role}</span>
            </td>
            <td class="user-actions">
              {#if onEdit}
                <AppButton 
                  variant="ghost" 
                  size="sm" 
                  onclick={() => onEdit(user)}
                  aria-label="Edit user"
                >
                  <Edit class="w-4 h-4" />
                </AppButton>
              {/if}
              {#if onDelete}
                <AppButton 
                  variant="ghost" 
                  size="sm" 
                  onclick={() => onDelete(user.id)}
                  aria-label="Delete user"
                >
                  <Trash2 class="w-4 h-4" />
                </AppButton>
              {/if}
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</AppCard>

<style>
  .user-list {
    width: 100%;
  }
  .user-list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.5rem;
    border-bottom: 1px solid var(--color-surface-200);
  }
  .user-list-title {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  .user-list-title h2 {
    margin: 0;
    font-size: 1.25rem;
    font-weight: 600;
  }
  .user-count {
    font-size: 0.875rem;
    color: var(--color-surface-500);
    background-color: var(--color-surface-100);
    padding: 0.25rem 0.75rem;
    border-radius: 9999px;
  }
  .user-list-search {
    padding: 1rem 1.5rem;
    border-bottom: 1px solid var(--color-surface-200);
  }
  .search-input {
    position: relative;
  }
  .search-icon {
    position: absolute;
    right: 0.75rem;
    top: 50%;
    transform: translateY(-50%);
    width: 1rem;
    height: 1rem;
    color: var(--color-surface-400);
  }
  .user-table-container {
    overflow-x: auto;
  }
  .user-table {
    width: 100%;
    border-collapse: collapse;
  }
  .user-table th,
  .user-table td {
    padding: 0.75rem 1.5rem;
    text-align: left;
    border-bottom: 1px solid var(--color-surface-200);
  }
  .user-table th {
    font-weight: 600;
    color: var(--color-surface-600);
    cursor: pointer;
    user-select: none;
  }
  .user-table th:hover {
    background-color: var(--color-surface-100);
  }
  .user-table th.sorted {
    background-color: var(--color-primary-50);
    color: var(--color-primary-600);
  }
  .sort-indicator {
    margin-left: 0.25rem;
  }
  .user-table tbody tr:hover {
    background-color: var(--color-surface-50);
  }
  .user-row:last-child td {
    border-bottom: none;
  }
  .user-name {
    font-weight: 500;
  }
  .user-email {
    color: var(--color-surface-500);
  }
  .role-badge {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    border-radius: 9999px;
    background-color: var(--color-primary-100);
    color: var(--color-primary-700);
    font-size: 0.75rem;
    font-weight: 500;
  }
  .user-actions {
    display: flex;
    gap: 0.5rem;
  }
</style>
