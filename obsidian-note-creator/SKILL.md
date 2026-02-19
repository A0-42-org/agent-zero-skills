---
name: "obsidian-note-creator"
description: "Intelligent note creation and classification for Obsidian vault using PARA method, tag-centric system, and template automation. Automatically analyzes note type, determines optimal location, selects appropriate template, and applies relevant tags."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["obsidian", "notes", "para", "classification", "templates", "tagging", "productivity"]
trigger_patterns:
  - "create note"
  - "new note"
  - "créer note"
  - "nouvelle note"
  - "add to vault"
  - "classifier note"
  - "organize note"
  - "note template"
  - "recipe note"
  - "code snippet"
  - "créer une note"
  - "nouvelle note obsidian"
  - "ajouter au vault"
  - "classer note"
  - "organiser note"
  - "template note"
  - "recette note"
  - "extrait de code"
  - "save note"
  - "enregistrer note"
  - "capturer note"
  - "capture note"
---

# Obsidian Note Creator

This skill enables Agent Zero to intelligently create, classify, and organize notes in an Obsidian vault using the PARA method, tag-centric organization, and template automation.

## Context & Vault Structure

**Project Vault Location:** `/a0/usr/projects/obsidian`

**PARA Organization:**
- `0. 📬 Inbox` - Capture zone for all new notes
- `1. ⚙ Project` - Active projects with time-bound goals
- `2. 🛸 Area` - Ongoing responsibilities (Code, Health, Finance, Family, Gaming, Geek, Life, Nature, Nutrition)
- `3. 💭 Resource` - Reference materials (AI, Books, Business, Code, Design, SelfHosting, Video)
- `4. 📦 Archive` - Completed or inactive items

**Available Templates:**
- `quick-note.md` - General quick notes
- `task-quick.md` - Task management
- `reference-quick.md` - Reference materials
- `idea-quick.md` - Idea capture
- `daily.md` - Daily notes
- `meeting.md` - Meeting notes
- `book.md` - Book notes
- `weekly-review.md` - Weekly reviews
- `project.md` - Project documentation
- `resource.md` - Resource documentation
- `area.md` - Area documentation

## Core Workflow

### 1. Analyze User Intent

When user requests note creation, identify:
- **Note Type**: What kind of content is being captured?
- **Context**: Is this related to a project, area, or resource?
- **Priority**: Is this urgent or time-sensitive?
- **Category**: Code, Nutrition, Finance, Business, etc.

### 2. Determine PARA Classification

**Use this decision matrix:**

| Scenario | Primary Location | Secondary Location |
|----------|------------------|---------------------|
| Active task with deadline | `1. ⚙ Project/` | `0. 📬 Inbox/` |
| General information capture | `0. 📬 Inbox/` | N/A |
| Long-term reference | `3. 💭 Resource/` | N/A |
| Ongoing responsibility | `2. 🛸 Area/` | N/A |
| Completed work | `4. 📦 Archive/` | N/A |

### 3. Select Appropriate Template

**Template Selection Logic:**

| Content Type | Template | Tags |
|--------------|----------|------|
| Recipe | `quick-note.md` or create custom | `#nutrition` `#recette` `#cuisine` |
| Code snippet | `reference-quick.md` | `#code` `#snippet` `#[language]` |
| Task/To-do | `task-quick.md` | `#task` `#todo` |
| Idea | `idea-quick.md` | `#idea` `#idee` |
| Meeting | `meeting.md` | `#meeting` `#réunion` |
| Book note | `book.md` | `#book` `#lecture` `#[genre]` |
| General info | `quick-note.md` | `#note` `#info` |
| Project document | `project.md` | `#project` `#[project-name]` |

### 4. Apply Tag-Centric System

**Tag Hierarchy:**

```
Type Tags (Required):
- #project - Active projects
- #area - Areas of responsibility
- #resource - Reference materials
- #archive - Archived items

Subject Tags (Contextual):
Code:
- #code - General code
- #python - Python specific
- #javascript - JavaScript
- #svelte - Svelte framework
- #golang - Go language
- #typescript - TypeScript

Business:
- #business - Business topics
- #startup - Startup related
- #marketing - Marketing
- #finance - Financial

Personal:
- #health - Health related
- #nutrition - Nutrition & food
- #fitness - Fitness & exercise
- #family - Family matters

Other:
- #ai - Artificial Intelligence
- #gaming - Gaming topics
- #selfhosting - Self-hosting
- #design - Design topics
- #video - Video content
- #book - Books & reading
```

