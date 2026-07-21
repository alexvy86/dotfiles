# VS Code agent terminal output capture vs. oh-my-posh transient prompt

## Summary

When an AI agent (GitHub Copilot's terminal tool in VS Code) runs a shell command, its programmatic capture of the
command's output could grab the **prompt banner instead of the command output**. The culprit is oh-my-posh's
**transient prompt** (the feature that rewrites the previous prompt line into the compact `✓ 297ms` +
`[count][timestamp]` banner). It interferes with the shell-integration markers VS Code uses to delimit output.

The fix disables the transient prompt **only inside agent terminals**, detected via the `COPILOT_AGENT` environment
variable that VS Code injects into those terminals. Interactive terminals are completely unaffected and keep the fancy
prompt.

This note documents the investigation so the same fix can be applied to `zsh`/`bash` later (still open — see
[Open items](#open-items-zshbash)).

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

`InvokePrompt()` **re-invokes the current `prompt` function** — which is now **VS Code's wrapper**. So the transient
repaint emits a **second, spurious `OSC 633;A` … `OSC 633;B` pair** immediately before the real `OSC 633;E`/`OSC 633;C`.
That extra marker pair moves the anchor VS Code uses to decide where the command's output begins, so the capture can
delimit the wrong region and return the transient banner instead of the output.

The other agent's shorthand — "the transient prompt emits/disturbs the markers" — is directionally right but
imprecise. The precise statement: the transient prompt triggers a **re-invocation of VS Code's prompt wrapper**, which
**duplicates** the `OSC 633` markers and corrupts the region boundaries.

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

In `home/dot_config/powershell/profile.ps1.tmpl`, right after the oh-my-posh init line:

```powershell
oh-my-posh init pwsh --config "~/.config/alexvy86.omp.json" | Invoke-Expression;

if ($env:COPILOT_AGENT -eq '1') {
    $global:_ompTransientPrompt = $false;
    $global:_ompStreaming = $false;
}
```

Verified live in an agent terminal: the gate matches, the flag flips `True` → `False`, and `chezmoi cat` renders the
template correctly. Interactive terminals never set `COPILOT_AGENT`, so they are untouched.

### Why we set an internal variable (no supported API)

There is no supported CLI or documented public function to disable the transient prompt at runtime:

- oh-my-posh's CLI `enable`/`disable` only handle `notice|upgrade|reload`; `toggle` is for **segments**.
- The docs state transient is enabled automatically whenever the config has a `transient_prompt` block; the only
  documented runtime switch is `cmd`-only (`clink set prompt.transient always`).
- `$global:_ompTransientPrompt` is oh-my-posh's **own** mechanism. Its Go source generates it
  (`src/shell/pwsh.go`: `case Transient: return "$global:_ompTransientPrompt = $true"`), and the generated Enter handler
  reads it live (`if ($global:_ompTransientPrompt -and $executingCommand) { Set-TransientPrompt }`).

So setting `$global:_ompTransientPrompt = $false` after init is the closest thing to a supported toggle. It is an
internal (underscore-prefixed) variable and therefore a known coupling point to watch across oh-my-posh upgrades, but it
is stable in practice and is the real runtime lever the tool itself uses. Editing the config to remove
`transient_prompt` would disable it globally (not conditionally, not runtime) and is not what we want.

The same branch also sets `$global:_ompStreaming = $false`. The async streaming prompt repaints via
`PowerShell.OnIdle` → `InvokePrompt()` the same way the transient prompt does, so it is a latent second cause of the
same bug. It is currently off for this config, but disabling it in the agent terminal (where no human is watching) is
pure insurance with no downside.

## Open items (zsh/bash)

The same class of problem applies to `zsh` and `bash`, but the fix is harder and was deferred to a session run from WSL
/ Linux / macOS (it cannot be developed or tested from Windows):

- `zsh`: the transient prompt is baked into the `_omp_zle-line-init` widget, which also runs the **entire** line editor
  (`zle .recursive-edit` + `zle .accept-line`) and calls `zle .reset-prompt` unconditionally. There is no clean toggle
  variable equivalent to PowerShell's `$global:_ompTransientPrompt`; `_omp_transient_prompt` is only a rendered-string
  cache, not a gate. The widget cannot simply be removed without breaking line editing. Candidate approaches:
  (a) select a transient-free oh-my-posh config when `COPILOT_AGENT=1`, or (b) override/replace the widget (deep,
  hacky). Confirm first whether `zle .reset-prompt` actually re-emits VS Code's `OSC 633` markers under the zsh shell
  integration (`shellIntegration-rc.zsh`), since the redraw path differs from PowerShell.
- `bash`: `oh-my-posh init bash` produced empty output on Windows, so the mechanism could not be inspected here. bash
  transient also requires `ble.sh`.
- The `COPILOT_AGENT=1` signal is shell-agnostic (injected by `_createCopilotTerminal` regardless of shell), so whatever
  mechanism is chosen, the same gate applies. The relevant init file is `home/dot_config/use-ohmyposh.sh`.

## Scrollback (separate issue)

The `Output exceeded terminal scrollback; beginning of output was lost` message is unrelated to the transient prompt.
It is a fixed-size scrollback cap: a very large output pushes earlier lines out of the buffer before capture. The
reliable workaround is to redirect to a file and read it back (e.g. `... | Out-File tmp.txt; Get-Content tmp.txt`),
which captures exact bytes independent of markers and scrollback.

## References

- Fix: `home/dot_config/powershell/profile.ps1.tmpl` (after the `oh-my-posh init pwsh` line)
- oh-my-posh config with the `transient_prompt` block: `home/dot_config/alexvy86.omp.json`
- Unix oh-my-posh init (zsh/bash, still open): `home/dot_config/use-ohmyposh.sh`
- VS Code PowerShell shell integration:
  `resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.ps1`
- VS Code agent terminal env injection: `_createCopilotTerminal` in
  `resources/app/out/vs/workbench/workbench.desktop.main.js`
- oh-my-posh transient docs: <https://ohmyposh.dev/docs/configuration/transient>
- oh-my-posh transient variable source: `src/shell/pwsh.go` (`case Transient`) in
  <https://github.com/JanDeDobbeleer/oh-my-posh>
