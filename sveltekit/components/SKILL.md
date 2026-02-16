---
name: "sveltekit-components"
description: "Reusable component patterns for Svelte 5 with best practices. Covers $props, $state, $derived, $effect, slots, composition, TypeScript interfaces, and component exports."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["sveltekit", "components", "svelte-5", "runes", "typescript", "patterns"]
trigger_patterns:
  - "create component"
  - "reusable component"
  - "svelte 5 component"
  - "component pattern"
  - "props state derived"
  - "slot component"
  - "component export"
---

# SvelteKit Components Pattern

Complete guide for creating reusable components with Svelte 5 runes and TypeScript.

## Use Case

Use this skill when:
- Creating reusable UI components (buttons, cards, forms)
- Building complex components with state management
- Implementing component composition with slots
- Creating type-safe components with TypeScript
- Building block-based components (editor blocks, widgets)
- Need component export patterns

## Svelte 5 Runes Essentials

### Required Runes

Svelte 5 introduces runes for reactivity. ALWAYS use these runes:

| Rune | Purpose | Example |
|------|---------|---------|
| `$props()` | Define component props | `let { title, count = 0 }: Props = $props();` |
| `$state()` | Create reactive state | `let count = $state(0);` |
| `$derived()` | Create derived/computed values | `const doubled = $derived(count * 2);` |
| `$effect()` | Run side effects (replaces `onMount`) | `$effect(() => { console.log(count); });` |

### Component Structure Template

```svelte
<script lang="ts">
  // 1. Define TypeScript interface for props
  interface Props {
    title: string;
    count?: number;  // Optional
    onAction?: () => void;  // Optional callback
  }

  // 2. Destructure props with default values
  let { title, count = 0, onAction }: Props = $props();

  // 3. Create reactive state
  let localState = $state(false);

  // 4. Create derived values
  const displayCount = $derived(count + 1);

  // 5. Handle side effects
  $effect(() => {
    console.log('Count changed:', count);
  });

  // 6. Event handlers (use lowercase on*)
  function handleClick() {
    localState = !localState;
    onAction?.();
  }
</script>

<!-- 7. Use curly braces for expressions -->
<button onclick={handleClick}>
  {title}: {displayCount}
</button>

<!-- 8. Conditional rendering -->
{#if localState}
  <p>State is true</p>
{/if}
```

## Component Types

### Basic Presentational Component

```svelte
<script lang="ts">
  interface Props {
    label: string;
    variant?: 'primary' | 'secondary';
    disabled?: boolean;
  }

  let { label, variant = 'primary', disabled = false }: Props = $props();
</script>

<button 
  class="btn {variant}"
  {disabled}
>
  {label}
</button>

<style>
  .btn {
    padding: 0.5rem 1rem;
    border-radius: 0.375rem;
    font-weight: 500;
  }
  .btn.primary {
    background-color: #8b5cf6;
    color: white;
  }
  .btn.secondary {
    background-color: #e5e7eb;
    color: #1f2937;
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
```

### Stateful Component

```svelte
<script lang="ts">
  interface Props {
    initialCount: number;
  }

  let { initialCount }: Props = $props();
  let count = $state(initialCount);
  const isPositive = $derived(count > 0);

  function increment() {
    count += 1;
  }

  function decrement() {
    count -= 1;
  }
</script>

<div class="counter">
  <button onclick={decrement}>-</button>
  <span class:positive={isPositive}>{count}</span>
  <button onclick={increment}>+</button>
</div>

<style>
  .counter {
    display: flex;
    align-items: center;
    gap: 1rem;
  }
  .positive {
    color: green;
  }
</style>
```

### Component with Slots

```svelte
<!-- Card.svelte -->
<script lang="ts">
  interface Props {
    title: string;
  }

  let { title }: Props = $props();
</script>

<div class="card">
  <h2 class="card-title">{title}</h2>
  
  <!-- Default slot -->
  <div class="card-content">
    {@render children?.()}
  </div>
  
  <!-- Named slots -->
  {#if footer}
    <div class="card-footer">
      {@render footer()}
    </div>
  {/if}
</div>

<style>
  .card {
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    padding: 1rem;
  }
  .card-title {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
  }
  .card-content {
    margin-bottom: 1rem;
  }
  .card-footer {
    border-top: 1px solid #e5e7eb;
    padding-top: 0.5rem;
  }
</style>
```

### Using Slots Component

```svelte
<script lang="ts">
  import Card from "$lib/components/Card.svelte";
</script>

<Card title="My Card">
  <p>Default slot content</p>
  
  <svelte:fragment slot="footer">
    <button>Action</button>
  </svelte:fragment>
</Card>
```

### Block Component (Editor Block Pattern)

