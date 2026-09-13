# shellcheck shell=bash

# Enable fnm auto-use when opening a folder with a .node-version or .nvmrc file.
# shellcheck disable=SC2312
if [[ -n "$(command -v fnm)" ]]; then
  # Need to set --resolve-engines=false so --version-file-strategy works correctly.
  # See https://github.com/Schniz/fnm/issues/1464#issuecomment-3365904352
  # In an agent terminal, skip --use-on-cd: it wraps `cd` to run `fnm use` on every
  # directory change, which needs FNM_MULTISHELL_PATH (set by this same eval) to still
  # be there when `cd` runs. Agent-driven shells don't reliably carry that state between
  # commands, so `cd` fails with "We can't find the necessary environment variables to
  # replace the Node version." AI_AGENT is set generically by both GitHub Copilot's and
  # Claude Code's agent terminals (and any other tool following the same convention).
  # shellcheck disable=SC2154 # AI_AGENT is set by the hosting tool, not this repo
  if [[ -n "${AI_AGENT}" ]]; then
    # shellcheck disable=SC2312
    eval "$(fnm env --version-file-strategy=recursive --resolve-engines=false)"
  else
    # shellcheck disable=SC2312
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)"
  fi
fi