## Procedures

### Procedure 1: Create Recipe Note

**Trigger:** User mentions ingredients, cooking, "recette", or food preparation.

**Steps:**
1. Analyze ingredients and recipe type
2. Create note in `2. 🛸 Area/Nutrition/Recettes/` or `0. 📬 Inbox/`
3. Use `quick-note.md` template with custom structure
4. Add frontmatter with tags: `#nutrition #recette #cuisine #[dish-type]`
5. Include sections: Ingredients, Instructions, Notes, Source

**Example:**
```markdown
---
tags: [nutrition, recette, cuisine, dessert]
created: 2026-02-18
type: recipe
---

# Tarte aux pommes

## Ingredients
- Farine
- Sucre
- Pommes
- Beurre

## Instructions
1. ...
2. ...

## Notes
...
```

### Procedure 2: Create Code Snippet Note

**Trigger:** User shares code, functions, or programming concepts.

**Steps:**
1. Identify programming language
2. Determine if project-specific or general reference
3. Create in appropriate location:
   - Project-related: `1. ⚙ Project/[project]/`
   - General reference: `3. 💭 Resource/Code/` or `2. 🛸 Area/Code/`
4. Use `reference-quick.md` template
5. Add language-specific tag: `#code #python #javascript #golang #svelte`
6. Include code blocks with syntax highlighting

**Example:**
```markdown
---
tags: [code, python, function, utility]
created: 2026-02-18
language: python
type: code
---

# Python Utility Function

## Description
...

## Code
```python
def my_function():
    pass
```

## Usage
...
```

### Procedure 3: Create Task Note

**Trigger:** User mentions "task", "to-do", "faire", deadlines.

**Steps:**
1. Determine priority and urgency
2. If urgent: Create in relevant Project folder
3. If non-urgent: Create in `0. 📬 Inbox/`
4. Use `task-quick.md` template
5. Set due date and priority in frontmatter
6. Add tags: `#task #todo #urgent` (if applicable)

**Example:**
```markdown
---
tags: [task, todo, work]
created: 2026-02-18
due: 2026-02-20
priority: high
status: todo
---

# Task Title

## Description
...

## Checklist
- [ ] Task 1
- [ ] Task 2
```

### Procedure 4: Create Idea Note

**Trigger:** User says "idea", "idéee", "maybe", "could", brainstorming.

**Steps:**
1. Capture idea in raw form
2. Create in `0. 📬 Inbox/` for later triage
3. Use `idea-quick.md` template
4. Add tags: `#idea #idee #[topic]`
5. Include potential implementation or next steps

### Procedure 5: Create Meeting Note

**Trigger:** User mentions meeting, "réunion", "call", discussion.

**Steps:**
1. Gather meeting context (attendees, date, topic)
2. If project-related: Create in `1. ⚙ Project/[project]/`
3. If general: Create in `0. 📬 Inbox/`
4. Use `meeting.md` template
5. Add tags: `#meeting #réunion #[project/area]`
6. Include: Date, Attendees, Agenda, Notes, Action Items

### Procedure 6: Create Book Note

**Trigger:** User mentions reading, books, references a book.

**Steps:**
1. Get book title and author
2. Create in `3. 💭 Resource/Books/`
3. Use `book.md` template
4. Add tags: `#book #lecture #[genre]`
5. Include: Author, Year, Genre, Notes, Quotes

### Procedure 7: Classify Existing Inbox Notes

**Trigger:** User asks to organize inbox or triage notes.

**Steps:**
1. Read notes from `0. 📬 Inbox/`
2. Analyze each note's content and context
3. Determine appropriate PARA destination
4. Move notes to correct location
5. Update tags if necessary
6. Keep uncertain notes in `0. 📬 Inbox/🗑️ _review/`

### Procedure 8: Create Custom Template

**Trigger:** User requests a specific template type not in standard set.

**Steps:**
1. Analyze template requirements
2. Create template in `8. 🏗 Templates/`
3. Include appropriate frontmatter structure
4. Add reference to Templates list
5. Document template usage

## File Naming Conventions

**Best Practices:**
- Use descriptive, searchable names
- Avoid special characters (except hyphens, spaces)
- Include date for dated notes: `YYYY-MM-DD Title.md`
- For projects: Use project name as prefix
- For recurring notes: Use consistent pattern