```svelte
<!-- HeaderBlock.svelte -->
<script lang="ts">
  import { trackClick } from "$lib/analytics/actions";

  interface Props {
    data: {
      title: string;
      subtitle?: string;
    };
    pageId: string;
  }

  let { data, pageId }: Props = $props();
  const hasSubtitle = $derived(!!data.subtitle);

  function handleClick() {
    trackClick({ pageId, elementId: 'header', elementUrl: window.location.href });
  }
</script>

<div class="header-block" onclick={handleClick}>
  <h1 class="header-title">{data.title}</h1>
  {#if hasSubtitle}
    <p class="header-subtitle">{data.subtitle}</p>
  {/if}
</div>

<style>
  .header-block {
    padding: 2rem;
    text-align: center;
  }
  .header-title {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
  }
  .header-subtitle {
    font-size: 1.125rem;
    color: #6b7280;
  }
</style>
```

## Component Composition Patterns

### Render Props Pattern

```svelte
<!-- List.svelte -->
<script lang="ts">
  interface Props<T> {
    items: T[];
    render: (item: T) => Snippet;
  }

  let { items, render }: Props<T> = $props();
</script>

<ul>
  {#each items as item}
    <li>{@render render(item)}</li>
  {/each}
</ul>
```

### Using Render Props

```svelte
<script lang="ts">
  import List from "$lib/components/List.svelte";

  const users = [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' }
  ];
</script>

<List items={users}>
  {#snippet render(user)}
    <span>{user.name}</span>
  {/snippet}
</List>
```

## Component Export Pattern

### Exporting Components

Always use named exports for components:

```typescript
// src/lib/components/index.ts
export { default as Button } from './Button.svelte';
export { default as Card } from './Card.svelte';
export { default as HeaderBlock } from './blocks/HeaderBlock.svelte';
export { default as LinkBlock } from './blocks/LinkBlock.svelte';
```

### Importing Components

```svelte
<script lang="ts">
  import { Button, Card } from "$lib/components";
</script>
```

## Event Handling

### Event Handlers

Use lowercase `on*` syntax (not `on:click`):

```svelte
<!-- ✅ CORRECT - Svelte 5 syntax -->
<button onclick={handleClick}>Click</button>
<input oninput={handleInput} />
<form onsubmit={handleSubmit}>
  <button type="submit">Submit</button>
</form>

<!-- ❌ WRONG - Old Svelte syntax -->
<button on:click={handleClick}>Click</button>
```

### Event Modifiers

```svelte
<script lang="ts">
  function handleClick(e: MouseEvent) {
    e.preventDefault();
    console.log('Clicked');
  }
</script>

<button onclick={handleClick}>
  Click with preventDefault
</button>
```

## Type Safety with TypeScript

### Prop Interfaces

```svelte
<script lang="ts">
  interface Props {
    title: string;
    count: number;
    items: string[];
    metadata?: Record<string, any>;
    onSubmit: (data: { title: string }) => void;
  }

  let { title, count, items, metadata, onSubmit }: Props = $props();
</script>
```

### Generic Components

```svelte
<script lang="ts" generics="T">
  interface Props<T> {
    items: T[];
    renderItem: (item: T) => string;
  }

  let { items, renderItem }: Props<T> = $props();
  const displayItems = $derived(items.map(renderItem));
</script>

<ul>
  {#each displayItems as item}
    <li>{item}</li>
  {/each}
</ul>
```

## Component Lifecycle

### Mounting Effects

```svelte
<script lang="ts">
  $effect(() => {
    // Runs on mount and when dependencies change
    console.log('Component mounted');
    
    return () => {
      // Cleanup on unmount
      console.log('Component unmounted');
    };
  });
</script>
```

### One-time Initialization

```svelte
<script lang="ts">
  let initialized = $state(false);

  $effect(() => {
    if (!initialized) {
      // Initialize once
      fetchData();
      initialized = true;
    }
  });
</script>
```

## Reusable Patterns

### Loading Button

```svelte
<script lang="ts">
  interface Props {
    label: string;
    loading?: boolean;
    disabled?: boolean;
    onclick?: () => void;
  }

  let { label, loading = false, disabled = false, onclick }: Props = $props();
  const isLoading = $derived(loading || disabled);
</script>

<button 
  class="loading-button"
  disabled={isLoading}
  onclick={onclick}
>
  {#if loading}
    <span class="spinner"></span>
  {:else}
    {label}
  {/if}
</button>

<style>
  .loading-button {
    position: relative;
  }
  .spinner {
    display: inline-block;
    width: 1rem;
    height: 1rem;
    border: 2px solid transparent;
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>
```

### Modal Component

