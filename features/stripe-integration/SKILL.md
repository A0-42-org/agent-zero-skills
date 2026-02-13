# Stripe Integration for SvelteKit SaaS

## When to Use
Use this skill when integrating Stripe payments into a SvelteKit-based SaaS application, especially for Segre.vip which uses:
- SvelteKit v2 with TypeScript
- Better Auth for authentication
- Drizzle ORM (SQLite/PostgreSQL)
- Stripe Payment Links for "redirect-only" payments
- Subscription management

## Core Concepts for Segre.vip

### 1. Payment Architecture (Redirect-Only)

Segre.vip uses **Stripe Payment Links** as the primary payment method:

```mermaid
User → Offer Page → Click CTA → Redirect to Stripe Payment Link → Payment/Booking on Stripe
```

**Benefits:**
- Minimal PCI compliance (Stripe handles everything)
- Fast implementation
- Supports one-time payments and subscriptions
- Calendly and Stripe links work identically

### 2. Subscription Tiers

| Plan | Price | Features |
|------|-------|----------|
| Free | €0 | 1 bio + 1 offer page, basic analytics |
| Pro | ~€19/mo | Custom domain, premium templates, scheduling |
| Elite | ~€49/mo | Multi-profiles, API/webhooks, white-label |

### 3. Webhook Events

**Critical Events:**
- `checkout.session.completed` - Payment succeeded
- `customer.subscription.created` - New subscription
- `customer.subscription.updated` - Plan change
- `customer.subscription.deleted` - Cancellation
- `invoice.payment_succeeded` - Recurring payment
- `invoice.payment_failed` - Payment failed

## Prerequisites

### Environment Variables

```env
# .env
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_PRICE_ID_PRO=price_...
STRIPE_PRICE_ID_ELITE=price_...
```

### Dependencies

```bash
bun add stripe
bun add -d @types/stripe
```

### Database Schema (Drizzle)

```typescript
// src/lib/db/schema.ts
import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";
import { relations } from "drizzle-orm";

export const subscriptions = sqliteTable("subscriptions", {
id: integer("id").primaryKey({ autoIncrement: true }),
userId: integer("user_id").notNull().references(() => users.id),
stripeSubscriptionId: text("stripe_subscription_id").unique(),
stripeCustomerId: text("stripe_customer_id"),
status: text("status").notNull(), // active, canceled, past_due, trialing
plan: text("plan").notNull(), // free, pro, elite
currentPeriodEnd: integer("current_period_end", { mode: "timestamp" }),
cancelAtPeriodEnd: integer("cancel_at_period_end", { mode: "boolean" }).default(false),
createdAt: integer("created_at", { mode: "timestamp" }).notNull(),
updatedAt: integer("updated_at", { mode: "timestamp" }).notNull()
});

export const payments = sqliteTable("payments", {
id: integer("id").primaryKey({ autoIncrement: true }),
userId: integer("user_id").notNull().references(() => users.id),
subscriptionId: integer("subscription_id").references(() => subscriptions.id),
stripePaymentIntentId: text("stripe_payment_intent_id").unique(),
stripeCheckoutSessionId: text("stripe_checkout_session_id"),
amount: integer("amount").notNull(), // in cents
currency: text("currency").notNull().default("eur"),
status: text("status").notNull(), // succeeded, failed, pending
createdAt: integer("created_at", { mode: "timestamp" }).notNull()
});
```

## Implementation

### 1. Stripe Client Setup

```typescript
// src/lib/stripe/index.ts
import Stripe from 'stripe';

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
apiVersion: '2024-11-20.acacia',
typescript: true
});

// Price IDs for subscriptions
export const PRICE_IDS = {
pro: process.env.STRIPE_PRICE_ID_PRO!,
elite: process.env.STRIPE_PRICE_ID_ELITE!
} as const;

// Plan names
export const PLANS = {
free: 'free',
pro: 'pro',
elite: 'elite'
} as const;

export type Plan = keyof typeof PLANS;
```

### 2. Customer Management

```typescript
// src/lib/stripe/customer.ts
import { stripe } from './index';
import { db } from '$lib/db';
import { users } from '$lib/db/schema';

export async function createCustomer(userEmail: string, userName: string) {
const customer = await stripe.customers.create({
email: userEmail,
name: userName,
metadata: {
userId: userEmail // Using email as ID for now
}
});

// Update user with Stripe customer ID
await db.update(users)
.set({ stripeCustomerId: customer.id })
.where(eq(users.email, userEmail));

return customer;
}

export async function getOrCreateCustomer(userEmail: string, userName: string) {
// Check if user already has a Stripe customer
const user = await db.query.users.findFirst({
where: eq(users.email, userEmail)
});

if (user?.stripeCustomerId) {
return await stripe.customers.retrieve(user.stripeCustomerId);
}

return await createCustomer(userEmail, userName);
}
```

### 3. Checkout Session Creation

```typescript
// src/lib/stripe/checkout.ts
import { stripe, PRICE_IDS } from './index';

export async function createCheckoutSession(
customerId: string,
plan: 'pro' | 'elite',
successUrl: string,
cancelUrl: string
) {
const session = await stripe.checkout.sessions.create({
customer: customerId,
payment_method_types: ['card'],
line_items: [
{
price: PRICE_IDS[plan],
quantity: 1
}
],
mode: 'subscription',
success_url: successUrl,
cancel_url: cancelUrl,
metadata: {
plan: plan
}
});

return session;
}

// Create a one-time payment checkout (for one-time offers)
export async function createOneTimeCheckoutSession(
customerId: string,
amount: number, // in cents
currency: string = 'eur',
successUrl: string,
cancelUrl: string
) {
const session = await stripe.checkout.sessions.create({
customer: customerId,
payment_method_types: ['card'],
line_items: [
{
price_data: {
