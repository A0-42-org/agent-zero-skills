---
name: skeleton-ui
description: Skeleton UI integration for SvelteKit with Tailwind CSS theming and component library.
version: 1.0.0
author: Agent Zero Team
tags:
  - skeleton
  - tailwind
  - ui
  - components
  - theming
trigger_patterns:
  - skeleton ui
  - skeleton components
  - tailwind ui sveltekit
  - ui library
---

# Skeleton UI for SvelteKit

## Description
Skeleton UI est un système de design et une bibliothèque de composants pour SvelteKit, construit sur Tailwind CSS. Il fournit des composants "turnkey" basés sur Zag.js qui s'adaptent automatiquement au système de design Skeleton. Cette skill est optimisée pour Svelte 5 (runes) et SvelteKit.

## Catégorie
core

## Tags
skeleton, ui, design-system, components

## Trigger Patterns
skeleton, components, design, layout

## Installation

### Prérequis
- SvelteKit (v2+)
- Svelte (v5+)
- Tailwind CSS (v4+)

### Installation des paquets

```bash
pnpm add @skeletonlabs/skeleton-svelte @skeletonlabs/skeleton
```

### Configuration CSS

Dans votre fichier `app.css` (global stylesheet) :

```css
@import 'tailwindcss';
@plugin '@tailwindcss/forms';
@plugin '@tailwindcss/typography';

@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';

@custom-variant dark (&:where([data-mode="dark"], [data-mode="dark"] *));
```

### Configuration Tailwind v4

Assurez-vous d'utiliser le plugin Vite Tailwind :
```ts
// vite.config.ts
import tailwindcss from '@tailwindcss/vite';
import { sveltekit } from '@sveltejs/kit/vite';

export default {
  plugins: [
    tailwindcss(),
    
    sveltekit()
  ]
};
```

### Activation des Thèmes
Pour activer un thème Skeleton (ex: winter), ajoutez l'attribut `data-theme` dans `app.html` :

```html
<!-- app.html -->
<html data-theme="winter">
```

## Core API

Skeleton étend Tailwind avec des propriétés de thème personnalisées (`@theme`) et des utilitaires (`@utility`).

### Thèmes et Couleurs
Skeleton utilise des variables CSS pour les couleurs, l'espacement et la typographie.

- Couleurs : `--color-primary-500`, `--color-surface-50-950`, etc.
- Radius : `--radius-base`, `--radius-container`.
- Espacement : accessible via la fonction `--spacing(value)`.

### Thèmes Prédéfinis
Skeleton fournit des thèmes prédéfinis que vous pouvez activer via `data-theme` :

- **winter** : Thème bleu-froid, très utilisé (activé par défaut dans Vialto)
- **cerberus** : Thème rouge/sombre
- **midnight** : Thème nuit sombre
- **sahara** : Thème désert chaud
- **mona** : Thème élégant monochrome

### Classes de Thème Winter (Exemples)
Pour le thème winter, utilisez ces classes utilitaires :
```html
<!-- Surface colors -->
<div class="bg-surface-950-50 text-surface-0-950">
<div class="bg-surface-100-900 border border-surface-800-200">

<!-- Primary colors -->
<button class="bg-primary-500 hover:bg-primary-600 text-white">
<div class="text-surface-300-700">

<!-- Effects -->
<div class="backdrop-blur-lg">  <!-- Blur arrière-plan -->
```

### Dark Mode
Skeleton supporte plusieurs stratégies pour le Dark Mode (Media, Selector, Data Attribute). Pour un contrôle manuel (ex: switch) :

```css
/* app.css */
@custom-variant dark (&:where([data-mode=dark], [data-mode=dark] *));
```

```html
<!-- app.html -->
<html data-mode="dark">
```

## Components

Les composants Skeleton pour Svelte utilisent Svelte 5 Runes (`$props`, `$state`, snippets `{#snippet}`). Ils sont importés depuis `@skeletonlabs/skeleton-svelte`.

### Structure des Composants
La plupart des composants sont composés de sous-parties (ex: `Avatar.Root`, `Avatar.Image`).

### Exemple : Avatar

```svelte
<script lang="ts">
  import { Avatar } from '@skeletonlabs/skeleton-svelte';
</script>

<Avatar>
  <Avatar.Image src="https://i.pravatar.cc/150?img=48" alt="Jane Doe" />
  <Avatar.Fallback>SK</Avatar.Fallback>
</Avatar>
```

### Exemple : Accordion (avec Svelte 5 Runes et Snippets)