```svelte
<script lang="ts">
  interface Props {
    open: boolean;
    title: string;
    onClose: () => void;
  }

  let { open, title, onClose }: Props = $props();

  $effect(() => {
    if (open) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'auto';
    }
  });
</script>

{#if open}
  <div class="modal-overlay" onclick={onClose}>
    <div class="modal-content" onclick={(e) => e.stopPropagation()}>
      <h2>{title}</h2>
      {@render children?.()}
      <button onclick={onClose}>Close</button>
    </div>
  </div>
{/if}

<style>
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .modal-content {
    background: white;
    padding: 1rem;
    border-radius: 0.5rem;
    max-width: 32rem;
  }
</style>
```
## Best Practices

### 1. Always Use TypeScript

```svelte
<!-- ✅ GOOD -->
<script lang="ts">
  interface Props {
    title: string;
  }
  let { title }: Props = $props();
</script>

<!-- ❌ BAD -->
<script>
  let { title } = $props();
</script>
```

### 2. Use Destructuring for Props

```svelte
<!-- ✅ GOOD -->
let { title, count = 0 }: Props = $props();

<!-- ❌ BAD -->
const props = $props();
const title = props.title;
```

### 3. Always Use Default Values

```svelte
<!-- ✅ GOOD -->
let { count = 0 }: Props = $props();

<!-- ❌ BAD -->
let { count }: Props = $props();
```

### 4. Use $derived for Computed Values

```svelte
<!-- ✅ GOOD -->
const doubled = $derived(count * 2);

<!-- ❌ BAD -->
let doubled;
$effect(() => {
  doubled = count * 2;
});
```

### 5. Use $effect for Side Effects

```svelte
<!-- ✅ GOOD -->
$effect(() => {
  document.title = `Count: ${count}`;
});

<!-- ❌ BAD - Old Svelte -->
$: document.title = `Count: ${count}`;
```

### 6. Use Lowercase Event Handlers

```svelte
<!-- ✅ GOOD -->
<button onclick={handleClick}>Click</button>

<!-- ❌ BAD - Old Svelte -->
<button on:click={handleClick}>Click</button>
```

## Component Checklist

Before finishing a component, verify:

- [ ] Props defined with TypeScript interface
- [ ] Props destructured with $props()
- [ ] Default values provided for optional props
- [ ] State uses $state()
- [ ] Derived values use $derived()
- [ ] Side effects use $effect()
- [ ] Event handlers use lowercase on* syntax
- [ ] Component exported if needed
- [ ] Slots used for composition
- [ ] Styles scoped with `<style>`
- [ ] Accessibility attributes included
- [ ] TypeScript errors resolved

## Common Pitfalls

### 1. Not Using TypeScript Interface
```svelte
<!-- ❌ BAD -->
let { title, count } = $props();

<!-- ✅ GOOD -->
interface Props {
  title: string;
  count?: number;
}
let { title, count = 0 }: Props = $props();
```

### 2. Using Old Svelte Syntax
```svelte
<!-- ❌ BAD - Old Svelte -->
<button on:click={handleClick}>Click</button>

<!-- ✅ GOOD - Svelte 5 -->
<button onclick={handleClick}>Click</button>
```

### 3. Not Destructuring Props
```svelte
<!-- ❌ BAD -->
const props = $props();
const title = props.title;

<!-- ✅ GOOD -->
let { title }: Props = $props();
```

### 4. Mutating Props Directly
```svelte
<!-- ❌ BAD -->
let { count }: Props = $props();
function increment() {
  count += 1; // ERROR!
}

<!-- ✅ GOOD -->
let { count, onUpdate }: Props = $props();
function increment() {
  onUpdate(count + 1);
}
```

### 5. Not Cleaning Up Effects
```svelte
<!-- ❌ BAD -->
$effect(() => {
  setInterval(() => {
    console.log('tick');
  }, 1000);
  // Memory leak!
});

<!-- ✅ GOOD -->
$effect(() => {
  const interval = setInterval(() => {
    console.log('tick');
  }, 1000);
  return () => clearInterval(interval);
});
```

### 6. Using $ for Reactivity in Old Style
```svelte
<!-- ❌ BAD - Old Svelte -->
$: doubled = count * 2;

<!-- ✅ GOOD - Svelte 5 -->
const doubled = $derived(count * 2);
```

## Testing

After creating components, verify:

1. `bun check` passes (no TypeScript errors)
2. Component renders without errors
3. Props work correctly with types
4. State updates trigger re-renders
5. Derived values update correctly
6. Effects run on mount and update
7. Event handlers work as expected
8. Slots render correctly
9. Styles apply correctly
10. Component exports work

---
**Use this skill to create reusable, type-safe components with Svelte 5 runes and best practices.**
