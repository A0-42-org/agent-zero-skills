# Proposition d'Architecture V2 - Agent Svelte & Skills (Ajustée)

## 🎯 Clarifications Importantes

### 1. Portabilité des Skills
**Les skills sont globaux et réutilisables par n'importe quel agent !**

- **Les skills** sont des fichiers dans `/a0/usr/skills/`
- **N'importe quel agent** peut charger un skill avec `skills_tool:load`
- **L'agent Svelte** est le "default agent" pour les projets Svelte/SvelteKit mais les skills sont partagés
- **Exemple**: L'agent 'developer' pourrait aussi utiliser `better-auth-svelte` pour un projet Node.js

**Architecture de Skills**:
```
/a0/usr/skills/
├── sveltekit-authentication/    # Réutilisable par n'importe quel agent
├── sveltekit-database/          # Réutilisable par n'importe quel agent
├── sveltekit-theming/          # Réutilisable par n'importe quel agent
└── stripe-integration/          # Réutilisable par n'importe quel agent
```

### 2. PostgreSQL par Défaut
**Raison**: Migrer SQLite → PostgreSQL est complexe, commencer en PostgreSQL est plus simple

- **PostgreSQL** = Production-ready, scalable, multi-connections
- **SQLite** = Dev/tests rapides, fichier local
- **Recommandation**: PostgreSQL pour tous les projets BetterAuth
- **Une DB par projet**: Chaque projet a sa propre DB (plus simple à gérer)

### 3. Petits Skills Modulaires
**Préférence**: Skills ciblés, pas de monolithes comme `sveltekit-fullstack`

- Chaque skill a une responsabilité unique
- Facile à maintenir et mettre à jour
- Composable: charger uniquement les skills nécessaires

### 4. Brand Style "svelteforge"
**Pas de thème unique Cerberus**

- Cerberus est un thème de base, pas le seul
- Utilisateur peut fournir une feuille CSS "svelteforge" pour son brand
- Le système de thèmes doit être flexible et extensible
- Support de thèmes personnalisés par projet

---

## 🏗️ Architecture Proposée V2

### 1. Structure Skills (Modulaire)

```
/a0/usr/skills/
├── core/                         # Skills essentielles (tous les projets)
│   ├── sveltekit-bootstrap/        # Initialisation projet complet
│   ├── sveltekit-authentication/  # BetterAuth + Drizzle (PostgreSQL)
│   └── sveltekit-ui-framework/     # Skeleton UI v4 + Tailwind CSS v4
├── features/                      # Skills fonctionnalités spécifiques
│   ├── sveltekit-database/        # Drizzle ORM patterns, migrations, queries
│   ├── sveltekit-editor/          # Page editor, drag-drop, templates
│   ├── sveltekit-theming/         # Theme system, custom CSS, brand styles
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

### 2. Mapping Skills → Responsabilités (Ajusté)

| Skill | Responsabilité | Contenu |
|-------|----------------|---------|
| **sveltekit-bootstrap** | Initialisation | `bunx sv create`, config TypeScript, ESLint, Prettier, Vite, Tailwind, Playwright |
| **sveltekit-authentication** | Auth & DB | BetterAuth server/client, Drizzle schema (PostgreSQL), migrations, env vars, protected routes |
| **sveltekit-ui-framework** | UI setup | Skeleton UI v4, Tailwind CSS v4, app.html, layout.css |
| **sveltekit-database** | DB patterns | Drizzle ORM CRUD, queries, relations, migrations workflow, seed data |
| **sveltekit-editor** | Page editing | Block system, svelte-dnd-action, auto-save, preview, templates |
| **sveltekit-theming** | Themes | Theme definitions, ThemeProvider, CSS variables, custom brand styles (ex: svelteforge.css) |
| **sveltekit-analytics** | Analytics | Events tracking (views/clicks), device detection, stats dashboard, charts |
| **sveltekit-payments** | Payments | Stripe integration, Payment Links, webhooks, subscriptions |
| **sveltekit-components** | Patterns | Component architecture, reusability, TypeScript strict types |
| **sveltekit-forms** | Forms | Form validation, Zod schemas, error handling, success states |
| **sveltekit-server-actions** | Backend | Server actions, mutations, API routes, error handling |
| **sveltekit-performance** | Optimisation | SSR, lazy loading, image optimization, caching, SEO |
| **sveltekit-auth-workflow** | Auth complet | Signup → Verify email → Login → Forgot password → Reset |
| **sveltekit-dashboard** | Dashboard | Page list, stats, quick actions, settings, profile |
| **sveltekit-admin** | Admin dashboard | User management, page moderation, analytics, settings |

### 3. Profile Agent Svelte (Ajusté)

```
Profile: svelte

