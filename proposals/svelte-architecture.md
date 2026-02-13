# Proposition d'Architecture - Agent Svelte & Skills

## 📊 Analyse Actuelle

### Skills Existantes
| Skill | Taille | Redondance | Problème |
|-------|--------|------------|----------|
| **better-auth-svelte** | ~200 lignes | Faible | PostgreSQL seulement (projet utilise SQLite) |
| **sveltekit-fullstack** | ~300 lignes | Élevée | Duplique beaucoup de contenu des autres skills |
| **skeleton-ui-svelte** | ~100 lignes | Faible | Bien spécifique |
| **stripe-integration** | ~150 lignes | Faible | Bien spécifique |
| **create-skill** | ~50 lignes | Aucune | Outil général |

### Problèmes Identifiés
1. **Redondance**: `sveltekit-fullstack` duplique BetterAuth, Skeleton UI, Drizzle
2. **Incohérence**: `better-auth-svelte` utilise PostgreSQL alors que le projet Segre.vip utilise SQLite
3. **Manque de modularité**: Skills trop larges, difficiles à maintenir
4. **Pas de workflows**: Pas de séquences claires pour créer des fonctionnalités

---

## 🎯 Architecture Proposée

### 1. Skills Modulaires par Responsabilité

```
Skills/
├── core/                         # Skills essentielles (tous les projets)
│   ├── sveltekit-bootstrap/        # Initialisation projet complet
│   ├── sveltekit-authentication/  # BetterAuth + Drizzle (SQLite + PostgreSQL)
│   └── sveltekit-ui-framework/     # Skeleton UI v4 + Tailwind CSS v4
├── features/                      # Skills fonctionnalités spécifiques
│   ├── sveltekit-database/        # Drizzle ORM patterns, migrations, queries
│   ├── sveltekit-editor/          # Page editor, drag-drop, templates
│   ├── sveltekit-theming/         # Theme system, color schemes, dark mode
│   ├── sveltekit-analytics/       # Tracking, dashboards, statistics
│   └── sveltekit-payments/        # Stripe integration (redirection-only)
├── patterns/                      # Skills best practices
│   ├── sveltekit-components/      # Component patterns, reusability
│   ├── sveltekit-forms/           # Forms, validation, Zod, superforms
│   ├── sveltekit-server-actions/  # Server actions, mutations, API routes
│   └── sveltekit-performance/     # Optimization, caching, SEO
└── workflows/                     # Skills workflows multi-étapes
    ├── sveltekit-auth-workflow/   # Setup auth complet
    ├── sveltekit-dashboard/       # User dashboard pattern
    └── sveltekit-admin/           # Admin dashboard pattern
```

### 2. Mapping Skills → Responsabilités

| Skill | Responsabilité | Contenu |
|-------|----------------|---------|
| **sveltekit-bootstrap** | Initialisation | `bunx sv create`, config TypeScript, ESLint, Prettier, Vite, Tailwind, Playwright |
| **sveltekit-authentication** | Auth & DB | BetterAuth server/client, Drizzle schema (SQLite + PostgreSQL), migrations, env vars, protected routes |
| **sveltekit-ui-framework** | UI setup | Skeleton UI v4, Tailwind CSS v4, themes Cerberus, app.html, layout.css |
| **sveltekit-database** | DB patterns | Drizzle ORM CRUD, queries, relations, migrations workflow, seed data |
| **sveltekit-editor** | Page editing | Block system, svelte-dnd-action, auto-save, preview, templates |
| **sveltekit-theming** | Themes | Theme definitions, ThemeProvider, CSS variables, theme switching |
| **sveltekit-analytics** | Analytics | Events tracking (views/clicks), device detection, stats dashboard, charts |
| **sveltekit-payments** | Payments | Stripe integration, Payment Links, webhooks, subscriptions |
| **sveltekit-components** | Patterns | Component architecture, reusability, TypeScript strict types |
| **sveltekit-forms** | Forms | Form validation, Zod schemas, error handling, success states |
| **sveltekit-server-actions** | Backend | Server actions, mutations, API routes, error handling |
| **sveltekit-performance** | Optimisation | SSR, lazy loading, image optimization, caching, SEO |
| **sveltekit-auth-workflow** | Auth complet | Signup → Verify email → Login → Forgot password → Reset |
| **sveltekit-dashboard** | Dashboard | Page list, stats, quick actions, settings, profile |
| **sveltekit-admin** | Admin dashboard | User management, page moderation, analytics, settings |

### 3. Amélioration du Profile Agent Svelte

```
Profile: svelte

Responsabilités:
- TOUS les projets Svelte et SvelteKit
- Applications web fullstack par défaut

Stack Principale:
- SvelteKit 2 + TypeScript (strict mode)
- Svelte 5 runes (runes mode: $state, $derived, $props, $effect)
- Skeleton UI v4 + Tailwind CSS v4
- BetterAuth + Drizzle ORM
- SQLite (dev) / PostgreSQL (prod)

Comportement:
1. Toujours utiliser Svelte 5 runes (pas de syntaxe obsolète)
2. Toujours utiliser better-auth/svelte (pas better-auth/react)
3. Toujours utiliser svelte-dnd-action pour drag-drop (pas @dnd-kit)
4. Toujours utiliser onclick, oninput (pas on:click, on:input)
5. Toujours utiliser $env/dynamic/private pour env vars (pas process.env)
6. Toujours créer des projets sur org GitHub A0-42-org

Skills à charger automatiquement:
- sveltekit-bootstrap (initialisation)
- sveltekit-authentication (setup auth)
- sveltekit-ui-framework (setup UI)

Workflow de développement:
1. Analyser les requirements du projet
2. Sélectionner les skills nécessaires (core + features + patterns)
3. Suivre les patterns et best practices
4. Implémenter avec Svelte 5 runes
5. Tester et déployer

MCP Tools:
- @modelcontextprotocol/server-svelte (documentation, autofix, playground)
- Utiliser pour: docs queries, code analysis, diagnostics, generation
```

