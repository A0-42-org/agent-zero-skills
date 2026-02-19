---
name: tiptap-svelte
description: Setup Tiptap editor with SvelteKit and Svelte 5. Use when adding WYSIWYG
  editing capabilities to Svelte applications. Covers Tiptap installation, component
  creation with Svelte 5 runes, toolbar configuration, and data persistence.
license: MIT
trigger_patterns:
- tiptap
- tiptap editor
- wysiwyg editor
- rich text editor svelte
version: 1.0.0
author: Agent Zero Team
tags:
- editor
- wysiwyg
- rich-text
- sveltekit
- tiptap
---

# Tiptap Editor for SvelteKit

Setup Tiptap WYSIWYG editor in SvelteKit with Svelte 5 runes.

## Installation

```bash
bun add @tiptap/core @tiptap/starter-kit @tiptap/pm
bun add -D @tiptap/pm
```

## Basic Tiptap Component

### Minimal Example

```typescript
<script lang="ts">
	import { onMount } from 'svelte';
	import { Editor } from '@tiptap/core';
	import StarterKit from '@tiptap/starter-kit';
	import type { JSONContent } from '@tiptap/core';

	let editorElement: HTMLElement;
	let editor: Editor | null = null;

	onMount(() => {
		editor = new Editor({
			element: editorElement,
			extensions: [StarterKit],
			content: '<p>Hello world!</p>'
		});
	});

	$effect(() => {
		// Clean up on unmount
		return () => {
			editor?.destroy();
		};
	});
</script>

<div bind:this={editorElement}></div>
```

## Svelte 5 Runes Component

### Complete Example with Toolbar

```typescript
<script lang="ts">
	import { Editor } from '@tiptap/core';
	import StarterKit from '@tiptap/starter-kit';
	import type { JSONContent } from '@tiptap/core';

	interface Props {
		content: JSONContent;
		onUpdate?: (content: JSONContent) => void;
	}

 	let { content, onUpdate }: Props = $props();

 	let editor: Editor | null = $state(null);
 	let editorElement: HTMLElement;
 	let initialized = $state(false);

 	$effect(() => {
 		if (!initialized && editorElement) {
 			editor = new Editor({
 				element: editorElement,
 				extensions: [StarterKit],
 				content: content,
 				editorProps: {
 				attributes: {
 					class: 'prose prose-sm sm:prose lg:prose-lg xl:prose-xl focus:outline-none min-h-[300px] max-w-none p-4 text-gray-900'
 				}
 			},
 				onUpdate: ({ editor }) => {
 					onUpdate?.(editor.getJSON());
 				}
 			});
 			initialized = true;
 		}

 		// Cleanup
 		return () => {
 			if (editor) {
 				editor.destroy();
 				editor = null;
 				initialized = false;
 			}
 		};
 	});

 	$effect(() => {
 		if (editor && initialized) {
 			const currentContent = editor.getJSON();
 			const contentStr = JSON.stringify(content);
 			const currentStr = JSON.stringify(currentContent);
 			if (contentStr !== currentStr) {
 				editor.commands.setContent(content);
 			}
 		}
 	});

	// Toolbar functions
	function toggleBold() {
		editor?.chain().focus().toggleBold().run();
	}

	function toggleItalic() {
		editor?.chain().focus().toggleItalic().run();
	}

	function setHeading(level: 1 | 2 | 3) {
		editor?.chain().focus().toggleHeading({ level }).run();
	}

	function toggleBulletList() {
		editor?.chain().focus().toggleBulletList().run();
	}

	function toggleOrderedList() {
		editor?.chain().focus().toggleOrderedList().run();
	}
</script>

<div class="border border-gray-300 rounded-lg overflow-hidden">
	<!-- Toolbar -->
	<div class="flex flex-wrap gap-1 p-2 bg-gray-50 border-b border-gray-300 text-gray-900">
		<button
			type="button"
			onclick={toggleBold}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('bold') ? 'bg-gray-300' : ''}"
		>
			<b>B</b>
		</button>
		<button
			type="button"
			onclick={toggleItalic}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('italic') ? 'bg-gray-300' : ''}"
		>
			<i>I</i>
		</button>
		<div class="w-px bg-gray-300 mx-1"></div>
		<button
			type="button"
			onclick={() => setHeading(1)}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('heading', { level: 1 }) ? 'bg-gray-300' : ''}"
		>
			H1
		</button>
		<button
			type="button"
			onclick={() => setHeading(2)}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('heading', { level: 2 }) ? 'bg-gray-300' : ''}"
		>
			H2
		</button>
		<button
			type="button"
			onclick={() => setHeading(3)}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('heading', { level: 3 }) ? 'bg-gray-300' : ''}"
		>
			H3
		</button>
		<div class="w-px bg-gray-300 mx-1"></div>
		<button
			type="button"
			onclick={toggleBulletList}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('bulletList') ? 'bg-gray-300' : ''}"
		>
			• List
		</button>
		<button
			type="button"
			onclick={toggleOrderedList}
			class="px-3 py-1 text-sm font-medium rounded hover:bg-gray-200 {editor?.isActive('orderedList') ? 'bg-gray-300' : ''}"
		>
			1. List
		</button>
	</div>

	<!-- Editor -->
	<div class="bg-white" bind:this={editorElement}></div>
</div>
```

