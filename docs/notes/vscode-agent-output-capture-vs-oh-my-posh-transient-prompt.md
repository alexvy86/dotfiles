# VS Code agent terminal output capture vs. oh-my-posh transient prompt

## Summary

I noticed that the VS Code agent was reporting a lot of failures to capture the desired command output in terminals it started
(instead getting the prompt banner).

I traced it to the fact that if VS Code shell integration is active (OSC 633 markers), and oh-my-posh transient prompt rendering is enabled,
the redraw from the transient prompt duplicates marker boundaries and corrupts the capture region.

The fix is a config split gated by `COPILOT_AGENT=1`, which VSCode sets in agent terminals: there we use an oh-my-posh config without
`transient_prompt`; interactive terminals keep the normal config with transient prompt enabled.

This note documents the investigation and the implemented config-split fix for PowerShell and zsh.

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

`COPILOT_AGENT=1` is the signal we gate on: persistent, cross-platform, and absent from interactive terminals. That is
what lets us keep the transient prompt everywhere except the agent's terminal.

Note: `VSCODE_PREVENT_SHELL_HISTORY=1` is also set for agent terminals, but `shellIntegration.ps1` consumes and unsets
it during startup, so it is not reliably readable at runtime. Use `COPILOT_AGENT` instead.

## Resolution (PowerShell)

In `home/dot_config/powershell/profile.ps1.tmpl`, prompt init now selects one of two configs based on
`COPILOT_AGENT=1`:

```powershell
if ($env:COPILOT_AGENT -eq '1') {
    oh-my-posh init pwsh --config "~/.config/alexvy86-agent.omp.json" | Invoke-Expression;
}
else {
    oh-my-posh init pwsh --config "~/.config/alexvy86.omp.json" | Invoke-Expression;
}
```

`alexvy86-agent.omp.json` omits the `transient_prompt` block, so there is no runtime mutation of oh-my-posh internals.
Interactive terminals keep `alexvy86.omp.json` with transient prompt enabled.

## Implementation status

### ✅ zsh — COMPLETE

The fix was implemented in `home/dot_config/use-ohmyposh.sh` and validated on WSL/Linux with oh-my-posh 29.19.0 and
zsh 5.9. When `COPILOT_AGENT=1`, zsh initializes oh-my-posh with `~/.config/alexvy86-agent.omp.json` (which omits
`transient_prompt`). Interactive terminals keep `~/.config/alexvy86.omp.json` with transient prompt enabled.

### Open items: bash

`bash`: `oh-my-posh init bash` produced empty output on Windows, so the mechanism could not be inspected there. bash
transient also requires `ble.sh`. The fix placeholder is in `home/dot_config/use-ohmyposh.sh` (the `elif` branch),
documented as deferred pending testing in a bash environment. The `COPILOT_AGENT=1` signal is shell-agnostic (injected
by `_createCopilotTerminal` regardless of shell), so the same gate applies.

### ✅ Config generation model

- Shared base prompt payload lives in `home/.chezmoitemplates/alexvy86-omp.base.json`.
- Interactive config is generated by `home/dot_config/alexvy86.omp.json.tmpl` and injects `transient_prompt`.
- Agent config is generated by `home/dot_config/alexvy86-agent.omp.json.tmpl` and omits `transient_prompt`.

## Scrollback (separate issue)

The `Output exceeded terminal scrollback; beginning of output was lost` message is unrelated to the transient prompt.
It is a fixed-size scrollback cap: a very large output pushes earlier lines out of the buffer before capture. The
reliable workaround is to redirect to a file and read it back (e.g. `... | Out-File tmp.txt; Get-Content tmp.txt`),
which captures exact bytes independent of markers and scrollback.

## References

### Implementation files
- **PowerShell fix**: `home/dot_config/powershell/profile.ps1.tmpl`
  - Selects `~/.config/alexvy86-agent.omp.json` when `COPILOT_AGENT=1`
- **zsh fix**: `home/dot_config/use-ohmyposh.sh`
  - Selects `~/.config/alexvy86-agent.omp.json` when `COPILOT_AGENT=1`
- **bash placeholder**: `home/dot_config/use-ohmyposh.sh`
  - Documented as deferred; requires ble.sh support

### Configuration and references
- Base prompt config template (no transient prompt): `home/.chezmoitemplates/alexvy86-omp.base.json`
- Interactive prompt config template (adds transient prompt): `home/dot_config/alexvy86.omp.json.tmpl`
- Agent prompt config template (keeps transient prompt disabled): `home/dot_config/alexvy86-agent.omp.json.tmpl`
- Generated runtime configs: `~/.config/alexvy86.omp.json` and `~/.config/alexvy86-agent.omp.json`
- VS Code PowerShell shell integration:
  `resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.ps1`
- VS Code agent terminal env injection: `_createCopilotTerminal` in
  `resources/app/out/vs/workbench/workbench.desktop.main.js`
- oh-my-posh transient docs: <https://ohmyposh.dev/docs/configuration/transient>
- oh-my-posh transient variable source: `src/shell/pwsh.go` (`case Transient`) in
  <https://github.com/JanDeDobbeleer/oh-my-posh>
