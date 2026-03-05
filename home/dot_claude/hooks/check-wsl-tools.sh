#!/usr/bin/env bash
# If running in WSL and Windows-space executables for key tools are detected,
# display a warning message to the user inside the Claude session.

is_wsl() {
  [ -n "$WSL_DISTRO_NAME" ] || grep -qi microsoft /proc/version 2>/dev/null
}

is_wsl || exit 0

tools=(gh az python)
warnings=()

for cmd in "${tools[@]}"; do
  path=$(which "$cmd" 2>/dev/null)
  if [ -n "$path" ] && [[ "$path" == /mnt/* ]]; then
    warnings+=("  - $cmd → $path")
  fi
done

if [ ${#warnings[@]} -gt 0 ]; then
  msg="WARNING: The following tools resolve to Windows-space executables.
This may cause unexpected behavior (path separators, line endings, credential stores, character encoding pages, etc.).
$(printf '%s\n' "${warnings[@]}")"
  jq -n --arg msg "$msg" '{"systemMessage": $msg}'
  exit 2
fi