## Usage in SvelteKit Pages

```typescript
<script lang="ts">
	import TiptapEditor from '$lib/components/tiptap-editor.svelte';
	import type { JSONContent } from '@tiptap/core';

	let editorContent = $state<JSONContent>({ type: 'doc', content: [] });

	function handleSave() {
		console.log('Saving:', JSON.stringify(editorContent));
		// Send to server action or API
	}
</script>

<div class="container mx-auto p-4">
	<h1 class="text-2xl font-bold mb-4">Edit Content</h1>

	<TiptapEditor
		content={editorContent}
		onUpdate={(content) => {
			editorContent = content;
		}}
	/>

	<button onclick={handleSave} class="mt-4 px-4 py-2 bg-blue-600 text-white rounded">
		Save
	</button>
</div>
```

## Server Actions for Persistence

### Load Content

```typescript
// +page.server.ts
import { db } from "$lib/db";
import { landingPageContent } from "$lib/db/schema";
import { eq } from "drizzle-orm";

export const load = async () => {
  const sections = await db.select().from(landingPageContent);
  return { sections };
};
```

### Save Content

```typescript
// +page.server.ts
import { fail } from "@sveltejs/kit";
import { db } from "$lib/db";
import { landingPageContent } from "$lib/db/schema";
import { eq } from "drizzle-orm";
import type { JSONContent } from "@tiptap/core";

export const actions = {
  default: async ({ request }) => {
    const formData = await request.formData();
    const sectionName = formData.get("section_name") as string;
    const content = formData.get("content") as string;

    if (!sectionName || !content) {
      return fail(400, { error: "Missing required fields" });
    }

    const parsedContent = JSON.parse(content) as JSONContent;

    const existingSection = await db
      .select()
      .from(landingPageContent)
      .where(eq(landingPageContent.sectionName, sectionName))
      .limit(1);

    if (existingSection.length > 0) {
      await db
        .update(landingPageContent)
        .set({ content: parsedContent, updatedAt: new Date() })
        .where(eq(landingPageContent.sectionName, sectionName));
    } else {
      await db.insert(landingPageContent).values({
        sectionName,
        content: parsedContent,
      });
    }

    return { success: true };
  },
};
```

## Database Schema

```typescript
// src/lib/db/schema.ts
import { pgTable, serial, text, timestamp, jsonb } from "drizzle-orm/pg-core";

export const landingPageContent = pgTable("landing_page_content", {
  id: serial("id").primaryKey(),
  sectionName: text("section_name").notNull().unique(),
  content: jsonb("content").notNull(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export type LandingPageContent = typeof landingPageContent.$inferSelect;
```

## Live Preview

Create a readonly editor for preview. **IMPORTANT**: This MUST be a separate component (`TiptapPreview.svelte`) in `src/lib/components/` to avoid server-side import errors in SvelteKit pages.

```typescript
// src/lib/components/tiptap-preview.svelte
<script lang="ts">
	import { Editor } from '@tiptap/core';
	import StarterKit from '@tiptap/starter-kit';
	import type { JSONContent } from '@tiptap/core';

	interface Props {
		content: JSONContent;
	}

	let { content }: Props = $props();
	let editorElement: HTMLElement;
	let editor: Editor | null = $state(null);
	let initialized = $state(false);

	$effect(() => {
		if (!initialized && editorElement) {
			editor = new Editor({
				element: editorElement,
				extensions: [StarterKit],
				content: content,
				editable: false,
				editorProps: {
				attributes: {
					class: 'prose focus:outline-none max-w-none p-6 text-gray-900'
				}
			}
			});
			initialized = true;
		}

		return () => {
			if (editor) {
				editor.destroy();
				editor = null;
				initialized = false;
			}
		};
	});

	$effect(() => {
		if (editor && initialized) {
			const currentContent = editor.getJSON();
			const contentStr = JSON.stringify(content);
			const currentStr = JSON.stringify(currentContent);
			if (contentStr !== currentStr) {
				editor.commands.setContent(content);
			}
		}
	});
</script>

<div class="prose bg-gray-50 rounded-lg p-4" bind:this={editorElement}></div>
```