```svelte
<script lang="ts">
  import { Accordion } from '@skeletonlabs/skeleton-svelte';
  import { slide } from 'svelte/transition';
</script>

<Accordion>
  {#each ['1', '2', '3'] as item (item)}
    <Accordion.Item value="item-{item}">
      <h3>
        <Accordion.ItemTrigger>Item {item}</Accordion.ItemTrigger>
      </h3>
      <Accordion.ItemContent>
        {#snippet element(attributes)}
          {#if !attributes.hidden}
            <div {...attributes} transition:slide>
              Content for item {item}
            </div>
          {/if}
        {/snippet}
      </Accordion.ItemContent>
    </Accordion.Item>
  {/each}
</Accordion>
```

### Liste des Composants Principaux
- **Avatar** : Affichage d'images utilisateur avec fallback.
- **Button** : Boutons avec presets (`preset-filled`, `preset-outlined`).
- **Card** : Conteneurs stylisés.
- **Accordion** : Listes déroulantes.
- **Tabs** (anciennement TabGroup) : Navigation par onglets.
- **Dialog** (anciennement Modal) : Fenêtres modales et overlays.
- **Toast** (anciennement Toaster) : Notifications.
- **Slider** (anciennement RangeSlider) : Contrôle de valeur via glissière.
- **Switch** (anciennement SlideToggle) : Interrupteurs.
- **Input/Select/Textarea** : Champs de formulaire stylisés (Tailwind components).
- **Navigation** : Barres de navigation et rails (anciennement AppRail).

### Styling Components

Les composants acceptent l'attribut `class` pour appliquer des utilitaires Tailwind.
```svelte
<Button class="w-full rounded-full">Click me</Button>
```

## Patterns

### Composed Pattern
Les composants sont granulaires. Vous pouvez passer des props arbitraires (`data-*`, `style`, `class`) aux sous-parties.

### Data Model Pattern (Controlled)
Skeleton suit les conventions Zag.js : prop pour la donnée entrante, event handler pour la donnée sortante.
```svelte
<script lang="ts">
  import { Switch } from '@skeletonlabs/skeleton-svelte';
  let checked = $state(false);
</script>

<Switch
  checked={checked}
  onCheckedChange={(e) => (checked = e.checked)}
>
  <Switch.Control>
    <Switch.Thumb />
  </Switch.Control>
  <Switch.Label>Label</Switch.Label>
  <Switch.HiddenInput />
</Switch>
```

### Layouts avec Semantic HTML

Skeleton recommande d'utiliser du HTML sémantique (`<header>`, `<main>`, `<aside>`, `<footer>`) combiné avec les classes utilitaires Tailwind pour créer des mises en page responsive.
```svelte
<div class="grid grid-cols-1 md:grid-cols-[auto_1fr]">
  <aside class="hidden md:block">Sidebar</aside>
  <main>Content</main>
</div>
```

## Patterns Pratiques (Exemples Réels)

### Navbar Responsive avec Blur
```svelte
<script lang="ts">
  import { Button } from '@skeletonlabs/skeleton-svelte';
  let mobileMenuOpen = $state(false);
</script>

<nav class="fixed top-0 left-0 right-0 z-50 bg-surface-950-50 border-b border-surface-800-200 backdrop-blur-lg">
  <div class="container mx-auto px-4 py-3 flex items-center justify-between">
    <!-- Logo -->
    <a href="/" class="text-xl font-bold">Vialto</a>

    <!-- Desktop Navigation -->
    <div class="hidden md:flex gap-6">
      <a href="/features" class="text-surface-300-700 hover:text-primary-500">Features</a>
      <a href="/pricing" class="text-surface-300-700 hover:text-primary-500">Pricing</a>
    </div>

    <!-- Mobile Menu -->
    <button onclick={() => mobileMenuOpen = !mobileMenuOpen} class="md:hidden">
      <svg class="size-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
      </svg>
    </button>
  </div>

  {#if mobileMenuOpen}
    <div class="md:hidden bg-surface-950-50 border-t border-surface-800-200">
      <div class="container mx-auto px-4 py-4 flex flex-col gap-4">
        <a href="/features">Features</a>
        <a href="/pricing">Pricing</a>
      </div>
    </div>
  {/if}
</nav>
```

