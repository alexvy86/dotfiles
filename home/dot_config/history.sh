# shellcheck shell=bash

###############################
# History
###############################

if [[ -n "${ZSH_VERSION}" ]]; then
	setopt append_history         # parallel zsh sessions append to the file rather than replacing it
	setopt extended_history       # record timestamp of command in HISTFILE
	setopt hist_find_no_dups      # do not display duplicates in history results, even if they're not contiguous
	setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
	setopt hist_ignore_dups       # do not enter command lines into the history list if they are duplicates of the previous event
	setopt hist_ignore_space      # ignore commands that start with space
	setopt hist_verify            # show command with history expansion to user before running it
	#setopt share_history          # share command history data

	# Display timestamps for history commands in 'yyyy-MM-dd HH:MM:SS' format
	alias history='history -t "%F %T"'

	[[ -z "${HISTFILE}" ]] && HISTFILE="${HOME}/.zsh_history"
	[[ "${HISTSIZE}" -lt 1000 ]] && HISTSIZE=1000
	[[ "${SAVEHIST}" -lt 10000 ]] && SAVEHIST=10000

elif [[ -n "${BASH_VERSION}" ]]; then
	# don't put duplicate lines or lines starting with space in the history.
	# See bash(1) for more options
	export HISTCONTROL=ignorespace:ignoredups
	# Display timestamps for history commands in 'yyyy-MM-dd HH:MM:SS' format
	export HISTTIMEFORMAT="[%F %T] "

	# append to the history file, don't overwrite it
	shopt -s histappend

	[[ "${HISTSIZE}" -lt 1000 ]] && HISTSIZE=1000
	[[ "${HISTFILESIZE}" -lt 10000 ]] && HISTFILESIZE=10000
fi