### Using Preview in Pages

```typescript
// +page.svelte
<script lang="ts">
	import TiptapPreview from '$lib/components/tiptap-preview.svelte';
	import type { JSONContent } from '@tiptap/core';

	interface PageData {
		sections: Array<{ id: number; sectionName: string; content: JSONContent }>;
	}

	let { data }: { data: PageData } = $props();
	let selectedSection = $state('');
	let editorContent = $state<JSONContent>({ type: 'doc', content: [] });

	$effect(() => {
		if (selectedSection && data.sections) {
			const section = data.sections.find((s) => s.sectionName === selectedSection);
			editorContent = section?.content || { type: 'doc', content: [] };
		}
	});
</script>

<TiptapPreview content={editorContent} />
```

## Additional Extensions

### Rich Text Features

```bash
bun add @tiptap/extension-link @tiptap/extension-image @tiptap/extension-code-block-lowlight
```

```typescript
import Link from "@tiptap/extension-link";
import Image from "@tiptap/extension-image";
import CodeBlockLowlight from "@tiptap/extension-code-block-lowlight";
import { common, createLowlight } from "lowlight";

const lowlight = createLowlight(common);

editor = new Editor({
  element: editorElement,
  extensions: [
    StarterKit,
    Link,
    Image,
    CodeBlockLowlight.configure({ lowlight }),
  ],
  content: content,
});
```

### Table Support

```bash
bun add @tiptap/extension-table @tiptap/extension-table-row
```

## Styling

Tailwind CSS classes for Tiptap content:

```css
/* Basic prose styling */
.prose {
  max-width: 65ch;
  line-height: 1.75;
}

.prose h1 {
  font-size: 2.25rem;
  font-weight: 700;
  margin-bottom: 0.8em;
}

.prose p {
  margin-bottom: 1em;
}

.prose ul,
.prose ol {
  margin-left: 1.5em;
  margin-bottom: 1em;
}
```

Or use Tailwind Typography plugin:

```bash
bun add -D @tailwindcss/typography
```

For **Tailwind CSS v4**, use `@plugin` syntax in your CSS:

```css
/* src/routes/layout.css or app.css */
@import "tailwindcss";
@plugin '@tailwindcss/forms';
@plugin '@tailwindcss/typography';
```

Then use in HTML:

```html
<div class="prose prose-sm sm:prose lg:prose-lg xl:prose-xl">
  <!-- Tiptap editor content -->
</div>
```

**IMPORTANT**: With Tailwind v4, use `@plugin` instead of `@import` for plugins like `@tailwindcss/forms` and `@tailwindcss/typography`.

## Common Pitfalls

1. **No text color**: Always add `text-gray-900` to editor class (and toolbar)
2. **Memory leaks**: Always call `editor?.destroy()` on cleanup, and reset `editor = null` and `initialized = false`
3. **Reactive updates**: Use `$effect` to react to content changes, not `onMount`
4. **Form submissions**: Serialize content with `JSON.stringify()` before sending
5. **Content loading**: Parse JSON with `JSON.parse()` before setting content
6. **Styling issues**: Use Tailwind's `prose` classes or custom CSS for content
7. **Extensions**: Load extensions before creating the editor instance
8. **CRITICAL - Server-side imports**: NEVER import `Editor` or `StarterKit` in SvelteKit page files (`+page.svelte`, `+layout.svelte`, etc.). These packages only work client-side. Always create separate components (`TiptapEditor.svelte`, `TiptapPreview.svelte`) in `src/lib/components/` and import those instead.
9. **Initialization loops**: Use an `initialized` flag in `$effect` to prevent re-initializing the editor when content changes, and check content equality before setting it.

## Testing

After setup, verify:

1. `bun check` passes (no TypeScript errors)
2. `bun lint` passes (no ESLint/Prettier errors)
3. Dev server starts without errors (`bun dev`)
4. Editor renders without console errors
5. Toolbar buttons activate/deactivate correctly
6. Content updates on typing
7. Form submission sends correct JSON
8. Database stores/retrieves content correctly
9. Preview displays formatted content
10. Cleanup works (no memory leaks, check devtools memory tab)
11. **CRITICAL**: No server-side import errors (check that `Editor` and `StarterKit` are NOT imported in `+page.svelte` or other route files)

## Performance Tips

1. Debounce `onUpdate` callbacks for large documents
2. Use `editor.getHTML()` instead of `editor.getJSON()` when possible
3. Lazy load extensions for large feature sets
4. Implement virtual scrolling for very long documents
