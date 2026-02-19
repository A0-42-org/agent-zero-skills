---
name: database
description: Database setup and management patterns for SvelteKit with connection pooling and query patterns.
version: 1.0.0
author: Agent Zero Team
tags:
  - database
  - sql
  - postgres
  - mysql
  - connection
trigger_patterns:
  - database setup
  - database connection
  - postgres setup
  - mysql setup
---

# SvelteKit Database - Drizzle ORM Patterns

Complete Drizzle ORM patterns for SvelteKit projects with PostgreSQL.

## Installation

```bash
# Core dependencies
bun add drizzle-orm postgres

# Development dependencies
bun add -D drizzle-kit @types/pg
```

## Configuration

### 1. Environment Variables (.env)

```env
# PostgreSQL connection string
DATABASE_URL=postgresql://user:password@host:port/dbname

# BetterAuth (if using auth)
BETTER_AUTH_SECRET=generate-secure-secret-with-openssl-rand-base64-32
BETTER_AUTH_URL=http://localhost:5173
```

### 2. Database Connection (src/lib/db.ts)

**IMPORTANT**: In SvelteKit, `process.env` doesn't load `.env` files. You MUST use `$env/dynamic/private`:

```typescript
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { env } from "$env/dynamic/private";

const connectionString = env.DATABASE_URL;

const client = postgres(connectionString, {
  max: 10,
  idle_timeout: 20,
  connect_timeout: 10,
});

export const db = drizzle(client);
```

### 3. Drizzle Config (drizzle.config.ts)

```typescript
import type { Config } from "drizzle-kit";

export default {
  schema: "./src/lib/db/schema.ts",
  out: "./drizzle",
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
} satisfies Config;
```

## Database Schema Patterns

### Basic Table Pattern

```typescript
import { pgTable, serial, text, timestamp, boolean, integer } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  email: text("email").notNull().unique(),
  name: text("name"),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
  updatedAt: timestamp("updatedAt").notNull().defaultNow(),
});
```

### BetterAuth Schema Pattern

```typescript
import { pgTable, text, timestamp, boolean, serial } from "drizzle-orm/pg-core";

export const user = pgTable("user", {
  id: text("id").primaryKey(),
  email: text("email").notNull().unique(),
  emailVerified: boolean("emailVerified").notNull().default(false),
  name: text("name"),
  image: text("image"),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
  updatedAt: timestamp("updatedAt").notNull().defaultNow(),
});

export const session = pgTable("session", {
  id: text("id").primaryKey(),
  userId: text("userId")
    .notNull()
    .references(() => user.id, { onDelete: "cascade" }),
  expiresAt: timestamp("expiresAt").notNull(),
  token: text("token").notNull().unique(),
  ipAddress: text("ipAddress"),
  userAgent: text("userAgent"),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
  updatedAt: timestamp("updatedAt").notNull().defaultNow(),
});

export const account = pgTable("account", {
  id: text("id").primaryKey(),
  userId: text("userId")
    .notNull()
    .references(() => user.id, { onDelete: "cascade" }),
  accountId: text("accountId").notNull(),
  providerId: text("providerId").notNull(),
  password: text("password"),
  type: text("type"),
  provider: text("provider"),
  providerAccountId: text("providerAccountId"),
  refresh_token: text("refresh_token"),
  access_token: text("access_token"),
  expires_at: timestamp("expires_at"),
  token_type: text("token_type"),
  scope: text("scope"),
  id_token: text("id_token"),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
  updatedAt: timestamp("updatedAt").notNull().defaultNow(),
});
```

### Pages & Blocks Schema Pattern

```typescript
import { pgTable, serial, text, timestamp, boolean, json, integer } from "drizzle-orm/pg-core";

export const pages = pgTable("pages", {
  id: serial("id").primaryKey(),
  userId: text("userId")
    .notNull()
    .references(() => user.id, { onDelete: "cascade" }),
  title: text("title").notNull(),
  slug: text("slug").notNull().unique(),
  description: text("description"),
  theme: text("theme").default("cerberus"),
  isPublished: boolean("isPublished").notNull().default(false),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
  updatedAt: timestamp("updatedAt").notNull().defaultNow(),
});

export const blocks = pgTable("blocks", {
  id: serial("id").primaryKey(),
  pageId: integer("pageId")
    .notNull()
    .references(() => pages.id, { onDelete: "cascade" }),
  type: text("type").notNull(), // header, link, social, cta, embed
  content: json("content").notNull(),
  style: json("style").$type<Record<string, any>>(),
  order: integer("order").notNull(),
  visible: boolean("visible").notNull().default(true),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
  updatedAt: timestamp("updatedAt").notNull().defaultNow(),
});
```

