---
name: "drizzle-orm-patterns"
description: "Drizzle ORM patterns and best practices for SvelteKit projects with PostgreSQL, including schema design, service patterns, migrations, testing, and mocking."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["sveltekit", "drizzle", "orm", "postgresql", "database"]
trigger_patterns:
  - "drizzle"
  - "orm"
  - "database schema"
  - "service pattern"
  - "schéma base de données"
  - "pattern service"
---

# Drizzle ORM Patterns for SvelteKit

This skill provides comprehensive patterns and best practices for using Drizzle ORM in SvelteKit projects with PostgreSQL.

## Schema Design with Drizzle

### Define Tables with Proper Types and Constraints

Always use proper TypeScript types and database constraints:

```typescript
import { pgTable, serial, text, timestamp, boolean, integer, index } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

export const user = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull().unique(),
  phoneNumber: text('phone_number'),
  isAdmin: boolean('is_admin').default(false).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
}, (table) => ({
  emailIdx: index('email_idx').on(table.email),
}));

export const referrals = pgTable('referrals', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => user.id, { onDelete: 'cascade' }).notNull(),
  referralName: text('referral_name').notNull(),
  referralEmail: text('referral_email').notNull(),
  referralPhone: text('referral_phone'),
  status: text('status').notNull(), // enum: 'pending' | 'validated' | 'rejected'
  createdAt: timestamp('created_at').defaultNow().notNull(),
});
```

### Define Relations Between Tables

```typescript
export const userRelations = relations(user, ({ many }) => ({
  referrals: many(referrals),
}));

export const referralRelations = relations(referrals, ({ one }) => ({
  user: one(user, {
    fields: [referrals.userId],
    references: [user.id],
  }),
}));
```

### Use Enums for Status Fields

```typescript
import { pgEnum } from 'drizzle-orm/pg-core';

export const referralStatusEnum = pgEnum('referral_status', [
  'pending',
  'validated',
  'rejected'
]);

export const referrals = pgTable('referrals', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => user.id).notNull(),
  status: referralStatusEnum('status').notNull(),
  // ...
});
```

## Service Pattern for Database Operations

### Create Service Classes for Each Entity

Organize database operations into service classes:

```typescript
// src/lib/server/referral-service.ts
import { db } from '$lib/db';
import { referrals, users } from '$lib/db/schema';
import { eq, desc } from 'drizzle-orm';
import type { Referral, User } from '$lib/db/schema';

export class ReferralService {
  // Get referrals by user ID with user data
  static async getReferralsByUserId(userId: number): Promise<Referral[]> {
    return db
      .select()
      .from(referrals)
      .where(eq(referrals.userId, userId))
      .orderBy(desc(referrals.createdAt));
  }

  // Create a new referral
  static async createReferral(data: {
    userId: number;
    referralName: string;
    referralEmail: string;
    referralPhone?: string;
  }): Promise<Referral> {
    const [referral] = await db
      .insert(referrals)
      .values(data)
      .returning();
    
    if (!referral) {
      throw new Error('Failed to create referral');
    }
    
    return referral;
  }

  // Update referral status
  static async updateReferralStatus(
    id: number,
    status: 'pending' | 'validated' | 'rejected'
  ): Promise<Referral> {
    const [referral] = await db
      .update(referrals)
      .set({ status })
      .where(eq(referrals.id, id))
      .returning();
    
    if (!referral) {
      throw new Error('Referral not found');
    }
    
    return referral;
  }

  // Get referral with user data
  static async getReferralWithUser(id: number) {
    const result = await db
      .select({
        referral: referrals,
        user: users
      })
      .from(referrals)
      .leftJoin(users, eq(referrals.userId, users.id))
      .where(eq(referrals.id, id))
      .limit(1);
    
    return result[0];
  }

  // Get referral count for a user
  static async getReferralCount(userId: number): Promise<number> {
    const result = await db
      .select({ count: sql`count(*)`.mapWith(Number) })
      .from(referrals)
      .where(eq(referrals.userId, userId));
    
    return result[0]?.count ?? 0;
  }
}
```

### Error Handling in Services

```typescript
import { eq } from 'drizzle-orm';
import { db } from '$lib/db';
import { users } from '$lib/db/schema';

class UserService {
  static async getUserById(id: number) {
    try {
      const result = await db
        .select()
      .from(users)
      .where(eq(users.id, id))
      .limit(1);
      
      return result[0] ?? null;
    } catch (error) {
      console.error('Error fetching user:', error);
      throw new Error('Failed to fetch user');
    }
  }

  static async updateUser(id: number, data: Partial<User>) {
    try {
      const [user] = await db
        .update(users)
      .set({ ...data, updatedAt: new Date() })
      .where(eq(users.id, id))
      .returning();
      
      if (!user) {
        throw new Error('User not found');
      }
      
      return user;
    } catch (error) {
      console.error('Error updating user:', error);
      throw new Error('Failed to update user');
    }
  }
}
```

## Migrations with Drizzle Kit

### Generate Migration

