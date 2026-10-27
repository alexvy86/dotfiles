---
name: write-clear-technical-prose
description: >-
  Write clear, coherent technical prose. Use when drafting or revising code
  comments, documentation, or pull request titles/descriptions.
---

# Write Clear Technical Prose

## Write toward a point

- Identify the reader and what they need to understand, decide, or do.
- State the main point early. Select supporting details for their contribution
  to that point, not merely because they appeared during the work.
- Organize around the reader's question, not the order in which you investigated
  or changed files.

## Connect the ideas

- Build a coherent explanation, not a collection of related facts. Give each
  paragraph one purpose and develop it through relevant context, reasoning,
  and consequence.
- Make important relationships explicit: what caused the problem, why the
  chosen approach addresses it, and what follows from the change.
- Let each sentence advance the explanation. Connect it to what came before
  instead of repeatedly introducing another fact about the same topic.
- Use transitions when they express a real relationship. Adding "therefore"
  does not repair missing reasoning.
- Do not turn the explanation into storytelling, suspense, or a chronological
  account of your work.
- Do not invent rationale or causal connections to make the prose flow.
  Distinguish established facts from assumptions and unverified claims.

## Be concise without becoming cryptic

- Remove repetition, filler, and details that do not change the reader's
  understanding.
- Preserve the reasoning that makes a conclusion understandable. Do not
  compress prose into terse, disconnected statements.
- Prefer concrete subjects and verbs over abstract claims such as "improves
  robustness." Describe the actual behavior or consequence.
- Use paragraphs for explanations and bullets for genuinely independent items,
  steps, or checks. Do not turn every sentence into a bullet.
- Use headings when they help readers navigate. Avoid arbitrary length targets,
  mandatory sections, and empty template headings unless the repository or
  requested format requires them.

## Adapt to the artifact

### Code comments

- Explain intent, constraints, or surprising choices that the code cannot
  express clearly. Do not narrate the implementation.
- Keep comments close to the code they explain. Include enough context to
  preserve a non-obvious constraint without recounting the development history.
- Follow the repository's conventions for API documentation and structured
  comments; include caller-facing contracts where relevant.

### Documentation

- Organize around the reader's task or question. Put prerequisites before
  actions and explain consequences where they affect a choice.
- Separate procedures from conceptual explanations when combining them would
  interrupt the reader's task.
- Include examples when they resolve ambiguity or make an instruction usable,
  not merely to repeat the surrounding prose.

### Pull request descriptions

- Explain the problem, the approach, and the resulting behavior as a connected
  account. For a small change, a short paragraph may be enough.
- Include trade-offs, compatibility concerns, and verification where relevant.
  Distinguish checks actually run from checks proposed or not run.
- Summarize implementation details only when they help reviewers evaluate the
  change. Do not inventory the diff or recount your tool use.
- Respect the repository's PR template, but avoid repeating the same explanation
  across sections.

## Revise before delivering

Read the draft as someone who has not followed the work:

- Can the reader identify the main point and why it matters?
- Do the supporting facts establish that point, with their relationships clear?
- Does each paragraph have a purpose, rather than merely a shared topic?
- Can any detail be removed without losing meaning or necessary evidence?
- Are rationale, behavior, and verification claims supported by the available
  evidence?

Repair missing connections and remove unnecessary detail before delivering.