**Examples:**
- ✅ `2026-02-18 Tarte aux pommes.md`
- ✅ `Python Async Function Utility.md`
- ✅ `Meeting - Weekly Standup.md`
- ✅ `segre.vip - Payment System.md`
- ❌ `Untitled.md`
- ❌ `New Note 1.md`
- ❌ `note@2026.md`

## Frontmatter Standards

**Required Fields:**
```yaml
---
tags: [tag1, tag2, tag3]
created: YYYY-MM-DD
---
```

**Optional Fields:**
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

## Decision Tree for Note Classification

```
User Input
    │
    ├── Is it actionable with deadline?
    │   └── YES → Project folder or Inbox (if new)
    │
    ├── Is it a reference material?
    │   ├── Code-related → Area/Code or Resource/Code
    │   ├── Book → Resource/Books
    │   ├── Article/Link → Resource/[topic]
    │   └── Other → Resource/[topic] or Area/[topic]
    │
    ├── Is it an ongoing responsibility?
    │   └── YES → Area/[category]
    │
    ├── Is it an idea or brainstorm?
    │   └── YES → Inbox → Triage later
    │
    ├── Is it a recipe?
    │   └── YES → Area/Nutrition/Recettes or Inbox
    │
    └── Unsure?
        └── YES → Inbox → Triage later
```

## Integration with Existing Workflow

1. **Always create in Inbox first** when uncertain
2. **Use project context** when user mentions specific project
3. **Ask for clarification** if classification is ambiguous
4. **Propose location** before creating to get confirmation
5. **Tag comprehensively** to enable later discovery

## Example User Interactions

### Example 1: Recipe Creation
```
User: "Créer une note pour la recette de tarte aux pommes avec les ingrédients: farine, sucre, pommes, beurre"

Agent Analysis:
- Type: Recipe (nutrition/cooking)
- Location: Area/Nutrition/Recettes or Inbox
- Template: quick-note.md (customized for recipes)
- Tags: #nutrition #recette #cuisine #dessert

Action: Create note with recipe structure
```

### Example 2: Code Snippet
```
User: "Save this Python function for async HTTP requests"

Agent Analysis:
- Type: Code snippet
- Location: Area/Code or Resource/Code
- Template: reference-quick.md
- Tags: #code #python #async #http

Action: Create reference note with code block
```

### Example 3: Task Management
```
User: "I need to fix the payment bug by Friday"

Agent Analysis:
- Type: Task with deadline
- Location: Project/[relevant] or Inbox (if no project)
- Template: task-quick.md
- Tags: #task #todo #urgent #bug

Action: Create task with due date and priority
```

## Best Practices

1. **Never delete** user content without permission
2. **Ask before moving** files from Inbox to other locations
3. **Preserve existing tags** when updating notes
4. **Use existing templates** before creating new ones
5. **Check for duplicates** before creating new notes
6. **Maintain consistency** in naming and structure
7. **Index references** to related notes in frontmatter or body
8. **Review regularly** and archive completed items

## Troubleshooting

**Problem**: Not sure where to classify a note
**Solution**: Create in `0. 📬 Inbox/` with `#triage` tag for later review

**Problem**: No template fits the note type
**Solution**: Use `quick-note.md` or `reference-quick.md` as base

**Problem**: User mentions multiple projects
**Solution**: Ask which project is primary, or create in both with cross-references

**Problem**: Note spans multiple categories
**Solution**: Use multiple tags and create links between notes

## Scripts & Automation

This skill can use helper scripts from `/a0/usr/skills/obsidian-note-creator/scripts/`:

- `classify_note.py` - Analyze content and suggest PARA location
- `generate_tags.py` - Suggest relevant tags based on content
- `validate_frontmatter.py` - Check frontmatter compliance

## Templates Directory

Custom templates can be stored in `/a0/usr/skills/obsidian-note-creator/templates/`:

- `recipe.md` - Specialized recipe template
- `code-snippet.md` - Code-specific reference template
- `meeting-project.md` - Project meeting template

## Security & Permissions

- **Never create** notes outside the project vault directory
- **Never overwrite** existing files without confirmation
- **Always sanitize** user input for YAML frontmatter
- **Respect** user's file naming preferences
- **Backup** important notes before bulk operations

---
