---
name: pnpm-use
description: >-
  Use when a task requires pnpm, corepack, node, or fnm and a command fails with
  "pnpm: command not found", "corepack: command not found", "fnm: command not
  found", "node: command not found", or a wrong Node version. Some agent
  harnesses run the shell without loading the login profile, so the toolchain
  (fnm and the Node version it manages) is not on PATH. This skill explains how
  to restore it.
---

# pnpm-use

{{- $winScoopShimsPathBash := "" -}}
{{- if .is_windows -}}
{{- $winScoopShimsPathBash = ((joinPath .chezmoi.config.scriptEnv.WIN_TOOLS_PATH "/scoop/shims") | replaceAllRegex "\\\\" "/") -}}
{{- end }}

## What's going on

The Node toolchain on this machine is managed by **fnm**. The shell profiles
({{ if .is_windows }}PowerShell profile, `.bashrc` for Git Bash{{ else }}`.profile`, `.bashrc`, `.zshrc`{{ end }}) normally run `fnm env ...` on startup, which puts
fnm's currently-active Node — and therefore `node`, `npm`, `npx`, and
`corepack` — onto `PATH`. `pnpm` itself is provided by **corepack** (which ships
with Node), not installed globally.

Some harnesses launch the shell tool **without loading the login profile**. When
that happens nothing fnm-managed is on `PATH`, so commands fail with errors like:

- `pnpm: command not found`
- `corepack: command not found`
- `fnm: command not found`
- `node: command not found`
- pnpm/node runs but reports an unexpected version

## The fix

Re-create what the profile would have done: get `fnm` on `PATH`, then evaluate
`fnm env` so the active Node (and corepack) become available. Do **not** try to
hand-add the Node directory to `PATH` — fnm stores each Node version under a
version-specific multishell directory, so `fnm env` is the reliable way to get
the right path.

On this machine fnm lives at a known location:

{{ if .is_windows -}}
- **fnm binary:** `{{ $winScoopShimsPathBash }}/fnm` (installed via scoop)
- In PowerShell, rather than locating fnm by path, the cleanest fix is to replay
  your persisted **User** PATH from the registry — it already contains the scoop
  shims dir, so you never have to hardcode the install location.
{{- else -}}
- **fnm binary:** `$(brew --prefix)/bin/fnm` (installed via Homebrew), typically `/home/linuxbrew/.linuxbrew/bin/fnm`
- **Legacy fallback:** `~/.local/share/fnm/fnm`
{{- end }}

**Important:** In many harnesses each shell command runs in a fresh process, so
environment changes do **not** persist between commands. Combine the setup and
the real command in a **single** invocation (e.g.
`eval "$(fnm env ...)" && pnpm install`), or run the command through a login
shell (`bash -l -c "..."`).

{{ if .is_windows -}}
### Git Bash (default shell)

```bash
# 1. Put fnm on PATH if it isn't already (scoop shims dir):
command -v fnm >/dev/null || export PATH="{{ $winScoopShimsPathBash }}:$PATH"

# 2. Load fnm's environment (this puts the active node + corepack on PATH).
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)"

# 3. Run your command in the SAME invocation, e.g.:
#    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)" && pnpm install
```

### PowerShell

Restore your persisted User PATH (which already includes the scoop shims dir),
then load fnm's environment. This single line is safe to add to an exact-match
command allowlist:

```powershell
$env:Path = "$([Environment]::GetEnvironmentVariable('Path','User'));$env:Path"; fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false | Out-String | Invoke-Expression
```

Then run pnpm, e.g. `pnpm install`. If the shell session doesn't persist between
commands, prefix your real command with the line above in the same invocation.
{{- else -}}
### bash / zsh

```bash
# 1. Put fnm on PATH if it isn't already. Homebrew is the primary location;
#    fall back to the legacy install dir.
if ! command -v fnm >/dev/null; then
  export PATH="$(brew --prefix 2>/dev/null)/bin:$HOME/.local/share/fnm:$PATH"
fi

# 2. Load fnm's environment (this puts the active node + corepack on PATH).
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)"

# 3. Run your command in the SAME invocation, e.g.:
#    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)" && pnpm install
```
{{- end }}

## If `pnpm` is still missing after Node is on PATH

`pnpm` is delivered through corepack. With Node available:

```bash
corepack enable pnpm
```

If the project pins a pnpm version via the `packageManager` field in
`package.json`, corepack will use that automatically once enabled.

## If the Node version is wrong

Inside the project directory (where a `.node-version`, `.nvmrc`, or `package.json`
`engines.node` may pin a version):

```bash
fnm use --install-if-missing
```

## Quick reference

| Symptom | Cause | Action |
| --- | --- | --- |
| `fnm: command not found` | fnm dir not on PATH | {{ if .is_windows }}PowerShell: restore User PATH (see above). Git Bash: add `{{ $winScoopShimsPathBash }}` to PATH{{ else }}Add `$(brew --prefix)/bin` (or `~/.local/share/fnm`) to PATH{{ end }} |
| `node`/`corepack` not found | `fnm env` not evaluated | `eval "$(fnm env ...)"` (or PowerShell equivalent) |
| `pnpm: command not found` | corepack shim not set up | `corepack enable pnpm` |
| wrong Node version | no version selected for this dir | `fnm use --install-if-missing` |
