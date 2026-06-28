# write-agent-skills

This folder defines guidance for writing concise agent skills.

## Principle

`SKILL.md` is runtime instruction text for an LLM, so it should only contain:

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
