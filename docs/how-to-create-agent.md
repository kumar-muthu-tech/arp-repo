# How to Create a New Agent

This project keeps agent navigation data and agent page content separate:

- `src/data/agents.ts` contains the agent name, description, URL, and content key.
- `src/content/agent/` contains the MDX content rendered on each agent page.
- `src/pages/agents/[agent].astro` automatically creates one page for every agent record.

## 1. Create the agent MDX file

Create a file in `src/content/agent/` using a lowercase filename.

Example:

```text
src/content/agent/word.mdx
```

Add frontmatter that matches the agent collection schema:

```mdx
---
title: "Word Agent"
description: "Create, edit, and analyze Word documents."
---

## What it does

The Word Agent helps users create and review documents.

## Best for

- Document generation
- Editing and rewriting
- Content analysis
```

The MDX filename becomes the content key. For `word.mdx`, the key is `word`.

## 2. Add the agent record

Open `src/data/agents.ts` and add an object to the `agents` array:

```ts
{
  slug: 'word',
  name: 'Word Agent',
  description: 'Create, edit, and analyze Word documents.',
  link: '/agents/word/',
  content: 'word'
}
```

The values must match as follows:

| Field | Purpose | Example |
| --- | --- | --- |
| `slug` | URL segment | `word` |
| `name` | Name shown in the Agents page | `Word Agent` |
| `description` | Short text shown on the agent card | `Create, edit, and analyze Word documents.` |
| `link` | Link used by the agent card | `/agents/word/` |
| `content` | MDX filename without `.mdx` | `word` |

Use lowercase slugs and links. For example, prefer `csv` and `/agents/csv/` instead of `CSV`.

## 3. Check the generated page

Start the development server:

```powershell
npm.cmd run dev
```

Open the Agents page:

```text
http://localhost:4321/agents/
```

Click the new agent. Its page will be available at:

```text
http://localhost:4321/agents/word/
```

## 4. Build for production

Run a production build after adding the agent:

```powershell
npm.cmd run build
```

Preview the generated site:

```powershell
npm.cmd run preview
```

Astro generates the static page in:

```text
dist/agents/word/index.html
```

## Common mistakes

- The `content` value does not match the MDX filename.
- The MDX file is outside `src/content/agent/`.
- The agent is missing from `src/data/agents.ts`.
- The `slug`, `link`, and dynamic route do not use the same lowercase value.
- The MDX frontmatter is missing `title` or `description`.