### Cards Grid Layout
```svelte
<div class="container mx-auto px-4 py-12">
  <h2 class="text-3xl font-bold mb-8 text-surface-0-950">Nos Avantages</h2>

  <div class="grid md:grid-cols-3 gap-6">
    {#each advantages as advantage}
      <div class="card bg-surface-50-950 border border-surface-800-200 p-6 hover:border-primary-500 transition-colors">
        <h3 class="text-xl font-semibold mb-2">{advantage.title}</h3>
        <p class="text-surface-600-400">{advantage.description}</p>
      </div>
    {/each}
  </div>
</div>
```

### Button avec Presets
```svelte
<!-- Primary Button -->
<Button class="preset-filled-primary-500 w-full">Get Started</Button>

<!-- Outlined Button -->
<Button class="preset-outlined-surface-800-200">Learn More</Button>
<!-- Tonal Button -->
<Button class="preset-tonal">Secondary</Button>
```

## Svelte 5 Syntax Spécifique
### Utilisation de children() au lieu de <slot />
Dans les composants Layout, utilisez la nouvelle syntaxe Svelte 5 :
```svelte
<script lang="ts">
  // ❌ Ancienne syntaxe Svelte 4
  // <slot />

  // ✅ Nouvelle syntaxe Svelte 5
  let { children } = $props();
</script>

{@render children()}
```
### Runes dans les Composants
```svelte
<script lang="ts">
  import { Button } from '@skeletonlabs/skeleton-svelte';

  // State réactif
  let count = $state(0);

  // Valeur dérivée
  const doubled = $derived(count * 2);

  // Effet de bord
  $effect(() => {
    console.log('Count changed:', count);
  });

  function increment() {
    count += 1;
  }
</script>

<div class="p-4">
  <p>Count: {count}, Doubled: {doubled}</p>
  <Button onclick={increment}>Increment</Button>
</div>
```

## Refactoring Workflow UI
Si vous devez refactoriser toute l'UI d'un projet avec Skeleton UI, suivez ce processus étape par étape :

### 1. Nettoyage
Supprimez les fichiers CSS et composants obsolètes :
```bash
# Supprimer les fichiers CSS personnalisés
rm src/app.css
rm src/lib/ui/*.svelte  # Si vous aviez des composants UI personnalisés
```

### 2. Configuration
Activez le thème dans `app.html` :
```html
<html data-theme="winter">
```

### 3. Layout (Navbar + Footer)
Créez ou mettez à jour les composants de layout :
```bash
# Composants à créer
src/lib/components/layout/navbar.svelte
src/lib/components/layout/footer.svelte
```
### 4. Landing Page Components
Créez les composants de la landing page :
```bash
src/routes/(landing)/hero.svelte
src/routes/(landing)/reward.svelte
src/routes/(landing)/howto.svelte
src/routes/(landing)/cta.svelte
```
### 5. Public Routes
Mettez à jour les routes publiques :
```bash
src/routes/(public)/login/+page.svelte
src/routes/(public)/signup/+page.svelte
src/routes/(public)/forgot-password/+page.svelte
src/routes/(public)/reset-password/+page.svelte
```
### 6. Protected Routes
Mettez à jour les routes protégées :
```bash
src/routes/(protected)/dashboard/+page.svelte
src/routes/(protected)/referrals/+page.svelte
src/routes/(protected)/gifts/+page.svelte
```
### 7. Admin Routes
Mettez à jour les routes admin :
```bash
src/routes/(protected)/admin/+page.svelte
```

### Git Workflow pour le Refactoring
```bash
# Créer une branche de refactoring
git checkout -b feat/refactor-ui-skeleton

# Committer chaque étape
git add -A && git commit -m "style: activate winter theme in app.html"
git add -A && git commit -m "style: refactor navbar with Skeleton UI"
# Merge dans main
git checkout main && git merge feat/refactor-ui-skeleton
git branch -d feat/refactor-ui-skeleton
```

## Conventions de Nommage
Pour SvelteKit, les composants Skeleton sont importés depuis `@skeletonlabs/skeleton-svelte`. Il n'y a pas de préfixe obligatoire dans le code, mais il est recommandé de suivre la structure granulaire des composants (Root + Sub-parts).

## Resources
### Documentation Officielle
- Docs Officielles : https://skeleton.dev/
- GitHub : https://github.com/skeletonlabs/skeleton
### Documentation LLM Optimisée
- `llms-svelte.txt` : Documentation complète optimisée pour les LLMs (fichier présent dans ce skill)
### Ressources Utiles
- LLM Standard : https://llmstxt.org/
- Shiki : https://shiki.style/ (pour le coloration syntaxique)
- Zag.js : https://zagjs.com/ (framework sous-jacent des composants)
