#!/usr/bin/env bash
# PreToolUse guard: block commands that look like they install software,
# packages, or modules, so they are never run without the user's explicit
# approval. Wired for the Bash and PowerShell tools in ~/.claude/settings.json.
#
# Exit 2 tells Claude Code to BLOCK the tool call and shows stderr to the model.
# Bias: a false block is cheap (just ask the user); a missed system-wide install
# is the exact failure this guard exists to prevent, so the patterns are broad.
#
# pip is special-cased: installing into a project virtualenv is a normal local
# dependency install and is allowed, but ONLY when the command explicitly names
# the venv (e.g. `.venv/bin/pip install`, `.venv/bin/python -m pip install`, or
# `source .venv/bin/activate && pip install`). The hook runs in a separate
# process from the persistent shell, so it can't see an already-active
# VIRTUAL_ENV; a bare `pip install` is therefore treated as system-wide and
# blocked. Convention: always invoke the venv's pip explicitly (see CLAUDE.md).

input=$(cat)

# Prefer the parsed command; fall back to the raw payload if jq isn't available
# (the raw JSON still contains the command text, so detection still works).
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "${input}" | jq -r '.tool_input.command // empty' 2>/dev/null)
  [[ -z "${cmd}" ]] && cmd=${input}
else
  cmd=${input}
fi

block() {
  {
    echo "BLOCKED: $1"
    echo "Standing rule: do NOT install anything system-wide without the user's explicit approval."
    echo "Stop and ask the user whether and how to install it (see memory: no-install-without-approval)."
  } >&2
  exit 2
}

# --- pip: allow project-venv installs, block anything system-wide ------------
# A pip install in any form: `pip install`, `pip3 install`, `python -m pip install`.
pip_install_re='((^|[^[:alnum:]_])pip[0-9.]*[[:space:]]+install)|((^|[^[:alnum:]_])python[0-9.]*[[:space:]]+-m[[:space:]]+pip[[:space:]]+install)'
if printf '%s' "${cmd}" | grep -qiE "${pip_install_re}"; then
  # System-wide no matter what else is on the line: elevated, user-site, forced
  # into an externally-managed system Python, or an explicit system path.
  pip_hardblock_re='(^|[^[:alnum:]_])sudo[[:space:]]|--user([[:space:]]|=|$)|--break-system-packages|(^|[^[:alnum:]_])/(usr|opt|bin|sbin)[^[:space:]]*/(pip|python)'
  if printf '%s' "${cmd}" | grep -qiE "${pip_hardblock_re}"; then
    block "system-wide pip install (sudo, --user, --break-system-packages, or a system path)."
  fi
  # Explicit project-venv target (path through a venv, or activation in the same
  # command) => normal local dependency install, allowed.
  venv_ok_re='([^[:space:]]*venv[^[:space:]]*[/\\](bin|Scripts)[/\\](pip|python))|((^|[^[:alnum:]_])activate([^[:alnum:]_]|$))'
  if printf '%s' "${cmd}" | grep -qiE "${venv_ok_re}"; then
    exit 0
  fi
  block "pip install not clearly targeting a project virtualenv; invoke the venv's pip explicitly (e.g. .venv/bin/pip install)."
fi

# --- everything else ---------------------------------------------------------
# A package/module manager followed by an install-style subcommand.
# Boundary is "start, or any non-word char" so a manager works whether it's the
# first token (preceded by a JSON quote in raw mode) or mid-command.
mgr_re='(^|[^[:alnum:]_])(sudo[[:space:]]+)?(scoop|winget|choco|cinst|brew|apt|apt-get|dnf|yum|pacman|zypper|apk|snap|flatpak|pipx|gem|cargo|nix-env|go)[[:space:]]+(install|add|-S|-Sy)([[:space:]]|$)'
# PowerShell module/package installation.
ps_re='Install-(Module|Package|Script)|Save-Module'
# Global JS package installs.
js_re='(npm[[:space:]]+(install|i|add)[[:space:]].*(-g|--global))|(pnpm[[:space:]]+(add|install|i)[[:space:]].*(-g|--global))|(yarn[[:space:]]+global[[:space:]]+add)'
# .NET global tools.
dotnet_re='dotnet[[:space:]]+tool[[:space:]]+install'

if printf '%s' "${cmd}" | grep -qiE "${mgr_re}" \
  || printf '%s' "${cmd}" | grep -qiE "${ps_re}" \
  || printf '%s' "${cmd}" | grep -qiE "${js_re}" \
  || printf '%s' "${cmd}" | grep -qiE "${dotnet_re}"; then
  block "this looks like a command that installs software/packages/modules system-wide."
fi

exit 0
