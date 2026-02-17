---
name: "todo-management"
description: "Complete TODO management system for projects with single source of truth, progress tracking, checklists, and automatic consolidation."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["todo", "workflow", "tracking", "documentation"]
trigger_patterns:
  - "todo"
  - "task list"
  - "checklist"
  - "progress tracking"
  - "liste de tâches"
  - "suivi de progression"
---

# TODO Management System

This skill provides a complete TODO management system with single source of truth, progress tracking, checklists, and automatic consolidation.

## Single TODO File Principle

### Source of Truth

- Use **ONE** TODO file as the source of truth
- Recommended filename: `TODO_IMPROVED.md`
- Location: `docs/` folder in project root
- **NEVER** maintain multiple TODO files simultaneously

### Why Single File?

- Prevents confusion and duplication
- Easier to maintain and track progress
- Single source of truth for all stakeholders
- Reduces merge conflicts
- Simplifies progress reporting

### Recommended Structure

```
project/
├── docs/
│   └── TODO_IMPROVED.md  # Single source of truth
├── PRD.md                # Product requirements
└── CLIENT_REPORT.md      # Client reports
```

## Progress Tracking Format

### Markdown Checkboxes with Progress Indicators

```markdown
## 📊 Progression globale
- [x] **74%** - Projet en cours (51/69 étapes complétées)

## 🚀 Phase 0: Initialisation & Configuration ✅ COMPLETÉ
### 0.1 Configuration de l'environnement
- [x] Créer repository GitHub
- [x] Cloner repository
- [x] Configurer environnement local
```

### Progress Indicators

| Indicator | Meaning | Usage |
|-----------|---------|-------|
| ✅ 100% | Fully completed | All tasks in phase done |
| ⏳ 90% | Almost complete | 1-2 tasks remaining |
| 🟡 45% | In progress | Multiple tasks done |
| 🔜 0% | Not started | No tasks completed |

### Global Progress Header

Always include global progress at the top:

```markdown
## 📊 Progression globale
- [x] **74%** - Projet en cours (51/69 étapes complétées)

### Résumé des phases
| Phase | État | Étapes |
|-------|------|--------|
| **Phase 0** - Initialisation | ✅ 100% | 3/3 |
| **Phase 1** - Database Schema | ✅ 100% | 4/4 |
| **Phase 2** - Landing Page | ⏳ 90% | 9/10 |
| **Phase 3** - Backend Core | 🟡 80% | 8/10 |
| **Phase 4** - User Dashboard | 🔜 0% | 0/8 |

**Progression totale : 51/69 étapes (74%)**
```

## Phase-based Structure

### Organize TODO by Phases

```markdown
## 🚀 Phase 3: Backend Core Features 🟡 80%

### 3.1 Génération de Code de Parrainage
- [ ] Créer algorithme de génération unique
- [ ] Ajouter tests unitaires
- [ ] Implémenter endpoint /api/referral-code
- [ ] Documenter l'API

### 3.2 Service de Parrainage
- [x] Créer ReferralService
- [x] Implémenter méthode createReferral
- [x] Implémenter méthode getReferralsByUserId
- [ ] Implémenter méthode updateReferralStatus
```

### Phase Naming Convention

- Use numbered phases: `Phase 0`, `Phase 1`, etc.
- Include descriptive title: `Phase 3: Backend Core Features`
- Add progress indicator: `🟡 80%`
- Use emoji for visual clarity: 🚀, 🛠️, 🎨, 🔧

### Sub-task Organization

Each phase should have:
- Numbered subsections (3.1, 3.2, etc.)
- Descriptive titles
- Checkboxes for individual tasks
- Detailed instructions for each task

## Task Completion Sequence

### After Completing EVERY Individual Task

Follow this sequence **after EVERY task completion**:

1. ✅ Check off task in TODO
2. ✅ Update phase progress percentage
3. ✅ Update global progress percentage
4. ✅ Commit changes
5. ✅ Push to GitHub **immediately**

### Example Workflow

```bash
# 1. Implement the task
# ... code changes ...

# 2. Commit implementation
git add .
git commit -m 'feat(phase-3): implement user authentication'
git push origin feature/phase-3-authentication

# 3. Update TODO file
# Check off task, update progress

# 4. Commit TODO update
git add docs/TODO_IMPROVED.md
git commit -m 'docs(phase-3): update TODO - authentication completed'
git push origin feature/phase-3-authentication
```

### Update Checklist

When updating TODO:

- [ ] Mark completed tasks with `[x]`
- [ ] Recalculate phase progress percentage
- [ ] Update global progress percentage
- [ ] Update summary table
- [ ] Check total count matches completed tasks

## Checklist Format

### Detailed Checklists with Action Items

```markdown
### 4.2 Implémentation Dashboard Overview
- [ ] Créer `src/routes/(protected)/dashboard/+page.svelte`
- [ ] Créer `src/routes/(protected)/dashboard/+page.server.ts`
- [ ] Afficher carte infos utilisateur (nom, email, téléphone)
- [ ] Afficher badge palier actuel (bronze/argent/or)
- [ ] Afficher nombre total de parrainages
- [ ] Afficher barre de progression vers palier suivant
- [ ] Ajouter lien unique de parrainage avec bouton copier
- [ ] Tester sur mobile et desktop
```

### Task Description Guidelines

