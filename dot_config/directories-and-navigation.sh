# shellcheck shell=bash

#############################################################
# Directories and navigation
#############################################################

# Options controlling behavior of cd
if [[ -n "${ZSH_VERSION}" ]]; then
  setopt auto_cd
  setopt auto_pushd
  setopt pushd_ignore_dups
  setopt pushdminus
elif [[ -n "${BASH_VERSION}" ]]; then
  shopt -s autocd

  # In Bash, auto_pushd doesn't exist so we have to emulate it by overriding cd
  # to call pushd after changing directory.
  cd() {
      if [[ $# -eq 0 ]]; then
          # No arguments, go to home directory
          builtin cd && pushd . > /dev/null
      else
          # Change directory and push to stack
          builtin cd "$@" && pushd . > /dev/null
      fi
  }

  # No bash equivalents to push_ignore_dups or pushdminus.
  # I don't really use them so it's fine.
fi

# Print directory stack
function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    # shellcheck disable=SC2312
    dirs -v | head -n 10
  fi
}

# Changing directory
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Default mkdir with intermediate directory creation
alias md='mkdir -p'

# Colorize ls output
alias ls="ls --color=tty"
# List almost all (A) files and directories, in human-readable (h) format, with indicator suffix (F), following symlinks (H).
# Also recursive (R) version.
alias la="ls -lAFHh"
alias lar="ls -lARFHh"

# Eza: better file listing tool
alias eza="eza --long --almost-all --links --header --follow-symlinks --total-size --time-style long-iso"
alias ezat="eza --tree"
