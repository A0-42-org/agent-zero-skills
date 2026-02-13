# Agent Zero Skills

Collection of modular skills for Agent Zero autonomous AI agent.

## Overview

This repository contains skills that can be loaded by any Agent Zero agent using the `skills_tool`.

Skills are organized by category:

- **core/** - Essential skills for all projects (bootstrap, auth, UI framework)
- **features/** - Specific feature implementations (database, editor, theming, analytics, payments)
- **patterns/** - Best practices and code patterns (components, forms, server actions, performance)
- **workflows/** - Multi-step workflows (auth setup, dashboard, admin)

## SvelteKit Stack Skills

### Core Skills

| Skill | Description |
|-------|-------------|
| **sveltekit-bootstrap** | Complete project initialization with TypeScript, ESLint, Prettier, Tailwind CSS v4, Playwright |
| **better-auth-svelte** | BetterAuth authentication for SvelteKit with Drizzle ORM |
| **skeleton-ui-svelte** | Skeleton UI v4 setup with Tailwind CSS v4 |

### Feature Skills

| Skill | Description |
|-------|-------------|
| **sveltekit-database** | Drizzle ORM patterns for PostgreSQL with migrations workflow |
| **stripe-integration** | Stripe payment integration (redirect-only) |

### Pattern Skills

*Coming soon*

### Workflow Skills

*Coming soon*

## General Skills

| Skill | Description |
|-------|-------------|
| **create-skill** | Wizard for creating new Agent Zero skills |
| **maxun** | Open-source no-code platform for web scraping and data extraction |
| **memory-optimizer** | Analyze, clean and optimize Agent Zero memories |
| **himalaya** | CLI email client for IMAP/SMTP management |

## Usage

To use a skill in Agent Zero:

```json
{
  "thoughts": ["I need to set up authentication"],
  "tool_name": "skills_tool:load",
  "tool_args": {
    "skill_name": "better-auth-svelte"
  }
}
```

## Skill Format

Each skill follows the [SKILL.md](https://agentskills.io/) standard format:

- `SKILL.md` - Main skill file with documentation
- Scripts and examples in subdirectories
- Metadata (name, version, description, tags, author)

## Architecture

### Modular Design

- Each skill has a single responsibility
- Skills are composable and reusable
- Skills are not tied to specific agents (any agent can load any skill)

### Categories

```
/
├── core/           # Essential skills (all projects)
├── features/       # Feature implementations
├── patterns/       # Best practices
├── workflows/      # Multi-step workflows
└── existing/       # General skills (create-skill, maxun, etc.)
```

## Contributing

To create a new skill:

1. Use the **create-skill** skill: `skills_tool:load({ skill_name: "create-skill" })`
2. Follow the SKILL.md standard
3. Place the skill in the appropriate category directory
4. Test the skill thoroughly
5. Submit a pull request

## SvelteKit Specialization

The **Svelte** subagent is the default agent for all Svelte/SvelteKit projects and has expertise in:

- SvelteKit 2 + TypeScript (strict mode)
- Svelte 5 runes (runes mode: $state, $derived, $props, $effect)
- Skeleton UI v4 + Tailwind CSS v4
- BetterAuth + Drizzle ORM
- PostgreSQL (by default) / SQLite (dev/tests)

**Common Stack:**
- SvelteKit 2
- Svelte 5
- TypeScript
- Skeleton UI v4
- Tailwind CSS v4
- BetterAuth
- Drizzle ORM
- PostgreSQL/SQLite

## License

MIT License - See individual skill files for specific licenses.

## Repository

GitHub: https://github.com/A0-42-org/agent-zero-skills

---

**Part of the Agent Zero ecosystem**
