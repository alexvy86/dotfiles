---
name: understand-pr
description: >-
  Help the user understand a pull request through a guided code walkthrough and
  focused review preparation. Use when the user asks to understand a PR, walk
  through its implementation or design, or identify behavior changes, risks, and
  questions to investigate before reviewing it. Supports GitHub and Azure DevOps.
---

# Understand a PR

Build a useful mental model of the change, then show the user where to focus
their review. Explain the implementation rather than inventorying changed files.

## Establish the scope

- Resolve the PR from the user's reference or the current session. Ask for the
  missing PR or repository only when the available context is ambiguous.
- Use the provider identified by the PR URL. Follow applicable provider skills;
  prefer `gh` for GitHub and load `az-use` before running Azure CLI commands.
- Reuse metadata and checkout information from earlier preparation. This skill
  can follow `time-to-review-pr`; do not repeat its setup or trigger it merely
  to read a PR.
- Identify the source commit and comparison base used for the explanation.
  Verify that local files match that source commit before citing them as PR code.
- Stay read-only by default. Do not switch branches, edit code, install
  dependencies, run builds or tests, or post review feedback as part of a walkthrough.
  Use the PR API when a suitable checkout is unavailable.

## Trace the change

1. Read the PR description and diff overview together. Read linked requirements
   and relevant review discussions when they clarify intent or constraints.
   Treat descriptions and comments as claims to check against the code.
2. Read the substantive diff and enough surrounding code to explain it. For local
   Git comparisons, use the merge base with the target and the exact source
   commit, not a tip-to-tip comparison that includes unrelated target changes.
3. Group the change into a few conceptual pieces. Follow the main execution or
   data flow through entry points, changed logic, and observable results. Read
   unchanged callers, contracts, and helpers when needed to establish that flow.
4. Compare old and new behavior. Identify affected consumers, invariants, failure
   paths, and compatibility constraints where relevant. Separate intentional
   behavior changes from refactoring.
5. Read the related tests. Explain which important behaviors they exercise and
   which review questions remain open. Do not imply that tests passed because
   they exist or that absent coverage proves a defect.

Batch independent reads and reuse retrieved evidence. Handle the walkthrough
directly unless the user requests delegation or another instruction requires it.
For a large PR, prioritize the main behavior-changing paths and explicitly name
any areas not examined; do not imply complete coverage.

## Deliver the walkthrough

- Start with a short account of the problem, the approach, and the resulting
  behavior. Distinguish the author's stated intent from what the code establishes.
- Walk through the conceptual pieces in execution or dependency order. For each,
  connect the previous behavior, the changed mechanism, and its consequence.
  Explain design choices and trade-offs only to the extent supported by evidence;
  label inferred rationale.
- Anchor important claims to a few precise file, symbol, or line references.
  Use provider links pinned to the inspected commit where available. Include
  short code excerpts only when they make a mechanism easier to understand.
- End with focused review preparation: the highest-impact behavior changes,
  risks grounded in the implementation, and concrete questions or checks that
  would resolve uncertainty. Tie each to the relevant code or test.
- Separate confirmed problems from potential risks and open questions. This is
  not an exhaustive correctness or security audit, an approval recommendation,
  or authorization to post comments.
- Keep the first walkthrough focused on the main path, with enough detail to
  make its causal relationships clear. Do not dump every file or stop for
  confirmation between each step. Follow the user's next question into the
  relevant detail without repeating the full explanation.
- State material access limitations, omitted scope, or commit mismatches plainly.
  If the PR changes during the walkthrough, keep references tied to the inspected
  revision and distinguish later updates from the code already explained.