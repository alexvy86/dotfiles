# shellcheck shell=bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
# Since this won't run for login shells, there's a bit of a dance between .profile and .bashrc

# if not coming from .bash_profile and .bash_profile exists
if [[ -z "${COMING_FROM_BASH_PROFILE}" && -f "${HOME}/.bash_profile" ]]; then
  export COMING_FROM_BASHRC=true
  # shellcheck source=../dot_profile
  source "${HOME}/.bash_profile"
  unset COMING_FROM_BASHRC
fi

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

###############################
# Base configuration
###############################

# shellcheck source=../dot_config/directories-and-navigation.sh
source ~/.config/directories-and-navigation.sh;
# shellcheck source=../dot_config/fluid-framework.sh
source ~/.config/fluid-framework.sh;
# shellcheck source=../dot_config/git.sh
source ~/.config/git.sh;
# shellcheck source=../dot_config/history.sh
source ~/.config/history.sh;
# shellcheck source=../dot_config/system-management.sh
source ~/.config/system-management.sh;
# shellcheck source=../dot_config/misc.sh.tmpl
source ~/.config/misc.sh;

###############################
# Key bindings
###############################

# Ctrl-backspace, delete word to the left of the cursor (may not work in all terminals)
bind '"\C-h": backward-kill-word'
# Ctrl + left/right arrows, move forward or backwards in the line
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

###############################
# Tools & applications
###############################

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

# Use fzf
eval "$(fzf --bash)"

# Enable the navi widget
# shellcheck disable=SC2312
if [[ -n "$(command -v navi)" ]]; then
  # shellcheck disable=SC2312
  eval "$(navi widget bash)"
fi

###############################
# Prompt
###############################

# Oh-My-Zsh is zsh-only. Oh-My-Posh works with bash.
# shellcheck source=../dot_config/use-ohmyposh.sh
source ~/.config/use-ohmyposh.sh
