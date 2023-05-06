#############################################################
# Directories and navigation
#############################################################

# Options controlling behavior of cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# Print directory stack
function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}

# Changing directory
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'
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
