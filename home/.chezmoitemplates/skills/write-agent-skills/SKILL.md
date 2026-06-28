---
name: write-agent-skills
description: >-
  Use when creating or editing agent skill files.
---

# write-agent-skills

When authoring or revising a skill keep `SKILL.md` focused on what the skill does,
when it should be used by an LLM, and how it should be executed. Deterministic
behavior using scripts or exact commands for the agent to run should be prioritized
when possible.

Move human-only rationale, implementation details, and long examples to `README.md`.

## Guidelines

- Write the description as scope + trigger (what it does, when to use it). "How" or "why" belong in `README.md`, not `SKILL.md`.
- Historical context and deep implementation notes belong in `README.md`, not `SKILL.md`.
- Put human-facing explanations and extended examples in `README.md`.

## Quick quality check

- If a sentence does not change agent behavior at runtime, move it to `README.md`.
- Prefer short, specific bullets over long prose.
- Avoid repeating the same rule across description and body.