- Start with action verb (Créer, Implémenter, Ajouter)
- Include file paths when applicable
- Be specific about what to implement
- Add acceptance criteria when needed
- Include testing requirements

## Progress Tracking Table

### Include Summary Table at Top

```markdown
## 📊 Progression globale
- [x] **74%** - Projet en cours (51/69 étapes complétées)

### Résumé des phases
| Phase | État | Étapes |
|-------|------|--------|
| **Phase 0** - Initialisation | ✅ 100% | 3/3 |
| **Phase 1** - Database Schema | ✅ 100% | 4/4 |
| **Phase 2** - Landing Page | ⏳ 90% | 9/10 |
| **Phase 3** - Backend Core | 🟡 80% | 8/10 |
| **Phase 4** - User Dashboard | 🔜 0% | 0/8 |
| **Phase 5** - Admin Dashboard | 🔜 0% | 0/10 |

**Progression totale : 51/69 étapes (74%)**
```

### Table Maintenance

- Update after each task completion
- Keep table at the top of TODO file
- Use consistent format
- Calculate percentages accurately

## TODO Consolidation Workflow

### When Multiple TODO Files Exist

If you find multiple TODO files:

1. Compare content of all TODO files
2. Merge tasks into single comprehensive file
3. Remove outdated files
4. Commit consolidation

### Consolidation Example

```bash
# Identify TODO files
docs/TODO.md (old, 550 lines)
docs/TODO_IMPROVED.md (new, 629 lines)
docs/TODO_OLD.md (very old, 300 lines)

# 1. Compare and merge content
# Keep most complete and recent version

# 2. Remove old files
git rm docs/TODO.md
git rm docs/TODO_OLD.md

# 3. Keep only new file
docs/TODO_IMPROVED.md (single source of truth)

# 4. Commit consolidation
git add docs/TODO_IMPROVED.md
git commit -m 'docs: consolidate TODO files - keep TODO_IMPROVED.md as single source of truth'
git push origin main
```

### Consolidation Best Practices

- Keep the most recent and complete version
- Preserve all unique tasks
- Update progress indicators
- Remove duplicates
- Document the consolidation in commit message

## TODO Updates in Git Workflow

### When to Update TODO

TODO file updates should be:

- **Committed AFTER** implementation commits
- Use conventional commit format
- Pushed **IMMEDIATELY** to GitHub
- Never accumulated with other changes

### Commit Format

```bash
# Format
git commit -m 'docs(phase-X): update TODO - task description'

# Examples
git commit -m 'docs(phase-3): update TODO - authentication completed'
git commit -m 'docs(phase-4): update TODO - dashboard overview done'
git commit -m 'docs: update TODO - progress 74%'
```

### Update Sequence

```bash
# 1. Implement task
git add .
git commit -m 'feat(phase-3): implement authentication'

# 2. Update TODO
git add docs/TODO_IMPROVED.md
git commit -m 'docs(phase-3): update TODO - authentication completed'

# 3. Push both commits
git push origin feature/phase-3-authentication
```

## Bilingual Support

### Use Bilingual Task Descriptions

```markdown
### 3.1 Authentication / Authentification
- [ ] Create user registration / Créer inscription utilisateur
- [ ] Implement login / Implémenter connexion
- [ ] Add password reset / Ajouter réinitialisation mot de passe
```

### Language Guidelines

- Maintain consistency in language
- Translate technical terms appropriately
- Use English for code-related terms
- Use French for UI-related terms (if project is French)

## TODO File Template

### Complete Template

```markdown
# TODO IMPOUVÉ - Project Name

## 📊 Progression globale
- [x] **X%** - Projet en cours (A/B étapes complétées)

### Résumé des phases
| Phase | État | Étapes |
|-------|------|--------|
| **Phase 0** - Initialisation | ✅ 100% | 3/3 |
| **Phase 1** - Title | 🔜 0% | 0/X |
| **Phase 2** - Title | 🔜 0% | 0/X |

**Progression totale : A/B étapes (X%)**

---

## 🚀 Phase 0: Initialisation & Configuration ✅ 100%

### 0.1 Configuration de l'environnement
- [x] Créer repository GitHub
- [x] Cloner repository
- [x] Configurer environnement local

---

## 🚀 Phase 1: Title 🔜 0%

### 1.1 Subsection Title
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

---

## 🚀 Phase 2: Title 🔜 0%

### 2.1 Subsection Title
- [ ] Task 1
- [ ] Task 2
```

## Quick Reference

### Progress Indicators

```markdown
✅ 100% - Fully completed
⏳ 90% - Almost complete
🟡 45% - In progress
🔜 0% - Not started
```

### Update After Task

```bash
# 1. Implement task
git add . && git commit -m 'feat(phase-X): description'

# 2. Update TODO
git add docs/TODO_IMPROVED.md
git commit -m 'docs(phase-X): update TODO - task completed'

# 3. Push
git push origin feature/phase-X-step-Y
```

### Consolidate Multiple TODOs

```bash
# Remove old files
git rm docs/TODO.md
git rm docs/TODO_OLD.md

# Keep single file
git add docs/TODO_IMPROVED.md
git commit -m 'docs: consolidate TODO files - keep TODO_IMPROVED.md as single source of truth'
git push origin main
```

---

**Use this system to maintain a single source of truth and track project progress effectively.**