---

## 🚀 Plan de Migration

### Phase 1: Reorganisation (Immédiat)

**Actions:**
1. Renommer/réorganiser les skills existants
2. Fusionner `sveltekit-fullstack` dans les skills spécifiques
3. Créer les dossiers `core/`, `features/`, `patterns/`, `workflows/`
4. Mettre à jour `better-auth-svelte` pour supporter SQLite + PostgreSQL

**Résultat attendu:**
- Structure claire et modulaire
- Pas de redondance
- Maintenance facile

### Phase 2: Création Skills Manquants (Semaine 1)

**Actions:**
1. Créer `sveltekit-bootstrap` (fusion de setup complet)
2. Créer `sveltekit-database` (Drizzle patterns)
3. Créer `sveltekit-editor` (editor patterns)
4. Créer `sveltekit-theming` (theme system)
5. Créer `sveltekit-analytics` (analytics patterns)
6. Créer `sveltekit-components` (component patterns)

**Résultat attendu:**
- Skills couvrant toutes les fonctionnalités
- Patterns réutilisables
- Documentation complète

### Phase 3: Création Workflows (Semaine 2)

**Actions:**
1. Créer `sveltekit-auth-workflow` (setup auth complet)
2. Créer `sveltekit-dashboard` (dashboard pattern)
3. Créer `sveltekit-admin` (admin pattern)

**Résultat attendu:**
- Workflows prêts à l'emploi
- Séquences claires pour les features complexes
- Rapidité de développement

### Phase 4: Intégration Agent Svelte (Semaine 2-3)

**Actions:**
1. Mettre à jour le profile `svelte` avec instructions complètes
2. Configurer les skills à charger par défaut
3. Intégrer MCP Svelte avec le workflow de développement
4. Créer des prompts templates pour les tâches courantes

**Résultat attendu:**
- Agent Svelte autonome et efficace
- Workflow fluide
- Productivité maximale

---

## 📋 Structure Finale Proposée

```
/a0/usr/skills/
├── core/
│   ├── sveltekit-bootstrap/
│   │   └── SKILL.md          # Initialisation projet complet
│   ├── sveltekit-authentication/
│   │   └── SKILL.md          # BetterAuth + Drizzle (SQLite + PostgreSQL)
│   └── sveltekit-ui-framework/
│       └── SKILL.md          # Skeleton UI v4 + Tailwind CSS v4
├── features/
│   ├── sveltekit-database/
│   │   └── SKILL.md          # Drizzle ORM patterns
│   ├── sveltekit-editor/
│   │   └── SKILL.md          # Page editor, drag-drop, templates
│   ├── sveltekit-theming/
│   │   └── SKILL.md          # Theme system, colors, dark mode
│   ├── sveltekit-analytics/
│   │   └── SKILL.md          # Tracking, dashboards, statistics
│   └── sveltekit-payments/
│       └── SKILL.md          # Stripe integration
├── patterns/
│   ├── sveltekit-components/
│   │   └── SKILL.md          # Component patterns, reusability
│   ├── sveltekit-forms/
│   │   └── SKILL.md          # Forms, validation, Zod
│   ├── sveltekit-server-actions/
│   │   └── SKILL.md          # Server actions, mutations
│   └── sveltekit-performance/
│       └── SKILL.md          # Optimization, SEO
├── workflows/
│   ├── sveltekit-auth-workflow/
│   │   └── SKILL.md          # Setup auth complet
│   ├── sveltekit-dashboard/
│   │   └── SKILL.md          # User dashboard pattern
│   └── sveltekit-admin/
│       └── SKILL.md          # Admin dashboard pattern
└── existing/
    ├── create-skill/
    │   └── SKILL.md          # Wizard pour créer skills
    ├── maxun/
    │   └── SKILL.md          # Web scraping
    └── memory-optimizer/
        └── SKILL.md          # Memory optimization
```

---

## 🎯 Avantages de cette Architecture

### Modularité
- Chaque skill a une responsabilité unique
- Facile à maintenir et mettre à jour
- Pas de redondance

### Réutilisabilité
- Patterns réutilisables entre projets
- Workflows prêts à l'emploi
- Skills composables

### Efficacité
- Chargement sélectif des skills nécessaires
- Workflow clair pour l'agent Svelte
- Productivité maximale

### Scalabilité
- Facile d'ajouter de nouveaux skills
- Évolution naturelle avec la stack
- Support de nouvelles features

### Clarté
- Structure claire et intuitive
- Documentation complète
- Apprentissage facile

---

## 📝 Next Steps

1. **Valider cette architecture** avec l'utilisateur
2. **Commencer la migration** (Phase 1)
3. **Créer les skills manquants** (Phase 2)
4. **Créer les workflows** (Phase 3)
5. **Intégrer l'agent Svelte** (Phase 4)

**Estimation:** 2-3 semaines pour compléter la migration

---

**Cette architecture permettra une organisation claire, une maintenance facile, et une productivité maximale pour tous les projets Svelte/SvelteKit !** 🚀
