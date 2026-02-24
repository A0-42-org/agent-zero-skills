---
name: github-readme
description: Generate comprehensive GitHub READMEs for web projects with auto-detection of framework (SvelteKit, Next.js, React, etc.)
version: 1.0.0
author: OpenCode Team
tags:
  - readme
  - documentation
  - github
  - opensource
trigger_patterns:
  - generate readme
  - create readme
  - update readme
  - github readme
  - project documentation
---

# GitHub README Generator

Generate professional, comprehensive README files for web projects with automatic framework detection and best practices.

## Usage

```
Use github-readme skill to generate a README for this project
```

## Framework Detection

The skill automatically detects:

| Framework | Detection Files |
|-----------|----------------|
| **SvelteKit** | `svelte.config.js`, `src/routes/` |
| **Next.js** | `next.config.js`, `pages/` or `app/` |
| **React** | `react` in dependencies |
| **Vue** | `vue.config.js`, `.vue` files |
| **Astro** | `astro.config.*` |
| **Node.js** | `package.json` (backend only) |
| **Bun** | `bun.lockb`, `bunfig.toml` |

## README Structure

```markdown
# Project Name

Brief description of what the project does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Tech Stack

- **Framework**: SvelteKit / Next.js / React
- **Language**: TypeScript / JavaScript
- **Styling**: Tailwind CSS / CSS Modules
- **Database**: PostgreSQL / SQLite
- **Auth**: BetterAuth / NextAuth

## Getting Started

### Prerequisites

- Node.js 18+
- Bun (recommended) or npm/pnpm

### Installation

\`\`\`bash
bun install
\`\`\`

### Development

\`\`\`bash
bun dev
\`\`\`

### Build

\`\`\`bash
bun build
\`\`\`

## Project Structure

\`\`\`
src/
├── lib/
│   ├── components/
│   └── utils/
├── routes/
│   └── +page.svelte
└── app.html
\`\`\`

## Scripts

| Command | Description |
|---------|-------------|
| `bun dev` | Start development server |
| `bun build` | Build for production |
| `bun test` | Run tests |
| `bun lint` | Run linter |

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | Database connection string | Yes |
| `SECRET_KEY` | App secret | Yes |

## Contributing

Contributions are welcome! Please read our contributing guidelines.

## License

MIT

## Acknowledgments

- Built with [Framework]
- Inspired by [Project]
```

## Badges

Automatically includes relevant badges:

```markdown
[![Built with SvelteKit](https://img.shields.io/badge/SvelteKit-FF3E00?logo=svelte&logoColor=white)](https://kit.svelte.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-06B6D4?logo=tailwindcss&logoColor=white)](https://tailwindcss.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
```

## Customization Options

### Minimal README
```
Generate a minimal README for this project
```

### Detailed README
```
Generate a comprehensive README with API docs, examples, and deployment guide
```

### Open Source Ready
```
Generate an open-source ready README with contributing guide and code of conduct
```

## Best Practices Applied

1. **Clear project description** - What it does and why
2. **Installation instructions** - Step-by-step setup
3. **Usage examples** - How to use the project
4. **Project structure** - Directory layout
5. **Available scripts** - All npm/bun commands
6. **Environment setup** - Required configuration
7. **License** - Clear licensing info
8. **Contributing** - How to contribute

## Tips

1. **Run from project root** for accurate detection
2. **Include package.json** for dependency analysis
3. **Add screenshots** for visual projects
4. **Include live demo** link if available
5. **Update badges** to reflect current status
