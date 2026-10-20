---
name: pnpm-use
description: >-
  Restore access to the fnm-managed Node toolchain only after a command fails
  because pnpm, corepack, node, or fnm is not found, or after confirming that
  Node's version does not match the project's requirement.
---

# pnpm-use

{{- $winScoopShimsPath := "" -}}
{{- $winScoopShimsPathBash := "" -}}
{{- if .is_windows -}}
{{- $winScoopShimsPath = joinPath .chezmoi.config.scriptEnv.WIN_TOOLS_PATH "scoop" "shims" -}}
{{- $winScoopShimsPathBash = ($winScoopShimsPath | replaceAllRegex "\\\\" "/") -}}
{{- end }}

## Applicability: check before any recovery

- Try the intended command normally first. Recover only after an actual
  missing-tool error for the Node toolchain or a confirmed Node-version mismatch.
  Once confirmed, reuse recovery for affected commands without repeating the
  known failure.
- Loading this skill, working in a Node repository, or observing profile bypass
  (such as `-NoProfile`) does not by itself justify recovery.
- Limit `fnm exec` and any toolchain `PATH` prefix to the affected Node-dependent
  command. Do not apply them to all later commands or an entire command batch.
- Run unrelated commands, including ordinary `git` commands, normally without
  toolchain setup. If a Git hook actually fails because Node tooling is missing
  or uses the wrong version, recovery may be used to retry that affected Git
  command; do not infer that other Git commands need it.

## Recovery rules

- Use the existing **fnm** installation to select Node and the existing
  **corepack** installation to run pnpm.
- Do not evaluate shell code or replay the user's profile. Use `fnm exec`
  instead of `fnm env`, `Invoke-Expression`, `iex`, or shell `eval`.
- Do not install Node, fnm, corepack, or global packages without approval.
- Run version selection from the intended project directory. Preserve the
  profile's `--version-file-strategy=recursive --resolve-engines=false` settings:
  use `.node-version` or `.nvmrc` from that directory or a parent, otherwise the
  fnm default. Do not automatically select a version from `engines.node`.

## Check the shell before recovering missing tools

Do not assume a missing command means the profile was skipped. Inspect the
current shell process before changing `PATH` or running the recovery commands.

{{ if .is_windows -}}
In PowerShell, inspect its complete command line:

```powershell
(Get-CimInstance Win32_Process -Filter "ProcessId = $PID").CommandLine
```

Continue with the fix below only if it contains `-NoProfile`. If it does not,
the profile was allowed to load; report the missing tool or profile failure
instead of masking it with recovery commands.
{{- else -}}
In bash or zsh, inspect the shell invocation:

```bash
ps -p $$ -o args=
```

Continue with the fix below only when the invocation confirms startup files
were skipped, such as `--noprofile` or a non-login `bash -c` without `BASH_ENV`.
Otherwise report the missing tool or profile failure instead of replaying
profile setup.
{{- end }}

For an already-available but wrong Node version, use the project version
selection below; profile bypass is not required.

## Run commands through fnm

Use `fnm exec` only for each affected Node-dependent command that needs recovery.
It selects an installed Node version and puts its installation directory on the
child process's `PATH`, including for scripts and subprocesses. It does not need
shell initialization.

{{ if .is_windows -}}
### PowerShell

Use the known Scoop shim path directly; no User PATH restoration is needed.
On Windows, pass the `.cmd` shim name for pnpm, corepack, npm, or npx to
`fnm exec`. Extensionless names can fail with `Can't spawn program`.

```powershell
& '{{ $winScoopShimsPath }}\fnm.exe' exec --version-file-strategy=recursive --resolve-engines=false node --version
& '{{ $winScoopShimsPath }}\fnm.exe' exec --version-file-strategy=recursive --resolve-engines=false pnpm.cmd --version
```

Replace `--version` with the required arguments, such as `run build`. Each
line works independently, including in a fresh shell process.

### Git Bash

```bash
"{{ $winScoopShimsPathBash }}/fnm.exe" exec --version-file-strategy=recursive --resolve-engines=false pnpm.cmd --version
```

### Optional: discover a direct path once

If repeated affected Node-dependent commands benefit from a concrete path,
discover the selected Node installation directory from the project directory:

```powershell
& '{{ $winScoopShimsPath }}\fnm.exe' exec --version-file-strategy=recursive --resolve-engines=false node -p "require('node:path').dirname(process.execPath)"
```

Reuse the **literal output** as `<node-dir>` in later calls, not a guessed
version directory or a temporary fnm multishell path:

```powershell
$env:Path = '<node-dir>;' + $env:Path; & '<node-dir>\pnpm.cmd' --version
```

Keep the `PATH` prefix in the **same invocation** as the real command, so pnpm
scripts can find Node too. Do not persist this PATH change.

Rediscover the path when changing projects, changing a version file or fnm
default, or after the installation is moved or removed. Prefer `fnm exec`
when version selection may change between commands.
{{- else -}}
### bash / zsh

```bash
# Locate the existing fnm installation if needed.
if ! command -v fnm >/dev/null; then
  export PATH="$(brew --prefix 2>/dev/null)/bin:$HOME/.local/share/fnm:$PATH"
fi

fnm exec --version-file-strategy=recursive --resolve-engines=false pnpm --version
```

Replace `--version` with the required arguments. If shell processes do not
persist, include the fnm lookup and the real command in the same invocation,
or reuse the discovered absolute fnm executable path.
{{- end }}

## If a tool or version is still missing

- If the fnm executable is missing at the expected location, stop and report it.
- If fnm reports that the selected Node version is not installed, report the
  version and ask before installing it. Do not use `--install-if-missing`.
- If pnpm's shim is missing, check corepack through the same fnm invocation:

```{{ if .is_windows }}powershell{{ else }}bash{{ end }}
{{ if .is_windows }}& '{{ $winScoopShimsPath }}\fnm.exe'{{ else }}fnm{{ end }} exec --version-file-strategy=recursive --resolve-engines=false {{ if .is_windows }}corepack.cmd{{ else }}corepack{{ end }} --version
```

- If corepack exists, replace `--version` above with `pnpm --version` or the
  required pnpm arguments. This does not require `corepack enable` or writing
  shims to the Node installation. Corepack honors the project's `packageManager`
  field and may download the specified pnpm version.
- If corepack is also missing, stop and report it. Do not assume every Node
  installation includes corepack.
- If the project requires another Node version without a version file, use
  `fnm exec --using <installed-version>` with the same options. Do not change
  the user's default or version files just to repair the agent's shell.
