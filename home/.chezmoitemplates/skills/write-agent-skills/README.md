# write-agent-skills

This folder defines guidance for writing concise agent skills.

## Frontmatter specification

Every SKILL.md starts with YAML frontmatter. Agents frequently mess this up, so the rules are strict:

```yaml
---
name: pnpm-use
description: >
  Use when a task requires pnpm, corepack, node, or fnm and a command fails
  with "pnpm: command not found" or similar. [Trigger + outcome.]
---
```

### Requirements

- **Opening and closing delimiters:** `---` on their own lines (no inline text).
- **Exactly two fields:** `name:` and `description:`. Nothing else.
- **name format:** lowercase, hyphens as separators (e.g., `az-use`, `pnpm-use`), no spaces or underscores.
- **description format:** YAML folded scalar (`>` or `>-`). Write 1–3 sentences of outcome + trigger.

### Common agent mistakes

| Mistake | Example | Fix |
| --- | --- | --- |
| Extra fields | `author:`, `tags:`, `version:` | Remove them; only `name:` and `description:`. |
| Unfolded multiline | No `>` or `>-` on description | Add `>-` and indent the text. |
| Verbose description | 4+ sentences with internal details | Keep 1–3 sentences. Move extras to README. |
| Description with "how" | "Use when... by running... which works because..." | Describe trigger and outcome only. Explain mechanism in README. |
| Bad name format | `PnpmUse` or `pnpm_use` | Use lowercase with hyphens: `pnpm-use`. |

## Principle

`SKILL.md` body is runtime instruction text for an LLM, so it should only contain:

- what the skill does
- when the skill should be invoked
- only the minimum behavior rules needed at runtime

## Keep out of SKILL.md

Move these to `README.md` (or other human docs) instead:

- implementation internals
- historical rationale
- long tutorials and background context
- references and links for humans

## Description quality bar

A good description is short and answers two questions:

- What outcome does this skill provide?
- In what situation should the model use it?

Avoid explaining mechanisms unless they are mandatory for correct execution.