Responsabilités:
- Agent par défaut pour TOUS les projets Svelte et SvelteKit
- Applications web fullstack par défaut

Stack Principale:
- SvelteKit 2 + TypeScript (strict mode)
- Svelte 5 runes (runes mode: $state, $derived, $props, $effect)
- Skeleton UI v4 + Tailwind CSS v4
- BetterAuth + Drizzle ORM
- PostgreSQL (par défaut) / SQLite (dev/tests rapides)

Comportement:
1. Toujours utiliser Svelte 5 runes (pas de syntaxe obsolète)
2. Toujours utiliser better-auth/svelte (pas better-auth/react)
3. Toujours utiliser svelte-dnd-action pour drag-drop (pas @dnd-kit)
4. Toujours utiliser onclick, oninput (pas on:click, on:input)
5. Toujours utiliser $env/dynamic/private pour env vars (pas process.env)
6. Toujours créer des projets sur org GitHub A0-42-org
7. Toujours créer une nouvelle DB PostgreSQL par projet

Skills à charger automatiquement:
- sveltekit-bootstrap (initialisation)
- sveltekit-authentication (setup auth)
- sveltekit-ui-framework (setup UI)

Brand Style:
- Par défaut: thème Cerberus (Skeleton UI)
- Custom: svelteforge.css (si fourni par l'utilisateur)
- Extensible: support de thèmes personnalisés par projet

Workflow de développement:
1. Analyser les requirements du projet
2. Créer une nouvelle DB PostgreSQL pour le projet
3. Sélectionner les skills nécessaires (core + features + patterns)
4. Suivre les patterns et best practices
5. Appliquer le brand style personnalisé (si fourni)
6. Implémenter avec Svelte 5 runes
7. Tester et déployer

MCP Tools:
- @modelcontextprotocol/server-svelte (documentation, autofix, playground)
- Utiliser pour: docs queries, code analysis, diagnostics, generation
```

---

## 🗄️ Database Management (PostgreSQL par Défaut)

### Convention de Nom des Bases de Données

```
Pattern: {nom-du-projet}_{environnement}

Exemples:
- segre_vip_dev
- segre_vip_prod
- mon_projet_dev
- mon_projet_prod
```

### Workflow de Création de DB

```bash
# 1. Connecter à PostgreSQL
psql -h 192.168.1.110 -U postgres

# 2. Créer la base de données pour le projet
CREATE DATABASE segre_vip_dev;
CREATE DATABASE segre_vip_prod;

# 3. Créer l'utilisateur pour le projet
CREATE USER segre_vip WITH PASSWORD 'secure_password_here';

# 4. Accorder les privilèges
GRANT ALL PRIVILEGES ON DATABASE segre_vip_dev TO segre_vip;
GRANT ALL PRIVILEGES ON DATABASE segre_vip_prod TO segre_vip;

# 5. Se connecter à la DB et accorder le schéma
\c segre_vip_dev
GRANT ALL ON SCHEMA public TO segre_vip;

\c segre_vip_prod
GRANT ALL ON SCHEMA public TO segre_vip;
```

### Variables d'Environnement par Projet

```env
# .env (développement)
DATABASE_URL=postgresql://segre_vip:password@192.168.1.110:5432/segre_vip_dev
BETTER_AUTH_SECRET=generate-secure-secret-with-openssl-rand-base64-32
BETTER_AUTH_URL=http://localhost:5173
SKIP_EMAIL_VERIFICATION=true

# .env.production
DATABASE_URL=postgresql://segre_vip:password@192.168.1.110:5432/segre_vip_prod
BETTER_AUTH_SECRET=your-production-secret
BETTER_AUTH_URL=https://your-domain.com
```

---

## 🎨 Brand Style & Theming (Ajusté)

### Système de Thèmes Extensible

```
src/lib/themes/
├── themes.ts              # Définitions des thèmes
├── brand-styles/           # Styles de marque personnalisés
│   ├── svelteforge.css    # Brand style fourni par l'utilisateur
│   └── custom.css         # Styles personnalisés projet
└── providers/
    └── ThemeProvider.svelte
```

### Exemple de Thème avec Brand Style

```typescript
// src/lib/themes/themes.ts
export type Theme = 'cerberus' | 'svelteforge' | 'custom';

export const themes: Record<Theme, ThemeConfig> = {
  cerberus: {
    name: 'Cerberus',
    description: 'Skeleton UI theme par défaut',
    colors: {
      primary: '#8b5cf6',
      secondary: '#6366f1',
      background: '#0f172a',
      text: '#f9fafb',
    },
  },
  svelteforge: {
    name: 'SvelteForge',
    description: 'Brand style personnalisé',
    // Charger depuis svelteforge.css
    css: '/lib/themes/brand-styles/svelteforge.css',
  },
  custom: {
    name: 'Custom',
    description: 'Thème personnalisé pour le projet',
    // Charger depuis custom.css
    css: '/lib/themes/brand-styles/custom.css',
  },
};
```

### Intégration du Brand Style

```svelte
<!-- src/routes/+layout.svelte -->
<script lang="ts">
  import { setContext } from 'svelte';
  import { browser } from '$app/environment';
  
  // Charger le brand style personnalisé si disponible
  import '/lib/themes/brand-styles/svelteforge.css';
  import '/lib/themes/brand-styles/custom.css';
</script>

<!-- Le contenu du projet -->
<slot />
```

---

## 📋 Plan de Migration (2-3 semaines) - Ajusté

### Phase 1: Reorganisation (Immédiat)

**Actions:**
1. Renommer/réorganiser les skills existants
2. **SUPPRIMER** `sveltekit-fullstack` (trop grand)
3. Créer les dossiers `core/`, `features/`, `patterns/`, `workflows/`
4. **METTRE À JOUR** `better-auth-svelte` pour supporter **PostgreSQL par défaut** (et SQLite comme alternative)
5. Ajouter la documentation de création de DB PostgreSQL par projet

**Résultat attendu:**
- ✅ Structure claire et modulaire
- ✅ Petits skills ciblés
- ✅ PostgreSQL par défaut
- ✅ Une DB par projet

### Phase 2: Création Skills Manquants (Semaine 1)

**Actions:**
1. Créer `sveltekit-bootstrap` (fusion de setup complet)
2. Créer `sveltekit-database` (Drizzle patterns avec PostgreSQL)
3. Créer `sveltekit-editor` (editor patterns)
4. Créer `sveltekit-theming` (theme system avec support brand styles personnalisés)
5. Créer `sveltekit-analytics` (analytics patterns)
6. Créer `sveltekit-components` (component patterns)

**Résultat attendu:**
- ✅ Skills couvrant toutes les fonctionnalités
- ✅ Patterns réutilisables
- ✅ Documentation complète
- ✅ Support de brand styles personnalisés

### Phase 3: Création Workflows (Semaine 2)

**Actions:**
1. Créer `sveltekit-auth-workflow` (setup auth complet avec PostgreSQL)
2. Créer `sveltekit-dashboard` (dashboard pattern)
3. Créer `sveltekit-admin` (admin pattern)

**Résultat attendu:**
- ✅ Workflows prêts à l'emploi
- ✅ Séquences claires pour les features complexes
- ✅ Rapidité de développement

### Phase 4: Intégration Agent Svelte (Semaine 2-3)

**Actions:**
1. Mettre à jour le profile `svelte` avec instructions complètes (PostgreSQL par défaut)
2. Configurer les skills à charger par défaut
3. Intégrer MCP Svelte avec le workflow de développement
4. Créer des prompts templates pour les tâches courantes
5. Ajouter la documentation de création de DB PostgreSQL par projet
6. Intégrer le support de brand styles personnalisés (svelteforge.css)

**Résultat attendu:**
- ✅ Agent Svelte autonome et efficace
- ✅ Workflow fluide
- ✅ PostgreSQL par défaut
- ✅ Brand styles personnalisés supportés
- ✅ Productivité maximale

---

## 📊 Comparaison Avant/Après

| Aspect | Avant | Après |
|--------|-------|-------|
| **Skills** | `sveltekit-fullstack` (trop grand) | Skills modulaires ciblés |
| **Database** | SQLite uniquement | PostgreSQL par défaut, SQLite alternative |
| **DB par projet** | Pas spécifié | Une DB PostgreSQL par projet |
| **Thèmes** | Cerberus uniquement | Cerberus + brand styles personnalisés |
| **Portabilité** | Non documenté | Skills globaux, réutilisables par tous les agents |

---

## ✅ Avantages de cette Architecture V2

| Avantage | Description |
|-----------|-------------|
| **Modularité** | Petits skills ciblés, maintenance facile |
| **Réutilisabilité** | Skills globaux, réutilisables par n'importe quel agent |
| **Scalabilité** | PostgreSQL par défaut, scalable en production |
| **Flexibilité** | Brand styles personnalisés supportés |
| **Clarté** | Structure claire, une DB par projet |
| **Productivité** | Workflows prêts à l'emploi |

---

## ❓ Questions

1. **Validation**: Cette architecture ajustée répond-elle à vos besoins ?
2. **Priorités**: Quelles phases voulez-vous que j'implémente en premier ?
3. **Brand style**: Voulez-vous que je prépare l'intégration de svelteforge.css maintenant ?
4. **Agent Svelte**: Voulez-vous que je mette à jour le profile `svelte` avec PostgreSQL par défaut ?

**Dites-moi ce que vous en pensez et je commencerai la migration !** 🚀
