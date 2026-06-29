---
name: write-agent-skills
description: >-
  Use when creating or editing agent skill files.
---

# write-agent-skills

## Frontmatter: required fields and format

Every skill file **must** start with exactly:

```yaml
---
name: <skill-slug>
description: >
  <A few sentences describing the outcome + trigger condition>
---
```

**Required fields:**
- `name:` — unique identifier in lowercase with hyphens (e.g., `pnpm-use`, `az-use`). Must match the folder name.
- `description:` — single folded paragraph using YAML `>-` syntax; no more than 5 short sentences

**Description scope:**
- What does the skill do? (outcome)
- When should the model use it? (trigger condition)
- No "how" or "why"; no implementation details.

**Common mistakes to avoid:**
- Adding extra fields (`author:`, `tags:`, `version:`, etc.) — only `name:` and `description:`.
- Multi-line description without `>-` — always use YAML's `>-` for folding long text.
- Overly long description — if you want to explain more, the skill body is the next best place, but if it's not relevant to the agent, move it to `README.md`.

## Body: runtime instructions only

When authoring or revising a skill, keep `SKILL.md` focused on what the skill does,
when it should be used by an LLM, and how it should be executed. Deterministic
behavior using scripts or exact commands for the agent to run should be prioritized
when possible.

Move human-only rationale, implementation details, and long examples to `README.md`.

## Guidelines

- "How" or "why" belong in `README.md`, not `SKILL.md`.
- Historical context and deep implementation notes belong in `README.md`, not `SKILL.md`.
- Put human-facing explanations and extended examples in `README.md`.

## Quick quality check

- If a sentence does not change agent behavior at runtime, move it to `README.md`.
- Prefer short, specific bullets over long prose.
- Avoid repeating the same rule across description and body.