### Events/Analytics Schema Pattern

```typescript
import { pgTable, serial, text, timestamp, integer, json } from "drizzle-orm/pg-core";

export const events = pgTable("events", {
  id: serial("id").primaryKey(),
  pageId: integer("pageId")
    .notNull()
    .references(() => pages.id, { onDelete: "cascade" }),
  blockId: integer("blockId"),
  eventType: text("eventType").notNull(), // view, click, submit
  referrer: text("referrer"),
  utm: json("utm").$type<Record<string, any>>(),
  device: text("device").notNull(), // mobile, desktop, tablet
  userAgent: text("userAgent"),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
});
```

## CRUD Patterns

### Insert Pattern

```typescript
import { db } from "$lib/db";
import { users } from "$lib/db/schema";

const newUser = await db.insert(users).values({
  email: "user@example.com",
  name: "John Doe",
}).returning();
```

### Select Pattern

```typescript
// Select all
const allUsers = await db.select().from(users);

// Select with conditions
const activeUsers = await db.select()
  .from(users)
  .where(eq(users.emailVerified, true));

// Select single
const user = await db.select()
  .from(users)
  .where(eq(users.id, userId))
  .limit(1);
```

### Update Pattern

```typescript
await db.update(users)
  .set({ name: "New Name" })
  .where(eq(users.id, userId));
```

### Delete Pattern

```typescript
await db.delete(users)
  .where(eq(users.id, userId));
```

## Migrations Workflow

### 1. Generate Migration

```bash
npx drizzle-kit generate
```

This creates a migration file in `./drizzle/xxx.sql`.

### 2. Apply Migration (Development)

```bash
npx drizzle-kit push
```

This applies schema changes directly to the database.

### 3. Apply Migration (Production)

```bash
npx drizzle-kit migrate
```

This runs migrations using the migration files.

## PostgreSQL Database Creation

### Create Database and User

```bash
# Connect to PostgreSQL
psql -h 192.168.1.110 -U postgres

# Create database
CREATE DATABASE segre_vip_dev;

# Create user
CREATE USER segre_vip WITH PASSWORD 'your-secure-password';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE segre_vip_dev TO segre_vip;

# Connect to database and grant schema privileges
\c segre_vip_dev
GRANT ALL ON SCHEMA public TO segre_vip;
```

### Database Connection String

```env
# Development
DATABASE_URL=postgresql://segre_vip:your-password@192.168.1.110:5432/segre_vip_dev

# Production
DATABASE_URL=postgresql://segre_vip:your-password@192.168.1.110:5432/segre_vip_prod
```

## Best Practices

1. **Type safety**: Always import types from your schema
2. **Query operators**: Use `eq`, `and`, `or`, `like`, `inArray` from `drizzle-orm`
3. **Relations**: Use `relations` to define relationships between tables
4. **Transactions**: Use `db.transaction()` for multiple operations
5. **Indexes**: Add indexes for frequently queried columns
6. **Soft deletes**: Use `deletedAt` timestamp instead of hard deletes
7. **Timestamps**: Always include `createdAt` and `updatedAt`

## Common Pitfalls

1. **Environment variables**: Use `$env/dynamic/private`, NOT `process.env` in SvelteKit
2. **Schema types**: Use correct types (`text`, `serial`, `integer`, `timestamp`)
3. **Foreign keys**: Ensure `references()` uses correct table and column
4. **Migrations**: Don't forget to generate and run migrations
5. **Connection pool**: Configure connection limits and timeouts
6. **JSON columns**: Use `.notNull()` and proper typing for JSON columns

---
**Database skill created. Use for Drizzle ORM patterns in SvelteKit projects.**
