# shellcheck shell=bash

# Enable fnm auto-use when opening a folder with a .node-version or .nvmrc file.
# shellcheck disable=SC2312
if [[ -n "$(command -v fnm)" ]]; then
  # shellcheck disable=SC2312
  eval "$(fnm env --use-on-cd)"
fi
