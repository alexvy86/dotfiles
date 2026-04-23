# shellcheck shell=bash

# Enable fnm auto-use when opening a folder with a .node-version or .nvmrc file.
# shellcheck disable=SC2312
if [[ -n "$(command -v fnm)" ]]; then
  # Need to set --resolve-engines=false so --version-file-strategy works correctly.
  # See https://github.com/Schniz/fnm/issues/1464#issuecomment-3365904352
  # shellcheck disable=SC2312
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)"
fi
