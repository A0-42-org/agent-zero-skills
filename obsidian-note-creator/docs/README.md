# Obsidian Note Creator - Documentation

## Overview

The **obsidian-note-creator** skill enables Agent Zero to intelligently create, classify, and organize notes in an Obsidian vault using the PARA method, tag-centric organization, and template automation.

## Features

### 1. Intelligent Classification

- **PARA Method Integration**: Automatically classifies notes into Projects, Areas, Resources, or Archive
- **Subject Detection**: Identifies content categories (Code, Nutrition, Business, AI, etc.)
- **Context Awareness**: Considers project context and urgency for proper placement

### 2. Template System

The skill supports multiple note templates:

| Template | Purpose |
|----------|---------|
| `quick-note.md` | General quick notes |
| `task-quick.md` | Task management |
| `reference-quick.md` | Reference materials |
| `idea-quick.md` | Idea capture |
| `meeting.md` | Meeting notes |
| `book.md` | Book notes |
| `daily.md` | Daily notes |
| `weekly-review.md` | Weekly reviews |
| `project.md` | Project documentation |
| `resource.md` | Resource documentation |
| `area.md` | Area documentation |
| `recipe.md` | Custom recipe template |
| `code-snippet.md` | Custom code template |

### 3. Tag-Centric Organization

The skill automatically generates relevant tags based on content:

- **Type tags**: `#project`, `#area`, `#resource`, `#archive`
- **Subject tags**: `#code`, `#python`, `#nutrition`, `#business`, `#ai`, etc.
- **Action tags**: `#task`, `#todo`, `#idea`, `#meeting`

## Usage Examples

### Example 1: Creating a Recipe Note

**User Input:**
```
Créer une note pour la recette de tarte aux pommes avec les ingrédients: farine, sucre, pommes, beurre
```

**Agent Action:**
1. Identifies content type: Recipe (nutrition/cooking)
2. Determines location: `2. 🛸 Area/Nutrition/Recettes/` or `0. 📬 Inbox/`
3. Selects template: `recipe.md`
4. Generates tags: `#nutrition #recette #cuisine #dessert`
5. Creates note with proper structure

### Example 2: Saving a Code Snippet

**User Input:**
```
Save this Python function for async HTTP requests
```

**Agent Action:**
1. Identifies content type: Code snippet (Python)
2. Determines location: `3. 💭 Resource/Code/` or `2. 🛸 Area/Code/`
3. Selects template: `code-snippet.md`
4. Generates tags: `#code #python #async #http`
5. Creates reference note with syntax highlighting

### Example 3: Creating a Task

**User Input:**
```
I need to fix the payment bug by Friday
```

**Agent Action:**
1. Identifies content type: Task with deadline
2. Determines location: `1. ⚙ Project/[relevant]/` or `0. 📬 Inbox/`
3. Selects template: `task-quick.md`
4. Generates tags: `#task #todo #urgent #bug`
5. Creates task with due date and priority

## Scripts

### classify_note.py

Analyzes note content and suggests optimal PARA location.

**Usage:**
```bash
python3 /a0/usr/skills/obsidian-note-creator/scripts/classify_note.py <file.md>
```

**Output:**
- Primary location (Project/Area/Resource/Archive)
- Subject tags
- Suggested file path
- Recommended template

### generate_tags.py

Generates relevant tags based on note content.

**Usage:**
```bash
python3 /a0/usr/skills/obsidian-note-creator/scripts/generate_tags.py <file.md> [type]
```

**Output:**
- Suggested tags (prioritized)
- All found tags
- Tag count

## Templates

### Custom Templates

The skill includes two custom templates:

#### recipe.md
Specialized template for cooking recipes with:
- Ingredients sections (base, filling, topping)
- Step-by-step instructions
- Serving information and cooking times
- Variations and tips sections
- Equipment checklist

#### code-snippet.md
Specialized template for code references with:
- Syntax highlighting support
- Usage examples
- Parameter documentation
- Return value description
- Multiple example sections

## File Naming Conventions

The skill follows these naming conventions:

- **Date-based**: `YYYY-MM-DD Title.md` (for dated notes)
- **Project-based**: Use project name as prefix
- **Descriptive**: Use searchable, descriptive names
- **Avoid special characters**: Only hyphens and spaces allowed

## Frontmatter Standards

### Required Fields

```yaml
---
tags: [tag1, tag2, tag3]
created: YYYY-MM-DD
---
```

### Optional Fields

```yaml
---
tags: [tag1, tag2]
created: 2026-02-18
updated: 2026-02-18
type: recipe | code | task | idea | meeting | book
status: todo | in-progress | done
priority: low | medium | high
due: YYYY-MM-DD
language: python | javascript | golang | svelte
author: Author Name
source: URL or reference
project: Project Name
---
```

## Trigger Patterns

The skill activates when user mentions:

- "create note", "new note", "créer note", "nouvelle note"
- "add to vault", "ajouter au vault"
- "classifier note", "organize note", "classer note"
- "note template", "template note"
- "recipe note", "recette note"
- "code snippet", "extrait de code"
- "save note", "enregistrer note"
- "capturer note", "capture note"

## Integration with Workflow

1. **Inbox First**: When uncertain, create in `0. 📬 Inbox/`
2. **Project Context**: Use project context when mentioned
3. **Ask Before Moving**: Confirm before moving files from Inbox
4. **Tag Comprehensively**: Enable later discovery
5. **Preserve Content**: Never delete without permission

## Security & Permissions

- **Never create** notes outside the project vault directory
- **Never overwrite** existing files without confirmation
- **Always sanitize** user input for YAML frontmatter
- **Respect** user's file naming preferences
- **Backup** important notes before bulk operations

## Troubleshooting

### Problem: Not sure where to classify
**Solution**: Create in `0. 📬 Inbox/` with `#triage` tag for later review

### Problem: No template fits
**Solution**: Use `quick-note.md` or `reference-quick.md` as base

### Problem: Multiple projects mentioned
**Solution**: Ask which project is primary, or create in both with cross-references

### Problem: Note spans multiple categories
**Solution**: Use multiple tags and create links between notes

## Best Practices

1. **Never delete** user content without permission
2. **Ask before moving** files from Inbox to other locations
3. **Preserve existing tags** when updating notes
4. **Use existing templates** before creating new ones
5. **Check for duplicates** before creating new notes
6. **Maintain consistency** in naming and structure
7. **Index references** to related notes in frontmatter or body
8. **Review regularly** and archive completed items

## Technical Details

- **Skill Location**: `/a0/usr/skills/obsidian-note-creator/`
- **Python Version**: 3.x
- **Dependencies**: `re`, `sys`, `datetime` (standard library)
- **Vault Path**: `/a0/usr/projects/obsidian`
- **PARA Structure**: 0. Inbox, 1. Project, 2. Area, 3. Resource, 4. Archive

## Contributing

To extend this skill:

1. Add new patterns to `scripts/classify_note.py`
2. Create custom templates in `templates/`
3. Update `SKILL.md` with new procedures
4. Test with various note types

---

**Version**: 1.0.0  
**Last Updated**: 2026-02-18  
**Author**: Agent Zero Team
