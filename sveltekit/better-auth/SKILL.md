---
name: better-auth-svelte
description: Install and configure BetterAuth authentication system for SvelteKit
  projects. Use when setting up email/password authentication, OAuth providers, session
  management, and protected routes with BetterAuth and SvelteKit. Covers database
  setup with Drizzle, route structure, and common pitfalls to avoid.
license: MIT
trigger_patterns:
- better-auth
- better auth
- authentication setup
- oauth integration
- email password auth
version: 1.0.0
author: Agent Zero Team
tags:
- authentication
- auth
- security
- sveltekit
- oauth
---

# BetterAuth for SvelteKit

Quick setup for BetterAuth authentication in SvelteKit projects.

## Installation

```bash
pnpm add better-auth drizzle-orm postgres
pnpm add -D drizzle-kit @types/pg
```

## Critical: Use Correct Imports

Always use Svelte-specific imports, NOT React:

```typescript
// ❌ WRONG - will cause build errors
import { createAuthClient } from "better-auth/react";

// ✅ CORRECT
import { createAuthClient } from "better-auth/svelte";
```

This is the most common error when integrating BetterAuth with SvelteKit.

## Setup Checklist

### 1. Environment Variables (.env)

```env
BETTER_AUTH_SECRET=generate-secure-secret-with-openssl-rand-base64-32
BETTER_AUTH_URL=http://localhost:5173
DATABASE_URL=postgresql://user:password@host:port/dbname

# Optional: Skip email verification (for development/testing)
SKIP_EMAIL_VERIFICATION=true
```

**Generate secure secret**:

```bash
openssl rand -base64 32
```

**Email Verification**:

- By default, email verification is **required** (`requireEmailVerification: true`)
- Set `SKIP_EMAIL_VERIFICATION=true` to skip email verification (useful for development)
- Remove the flag or set to `false` for production

**Generate secure secret**:

```bash
openssl rand -base64 32
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

### 3. Database Schema (src/lib/db/schema.ts)

**CRITICAL**: The schema MUST match BetterAuth's requirements exactly:

```typescript
import { pgTable, serial, text, timestamp, boolean } from "drizzle-orm/pg-core";

