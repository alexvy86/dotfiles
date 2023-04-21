###############################
# History
###############################

setopt append_history         # parallel zsh sessions append to the file rather than replacing it
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_find_no_dups      # do not display duplicates in history results, even if they're not contiguous
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # do not enter command lines into the history list if they are duplicates of the previous event
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history          # share command history data

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
