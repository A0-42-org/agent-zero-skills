# User Management Templates (Optional)

These templates provide user management functionality (CRUD) for your dashboard.

## Installation

Install Drizzle ORM:
```bash
bun add drizzle-orm better-sqlite3
bun add -D drizzle-kit
```

## Components

### UserList.svelte
List view of users with filtering, sorting, and pagination.

### UserForm.svelte
Form for creating and editing users.

## Usage

### Step 1: Define user schema

In `src/lib/db/schema.ts`:

```typescript
import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('users', {
  id: text('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  role: text('role').default('user'),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull().$defaultFn(() => new Date()),
});
```

### Step 2: Create user list page

Create `src/routes/users/+page.svelte`:

```svelte
<script lang="ts">
  import UserList from '$lib/components/UserList.svelte';
  import type { PageServerData } from './$types';

  let { data }: { data: PageServerData } = $props();
</script>

<UserList users={data.users} />
```

### Step 3: Create user form page

Create `src/routes/users/+page.svelte`:

```svelte
<script lang="ts">
  import UserForm from '$lib/components/UserForm.svelte';
</script>

<UserForm />
```

## Customization

You can add more user management features like:
- Permissions
- Groups
- Bulk operations
- Export users

---
**Use these templates to add user management to your dashboard.**
