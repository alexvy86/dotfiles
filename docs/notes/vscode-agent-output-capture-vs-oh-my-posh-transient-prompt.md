# VS Code agent terminal output capture vs. oh-my-posh transient prompt

## Summary

I noticed that the VS Code agent was reporting a lot of failures to capture the desired command output in terminals it started
(instead getting the prompt banner).

I traced it to the fact that if VS Code shell integration is active (OSC 633 markers), and oh-my-posh transient prompt rendering is enabled,
the redraw from the transient prompt duplicates marker boundaries and corrupts the capture region.

Separately, the agent never renders or reads the prompt visually — it only parses the OSC 633 markers programmatically — so a themed
prompt buys it nothing, while oh-my-posh's git-status segment can take up to ~20s to render in large monorepos, paid on every single
prompt in the session.

The fix is to skip Oh-My-Posh entirely in agent terminals, gated on `AI_AGENT` being set (which VS Code sets, with a tool-specific value,
in any agent terminal — not just Copilot's). This resolves both problems at once: no prompt re-render means no marker corruption, and no
render at all means no monorepo latency cost. An earlier iteration of this fix only swapped in a config without `transient_prompt`
(gated on the Copilot-specific `COPILOT_AGENT=1`); see [History](#history-config-split-fix) for that approach and why it was superseded.

This note documents the investigation, the original config-split fix, and the full-disable fix that replaced it.

## Symptom

- Only the agent is affected, never interactive use. A human reads the terminal live; the agent never sees the screen —
  it captures output programmatically.
- The agent would sometimes receive the transient prompt banner (`╰ 44 ❯`, `297ms` timing, timestamp) in place of a
  command's real output.
- Separately, very large outputs (e.g. a big `yarn install`) could trip
  `Output exceeded terminal scrollback; beginning of output was lost`. That is a **different** problem (see
  [Scrollback](#scrollback-separate-issue)).

## How VS Code captures command output

VS Code's integrated terminal injects its PowerShell shell integration script
(`resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.ps1`) when `VSCODE_INJECTION=1`. It
wraps two things and emits `OSC 633` escape sequences the terminal parser uses to slice output:

- The `prompt` function is wrapped to emit:
  - `OSC 633;A` — prompt start
  - the current working directory, then the original (oh-my-posh) prompt
  - `OSC 633;B` — command line start
- `PSConsoleHostReadLine` is wrapped to emit, right after the user's line is read and before it executes:
  - `OSC 633;E;<commandline>` — the command text
  - `OSC 633;C` — **output starts here**
  - and later `OSC 633;D;<exitcode>` — command finished (emitted by the next prompt)

Because VS Code injects **after** the user profile runs, it wraps whatever `prompt` already exists — i.e. oh-my-posh's.
So the live `$function:prompt` is VS Code's wrapper, which internally calls oh-my-posh's prompt.

## Root cause

oh-my-posh's transient prompt is driven by a PSReadLine Enter key handler (`OhMyPoshEnterKeyHandler`). On Enter it calls
`Set-TransientPrompt`, which calls `[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()` to repaint the previous
prompt line with the transient template.

`InvokePrompt()` **re-invokes the current `prompt` function** — which is now **VS Code's wrapper**. The transient
repaint therefore emits a **second, spurious `OSC 633;A` … `OSC 633;B` pair** immediately before the real
`OSC 633;E`/`OSC 633;C`. That duplicate marker pair shifts VS Code's output boundary detection and can cause capture of
the transient banner instead of command output.

The async **streaming** prompt (`_ompStreaming`, driven by `PowerShell.OnIdle` → `InvokePrompt()`) does the exact same
thing at nondeterministic times, which would explain any intermittency. It is off for the current config, but it is the
same class of bug.

## Why interactive use is unaffected

Interactive users read the screen directly and never depend on the `OSC 633` capture path. The bytes are on screen
regardless; only the programmatic *capture* is fooled by the duplicated markers.

## Detecting the agent terminal

VS Code's workbench creates the agent's terminal via a function `_createCopilotTerminal`
(in `resources/app/out/vs/workbench/workbench.desktop.main.js`) which injects these environment variables **only** into
agent/AI terminals — interactive integrated terminals never get them:

```text
AI_AGENT=github_copilot_vscode_agent
COPILOT_AGENT=1
GIT_PAGER=cat
GIT_MERGE_AUTOEDIT=no
GIT_EDITOR=:
DEBIAN_FRONTEND=noninteractive
```

Claude Code's VS Code agent terminal follows the same convention with a tool-specific value, e.g.
`AI_AGENT=claude-code_2-1-263_agent` (confirmed via `env` in a live Claude Code session; it also sets `CLAUDECODE=1`).
`AI_AGENT` — non-empty, not a specific value — is the signal we gate on: persistent, cross-platform, present in any
agent terminal (not just Copilot's), and absent from interactive terminals. `COPILOT_AGENT` was the original gate but
is Copilot-specific and misses other agents such as Claude Code's.

Note: `VSCODE_PREVENT_SHELL_HISTORY=1` is also set for agent terminals, but `shellIntegration.ps1` consumes and unsets
it during startup, so it is not reliably readable at runtime. Use `AI_AGENT` instead.

Note: this doesn't affect Claude Code's own `Bash` tool invocations on Windows — those run git-bash non-interactively
and `.bashrc` returns early before sourcing `use-ohmyposh.sh` at all (confirmed via `$-` in a live session). It only
matters for an actual interactive agent terminal, e.g. Copilot's VS Code agent terminal or an equivalent.

## Resolution

Skip Oh-My-Posh entirely when `AI_AGENT` is set, in both `home/dot_config/powershell/profile.ps1.tmpl` (PowerShell)
and `home/dot_config/use-ohmyposh.sh` (bash/zsh):

```powershell
if (-not $env:AI_AGENT) {
    oh-my-posh init pwsh --config "~/.config/alexvy86.omp.json" | Invoke-Expression;
}
```

No agent-specific oh-my-posh config is needed anymore — there is nothing to render, so there is nothing to configure.
This also transitively fixes the original transient-prompt corruption (no prompt render means no `InvokePrompt()`
re-entrancy), and additionally avoids paying oh-my-posh's git-status segment cost (up to ~20s in large monorepos) on
every prompt in an agent session.

## Implementation status

### ✅ PowerShell, zsh, bash — COMPLETE

All three shells gate the entire `oh-my-posh init` call on `AI_AGENT` being unset. Interactive terminals are
unaffected and keep `alexvy86.omp.json` (with transient prompt) exactly as before.

## History: config-split fix

The original (superseded) fix kept oh-my-posh running in agent terminals but swapped in a config without
`transient_prompt`, gated on the Copilot-specific `COPILOT_AGENT=1`:

```powershell
if ($env:COPILOT_AGENT -eq '1') {
    oh-my-posh init pwsh --config "~/.config/alexvy86-agent.omp.json" | Invoke-Expression;
}
else {
    oh-my-posh init pwsh --config "~/.config/alexvy86.omp.json" | Invoke-Expression;
}
```

`alexvy86-agent.omp.json` (generated from a shared base at `home/.chezmoitemplates/alexvy86-omp.base.json`) omitted
the `transient_prompt` block, so there was no runtime mutation of oh-my-posh internals. This fixed the marker
corruption but still paid the base render cost (git-status segment included) on every prompt, and only covered
Copilot's terminal since it gated on `COPILOT_AGENT`. It was validated on WSL/Linux zsh (oh-my-posh 29.19.0, zsh 5.9);
`oh-my-posh init bash` produced empty output on Windows so the bash path was never fully validated under this
approach. Superseded by the full-disable fix above, which needs no agent-specific config at all.

## Scrollback (separate issue)

The `Output exceeded terminal scrollback; beginning of output was lost` message is unrelated to the transient prompt.
It is a fixed-size scrollback cap: a very large output pushes earlier lines out of the buffer before capture. The
reliable workaround is to redirect to a file and read it back (e.g. `... | Out-File tmp.txt; Get-Content tmp.txt`),
which captures exact bytes independent of markers and scrollback.

## References

### Implementation files
- **PowerShell fix**: `home/dot_config/powershell/profile.ps1.tmpl`
  - Skips `oh-my-posh init` entirely when `$env:AI_AGENT` is set
- **zsh/bash fix**: `home/dot_config/use-ohmyposh.sh`
  - Skips `oh-my-posh init` entirely when `$AI_AGENT` is set

### Configuration and references
- Shared prompt config template (used for all interactive terminals): `home/dot_config/alexvy86.omp.json.tmpl`
- Shared base prompt payload: `home/.chezmoitemplates/alexvy86-omp.base.json`
- Generated runtime config: `~/.config/alexvy86.omp.json`
- VS Code PowerShell shell integration:
  `resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.ps1`
- VS Code agent terminal env injection: `_createCopilotTerminal` in
  `resources/app/out/vs/workbench/workbench.desktop.main.js`
- oh-my-posh transient docs: <https://ohmyposh.dev/docs/configuration/transient>
- oh-my-posh transient variable source: `src/shell/pwsh.go` (`case Transient`) in
  <https://github.com/JanDeDobbeleer/oh-my-posh>