export const user = pgTable("user", {
  // IMPORTANT: id must be text, not serial
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
  // IMPORTANT: userId must be text to match user.id type
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
  // IMPORTANT: id must be text, not serial
  id: text("id").primaryKey(),
  // IMPORTANT: userId must be text to match user.id type
  userId: text("userId")
    .notNull()
    .references(() => user.id, { onDelete: "cascade" }),
  accountId: text("accountId").notNull(),
  providerId: text("providerId").notNull(),
  password: text("password"),
  // IMPORTANT: these fields must be nullable (no .notNull())
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

export const verification = pgTable("verification", {
  id: serial("id").primaryKey(),
  identifier: text("identifier").notNull(),
  value: text("value").notNull(),
  expiresAt: timestamp("expiresAt").notNull(),
  createdAt: timestamp("createdAt").notNull().defaultNow(),
});
```

### 4. Server Config (src/lib/auth.ts)

**IMPORTANT**: Use `$env/dynamic/private` for environment variables:

```typescript
import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { db } from "./db";
import * as schema from "./db/schema";
import { env } from "$env/dynamic/private";

// Optional: Skip email verification with environment variable
const skipEmailVerification = env.SKIP_EMAIL_VERIFICATION === "true";

export const auth = betterAuth({
  database: drizzleAdapter(db, {
    provider: "pg",
    schema: {
      user: schema.user,
      session: schema.session,
      account: schema.account,
      verification: schema.verification,
    },
  }),
  emailAndPassword: {
    enabled: true,
    // Use environment variable to control email verification
    requireEmailVerification: !skipEmailVerification,
    autoSignInAfterSignUp: true,
    sendResetPassword: async ({ user, url }) => {
      console.log("📧 PASSWORD RESET EMAIL", user.email, url);
    },
    sendVerificationEmail: async ({ user, url }) => {
      console.log("📧 VERIFICATION EMAIL", user.email, url);
    },
  },
  baseURL: env.BETTER_AUTH_URL || "http://localhost:5173",
  secret: env.BETTER_AUTH_SECRET,
});
```

### 5. Drizzle Config (drizzle.config.ts)

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

### 6. Client Config (src/lib/auth-client.ts)

```typescript
import { createAuthClient } from "better-auth/svelte";

export const authClient = createAuthClient({
  baseURL:
    typeof window !== "undefined"
      ? window.location.origin
      : "http://localhost:5173",
});
```

### 7. SvelteKit Hooks (src/hooks.server.ts)

```typescript
import { auth } from "$lib/auth";
import { svelteKitHandler } from "better-auth/svelte-kit";
import type { Handle } from "@sveltejs/kit";

export const handle: Handle = async ({ event, resolve }) => {
  event.locals.auth = auth;
  const response = await svelteKitHandler({
    auth,
    event,
    resolve,
    building: false,
  });
  return response;
};
```

### 8. Route Structure

```
src/routes/
├── (public)/              # Public auth pages
│   ├── login/+page.svelte
│   ├── signup/+page.svelte
│   └── forgot-password/+page.svelte
└── (protected)/           # Requires authentication
    └── +layout.server.ts  # Session check here
```

## PostgreSQL Setup Example

### Local PostgreSQL Example

```env
# Example for local PostgreSQL on 192.168.1.110:5432
DATABASE_URL=postgresql://vialto:password@192.168.1.110:5432/vialto
BETTER_AUTH_URL=http://localhost:5173
BETTER_AUTH_SECRET=your-generated-secret

# Skip email verification for development/testing (optional)
SKIP_EMAIL_VERIFICATION=true
```

### Create Database and User

```bash
# Connect to PostgreSQL
psql -h 192.168.1.110 -U postgres

# Create database
CREATE DATABASE vialto;

# Create user
CREATE USER vialto WITH PASSWORD 'password';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE vialto TO vialto;
\c vialto
GRANT ALL ON SCHEMA public TO vialto;
```

## Database Migrations

Generate and apply migrations:

```bash
# Generate migration file
npx drizzle-kit generate

# Apply to database (development)
npx drizzle-kit push

# Apply to database (production)
npx drizzle-kit migrate
```

## Protected Routes

Create `src/routes/(protected)/+layout.server.ts`:

```typescript
import { auth } from "$lib/auth";
import { redirect } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";

export const load: LayoutServerLoad = async ({ request }) => {
  const session = await auth.api.getSession({ headers: request.headers });

  if (!session) {
    throw redirect(302, "/login");
  }

  return { user: session.user };
};
```

## Testing

After setup, verify:

1. `pnpm check` passes (no TypeScript errors)
2. `pnpm lint` passes (no ESLint/Prettier errors)
3. Dev server starts without errors
4. No React import errors (use `better-auth/svelte`)
5. Database migrations run successfully
6. Signup creates user in database with account record
7. Login works with email/password
8. Session persists across page refreshes
9. Protected routes redirect to `/login` when not authenticated

## Common Pitfalls

1. **React imports**: Always use `better-auth/svelte`, never `better-auth/react`
2. **Environment variables**: Use `$env/dynamic/private`, NOT `process.env` in SvelteKit
3. **Schema ID types**: `user.id`, `session.userId`, `account.id`, `account.userId` MUST be `text`, not `serial`
4. **Account table fields**: `accountId`, `providerId`, `password` must exist; `type`, `provider`, `providerAccountId` must be nullable
5. **Database migrations**: Don't forget to generate and run Drizzle migrations
6. **SSR vs client**: Use `authClient.useSession()` for reactive client-side state
7. **PostgreSQL connection**: Ensure user exists and has privileges on the database
8. **Email verification**: By default required, set `SKIP_EMAIL_VERIFICATION=true` in `.env` for development