```bash
# Generate migration from schema changes
bun exec drizzle-kit generate
```

### Push Changes (Development)

```bash
# Push schema changes directly (development only)
bun exec drizzle-kit push
```

### Run Migrations (Production)

```bash
# Run migrations in production
bun exec drizzle-kit migrate
```

### Drizzle Config

```typescript
// drizzle.config.ts
import type { Config } from 'drizzle-kit';
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  schema: './src/lib/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
});
```

### Migration Best Practices

- Keep migrations in `drizzle/` folder
- Review generated migrations before committing
- Use descriptive migration names
- Never edit existing migrations
- Test migrations in development first

## Testing Schema with Vitest

### Create Tests for Schema Constraints

```typescript
// src/lib/db/__tests__/schema.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { db } from '$lib/db';
import { users, referrals } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

describe('User Schema', () => {
  beforeEach(async () => {
    // Clean up before each test
    await db.delete(users);
  });

  it('should create user with required fields', async () => {
    const [newUser] = await db.insert(users).values({
      email: 'test@example.com',
    }).returning();
    
    expect(newUser.email).toBe('test@example.com');
    expect(newUser.isAdmin).toBe(false);
    expect(newUser.id).toBeDefined();
  });

  it('should enforce unique email constraint', async () => {
    await db.insert(users).values({
      email: 'duplicate@example.com',
    });
    
    await expect(
      db.insert(users).values({
        email: 'duplicate@example.com',
      })
    ).rejects.toThrow();
  });

  it('should update timestamp on update', async () => {
    const [user] = await db.insert(users).values({
      email: 'timestamp@example.com',
    }).returning();
    
    const initialUpdatedAt = user.updatedAt;
    
    // Wait a bit
    await new Promise(resolve => setTimeout(resolve, 10));
    
    await db.update(users)
      .set({ phoneNumber: '+1234567890' })
      .where(eq(users.id, user.id));
    
    const [updated] = await db.select().from(users).where(eq(users.id, user.id));
    
    expect(updated.updatedAt.getTime()).toBeGreaterThan(initialUpdatedAt.getTime());
  });
});

describe('Referral Schema', () => {
  beforeEach(async () => {
    await db.delete(referrals);
    await db.delete(users);
  });

  it('should create referral with user relation', async () => {
    const [user] = await db.insert(users).values({
      email: 'user@example.com',
    }).returning();
    
    const [referral] = await db.insert(referrals).values({
      userId: user.id,
      referralName: 'John Doe',
      referralEmail: 'john@example.com',
      status: 'pending',
    }).returning();
    
    expect(referral.userId).toBe(user.id);
    expect(referral.status).toBe('pending');
  });

  it('should cascade delete when user is deleted', async () => {
    const [user] = await db.insert(users).values({
      email: 'cascade@example.com',
    }).returning();
    
    await db.insert(referrals).values({
      userId: user.id,
      referralName: 'Test',
      referralEmail: 'test@example.com',
      status: 'pending',
    });
    
    await db.delete(users).where(eq(users.id, user.id));
    
    const remaining = await db.select().from(referrals);
    expect(remaining).toHaveLength(0);
  });
});
```

## Mocking Database for Tests

### Create Database Mock

```typescript
// src/lib/__mocks__/db.ts
import { vi } from 'vitest';
import type { User, Referral } from '$lib/db/schema';

export const db = {
  select: vi.fn().mockReturnValue({
    from: vi.fn().mockReturnValue({
      where: vi.fn().mockReturnValue({
        orderBy: vi.fn().mockReturnValue({
          limit: vi.fn().mockReturnValue({
            offset: vi.fn().mockResolvedValue([])
          })
        }),
        limit: vi.fn().mockReturnValue({
          offset: vi.fn().mockResolvedValue([])
        }),
        leftJoin: vi.fn().mockReturnValue({
          limit: vi.fn().mockResolvedValue([])
        })
      })
    })
  }),
  insert: vi.fn().mockReturnValue({
    values: vi.fn().mockReturnValue({
      returning: vi.fn().mockResolvedValue([{ id: 1 }])
    })
  }),
  update: vi.fn().mockReturnValue({
    set: vi.fn().mockReturnValue({
      where: vi.fn().mockReturnValue({
        returning: vi.fn().mockResolvedValue([{ id: 1, status: 'validated' }])
      })
    })
  }),
  delete: vi.fn().mockReturnValue({
    where: vi.fn().mockResolvedValue(1)
  }),
};
```

### Test Service Logic with Mocks

