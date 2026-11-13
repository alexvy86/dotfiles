---
name: write-clear-technical-prose
description: >-
  Write clear, coherent technical prose. Use for substantive conversational
  explanations and when drafting or revising code comments, documentation,
  pull request titles/descriptions, or other human-facing writing.
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
- Give explanations a through-line that answers the reader's question. Develop
  the reasoning rather than presenting disconnected observations. Do not confuse
  this progression with recounting your work chronologically or adding dramatic
  framing.
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

- Write for a future maintainer who can read the surrounding code but has not
  seen the task, conversation, PR, or earlier implementation.
- Explain intent, constraints, or surprising choices that the code cannot
  express clearly. Do not narrate the implementation.
- State the relevant condition or constraint and its consequence. Name the
  behavior or dependency that makes the choice necessary instead of assuming
  the reader already knows the problem being fixed.
- Describe the current contract, not the change history. Replace vague references
  such as "now", "the old behavior", or "this fixes the issue" with the specific
  reason: "Keep failed items queued so the next attempt can retry them."
- Keep comments close to the code they explain. Include only the context needed
  to understand the choice; do not make readers reconstruct it from a linked
  issue or PR.
- Follow the repository's conventions for API documentation and structured
  comments; include caller-facing contracts where relevant.

### Documentation

- Write for a reader who has not seen the task, conversation, PR, or earlier
  implementation. Include the context needed to understand the documented
  behavior and use it correctly; describe the current system rather than the
  change that produced it.
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
- Does the paragraph explain how its facts fit together, or leave the reader to
  infer the connections?
- Can any detail be removed without losing meaning or necessary evidence?
- Are rationale, behavior, and verification claims supported by the available
  evidence?
- Would each code comment still explain the relevant constraint and reason for
  the choice if the change discussion and diff were unavailable?

Repair missing connections and remove unnecessary detail before delivering.
