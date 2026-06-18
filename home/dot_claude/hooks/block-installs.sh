#!/usr/bin/env bash
# PreToolUse guard: block commands that look like they install software,
# packages, or modules, so they are never run without the user's explicit
# approval. Wired for the Bash and PowerShell tools in ~/.claude/settings.json.
#
# Exit 2 tells Claude Code to BLOCK the tool call and shows stderr to the model.
# Bias: a false block is cheap (just ask the user); a missed install is the
# exact failure this guard exists to prevent, so the patterns are deliberately broad.

input=$(cat)

# Prefer the parsed command; fall back to the raw payload if jq isn't available
# (the raw JSON still contains the command text, so detection still works).
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "${input}" | jq -r '.tool_input.command // empty' 2>/dev/null)
  [[ -z "${cmd}" ]] && cmd=${input}
else
  cmd=${input}
fi

# A package/module manager followed by an install-style subcommand.
# Boundary is "start, or any non-word char" so a manager works whether it's the
# first token (preceded by a JSON quote in raw mode) or mid-command.
mgr_re='(^|[^[:alnum:]_])(sudo[[:space:]]+)?(scoop|winget|choco|cinst|brew|apt|apt-get|dnf|yum|pacman|zypper|apk|snap|flatpak|pipx|pip3?|gem|cargo|nix-env|go)[[:space:]]+(install|add|-S|-Sy)([[:space:]]|$)'
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
  {
    echo "BLOCKED: this looks like a command that installs software/packages/modules."
    echo "Standing rule: do NOT install anything without the user's explicit approval."
    echo "Stop and ask the user whether and how to install it (see memory: no-install-without-approval)."
  } >&2
  exit 2
fi

exit 0