```typescript
// src/lib/server/__tests__/referral-service.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { db } from '$lib/__mocks__/db';
import { ReferralService } from '$lib/server/referral-service';

vi.mock('$lib/db', () => ({ db }));

describe('ReferralService', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should create referral', async () => {
    const mockReferral = { id: 1, userId: 1, referralName: 'John', referralEmail: 'john@test.com' };
    
    db.insert = vi.fn().mockReturnValue({
      values: vi.fn().mockReturnValue({
        returning: vi.fn().mockResolvedValue([mockReferral])
      })
    });
    
    const referral = await ReferralService.createReferral({
      userId: 1,
      referralName: 'John',
      referralEmail: 'john@test.com',
    });
    
    expect(referral.id).toBe(1);
  });

  it('should throw error when creation fails', async () => {
    db.insert = vi.fn().mockReturnValue({
      values: vi.fn().mockReturnValue({
        returning: vi.fn().mockResolvedValue([])
      })
    });
    
    await expect(
      ReferralService.createReferral({
        userId: 1,
        referralName: 'John',
        referralEmail: 'john@test.com',
      })
    ).rejects.toThrow('Failed to create referral');
  });
});
```

## Advanced Query Patterns

### Dynamic Sorting and Filtering

```typescript
import { desc, asc, like, or, sql, and } from 'drizzle-orm';
import { users, referrals } from '$lib/db/schema';

export async function getUsers(options: {
  page?: number;
  limit?: number;
  search?: string;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}) {
  const { page = 1, limit = 10, search, sortBy, sortOrder = 'desc' } = options;
  const offset = (page - 1) * limit;
  
  let query = db.select().from(users);
  
  // Search filter
  if (search) {
    query = query.where(
      or(
        like(users.email, `%${search}%`),
        like(users.phoneNumber, `%${search}%`)
      )
    );
  }
  
  // Sorting
  if (sortBy && sortBy in users) {
    const sortColumn = users[sortBy as keyof typeof users];
    if (sortOrder === 'desc') {
      query = query.orderBy(desc(sortColumn));
    } else {
      query = query.orderBy(asc(sortColumn));
    }
  }
  
  // Pagination
  const usersList = await query.limit(limit).offset(offset);
  
  // Get total count
  let countQuery = db.select({ total: sql`count(*)`.mapWith(Number) }).from(users);
  if (search) {
    countQuery = countQuery.where(
      or(
        like(users.email, `%${search}%`),
        like(users.phoneNumber, `%${search}%`)
      )
    );
  }
  const [{ total }] = await countQuery;
  
  return { 
    users: usersList, 
    total, 
    page, 
    limit, 
    totalPages: Math.ceil(total / limit) 
  };
}
```

### Complex Queries with Relations

```typescript
import { db } from '$lib/db';
import { referrals, users, gifts, giftRedemptions } from '$lib/db/schema';
import { eq, desc, and } from 'drizzle-orm';

export async function getUserReferralStats(userId: number) {
  const userReferrals = await db
    .select({
      referral: referrals,
      user: users
    })
    .from(referrals)
    .leftJoin(users, eq(referrals.userId, users.id))
    .where(eq(referrals.userId, userId))
    .orderBy(desc(referrals.createdAt));
  
  const totalReferrals = userReferrals.length;
  const validatedReferrals = userReferrals.filter(r => r.referral.status === 'validated').length;
  const pendingReferrals = userReferrals.filter(r => r.referral.status === 'pending').length;
  
  return {
    total: totalReferrals,
    validated: validatedReferrals,
    pending: pendingReferrals,
 referrals: userReferrals
  };
}

export async function getUserGiftRedemptions(userId: number) {
  const result = await db
    .select({
      redemption: giftRedemptions,
      gift: gifts
    })
    .from(giftRedemptions)
    .innerJoin(gifts, eq(giftRedemptions.giftId, gifts.id))
    .where(eq(giftRedemptions.userId, userId))
    .orderBy(desc(giftRedemptions.redeemedAt));
  
  return result;
}
```

### Transactions

```typescript
import { db } from '$lib/db';
import { referrals, users } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export async function createReferralWithUpdate(data: {
  userId: number;
  referralName: string;
  referralEmail: string;
}) {
  return db.transaction(async (tx) => {
    // Create referral
    const [referral] = await tx.insert(referrals).values({
      userId: data.userId,
      referralName: data.referralName,
      referralEmail: data.referralEmail,
      status: 'pending',
    }).returning();
    
    // Update user stats (example)
    await tx.update(users)
      .set({ updatedAt: new Date() })
      .where(eq(users.id, data.userId));
    
    return referral;
  });
}
```

## Best Practices

### Schema Organization

- Keep all tables in `src/lib/db/schema.ts`
- Keep relations in separate file `src/lib/db/relations.ts`
- Use clear, descriptive column names
- Add indexes for frequently queried columns
- Use proper foreign key constraints

### Service Layer Guidelines

- One service class per entity
- Use static methods for all operations
- Always return typed results
- Handle errors gracefully
- Never expose database errors to clients
- Keep business logic in services, not in routes

### Testing Guidelines

- Test schema constraints with real database in integration tests
- Mock database for unit tests of services
- Test edge cases (null values, empty results, errors)
- Test transactions
- Keep tests fast and isolated

### Performance Tips

- Use indexes on frequently queried columns
- Select only needed columns
- Use pagination for large datasets
- Avoid N+1 queries with proper joins
- Use transactions for related operations

---

**Use these patterns to maintain clean, type-safe, and efficient database operations in your SvelteKit projects.**
