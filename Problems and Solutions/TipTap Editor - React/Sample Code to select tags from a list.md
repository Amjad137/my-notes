
```typescript
'use client';
import type { ParentCode } from '@/db/schema/app-schema';
import Mention from '@tiptap/extension-mention';
import { EditorContent, useEditor } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import React, { useCallback } from 'react';

type ParentCodeTextAreaProps = {
	value: string;
	onChange: (value: string) => void;
	disabled?: boolean;
	parentCodes: ParentCode[];
	placeholder?: string;
};

const ParentCodeTextArea = ({
	value,
	onChange,
	disabled = false,
	parentCodes = [],
	placeholder = '내용을 입력해주세요.',
}: ParentCodeTextAreaProps) => {
	// Setup the ParentCode Mention extension - removed suggestion char
	const ParentCodeMention = Mention.configure({
		HTMLAttributes: {
			class: 'parent-code-mention',
		},
		suggestion: {
			char: '', // Empty char to prevent @ symbol
		},
		renderLabel({ node }) {
			// Just return the label without any prefix
			return `${node.attrs.label}`;
		},
	});

	// Initialize editor
	const editor = useEditor({
		extensions: [StarterKit, ParentCodeMention],
		content: value,
		onUpdate: ({ editor }) => {
			onChange(editor.getHTML());
		},
		editable: !disabled,
	});

	// Insert parent code as mention
	const insertParentCode = useCallback(
		(code: ParentCode) => {
			if (!editor)
				return;

			// Insert mention at current position
			editor
				.chain()
				.focus()
				.insertContent({
					type: 'mention',
					attrs: {
						id: String(code.id),
						label: code.name,
					},
				})
				.run();
		},
		[editor],
	);

	return (
		<div className="flex gap-2">
			{/* Add styling for mentions */}
			<style>
				{`
				.parent-code-mention {
					background-color: #dbeafe;
					color: #1e40af;
					padding: 0.1rem 0.3rem;
					border-radius: 0.25rem;
					font-weight: 500;
					white-space: nowrap;
				}

				/*multiline editing */
				.ProseMirror {
					min-height: 150px;
					height: 100%;
					outline: none;
					white-space: pre-wrap; /* Allow line wrapping */
					overflow-wrap: break-word;
				}

				.ProseMirror p {
					margin: 1em 0;
				}

				/* First paragraph should not have top margin */
				.ProseMirror p:first-child {
					margin-top: 0;
				}
			`}
			</style>

			{/* Editor content - fixed height and overflow */}
			<div className="w-full h-[200px] overflow-y-auto rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
				<EditorContent editor={editor} placeholder={placeholder} />
			</div>

			{/* Parent code buttons */}
			<div className="bg-white rounded-md border shadow-sm w-1/4">
				<div className="flex w-full justify-between items-center pb-1 pt-3 px-3 mb-2 border-b">
					<p className="text-sm text-foreground mb-2">변수 설정:</p>
					<p className="text-sm text-foreground mb-2 text-right">더보기</p>
				</div>
				<div className=" grid grid-cols-2 gap-2 px-3 min-w-[25%]">
					{parentCodes.map(code => (
						<button
							type="button"
							key={code.id}
							onClick={() => insertParentCode(code)}
							className="inline-flex items-center px-2.5 py-1 rounded-lg text-sm font-medium bg-gray-700 text-primary-foreground hover:bg-muted-foreground cursor-pointer transition-colors"
						>
							{code.name}
						</button>
					))}
				</div>
			</div>
		</div>
	);
};

export default ParentCodeTextArea;

```

# Explanation

Great question — understanding how the CSS applies in this React + Tiptap setup will give you solid control over styling.

---

## ✅ Where and How CSS Is Applied

In your component, the CSS is defined inside a `<style>` tag **inside the JSX**, like this:

```tsx
<style>
  {`
    .parent-code-mention {
      background-color: #dbeafe;
      color: #1e40af;
      padding: 0.1rem 0.3rem;
      border-radius: 0.25rem;
      font-weight: 500;
      white-space: nowrap;
    }

    .ProseMirror {
      min-height: 150px;
      height: 100%;
      outline: none;
      white-space: pre-wrap;
      overflow-wrap: break-word;
    }

    .ProseMirror p {
      margin: 1em 0;
    }

    .ProseMirror p:first-child {
      margin-top: 0;
    }
  `}
</style>
```

This works because:

- **React JSX allows raw `<style>` tags**.
- The styles are scoped to the DOM (they're global, but only active while the component is mounted).
- It's a convenient way to style 3rd-party libraries (like Tiptap) without having to write a separate CSS or Tailwind plugin.

---

## 🎯 What Each Rule Does

### `parent-code-mention`
This styles the custom **Mention** node that represents a “parent code”:

```css
.parent-code-mention {
  background-color: #dbeafe;     /* Light blue */
  color: #1e40af;                /* Darker blue text */
  padding: 0.1rem 0.3rem;        /* Small padding */
  border-radius: 0.25rem;        /* Rounded corners */
  font-weight: 500;              /* Semi-bold text */
  white-space: nowrap;           /* Prevent line break */
}
```

This class is applied via the Mention extension’s configuration:

```ts
HTMLAttributes: {
  class: 'parent-code-mention',
}
```

---

### `.ProseMirror`
This is the class Tiptap automatically adds to its editable `div`. You’re styling the **entire editor’s behavior** here.

```css
.ProseMirror {
  min-height: 150px;
  height: 100%;
  outline: none;
  white-space: pre-wrap;       /* Wrap long text */
  overflow-wrap: break-word;   /* Prevent text overflow */
}
```

### `.ProseMirror p` and `.ProseMirror p:first-child`
Control vertical spacing between paragraphs:

```css
.ProseMirror p {
  margin: 1em 0; /* default spacing for each paragraph */
}

.ProseMirror p:first-child {
  margin-top: 0; /* remove extra space at top */
}
```

---

## 🧠 When Would You Use This Approach?

- When you want to apply styles **just inside this component**, not globally.
- When you’re working with **third-party libraries** like Tiptap that use generated DOM nodes (e.g., `div.ProseMirror`, custom tags like `mention`).
- When you want quick, component-scoped styling without maintaining a separate `.css` file.

---

## ⚠️ Things to Watch Out For

- The `<style>` tag affects **global styles**, so if you mount this component multiple times, styles may collide.
- It doesn’t benefit from **Tailwind's JIT purge**, so you're mixing custom CSS and Tailwind.
- You can **move this CSS into a CSS module or global stylesheet** if it grows.

---

Would you like help refactoring this to Tailwind utility classes or a CSS module for better maintainability?