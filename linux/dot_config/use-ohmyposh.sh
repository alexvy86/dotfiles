# shellcheck shell=bash

if [[ -n "${ZSH_VERSION}" ]]; then
	# Case insensitive, partial-word, and substring completion.
	# Doesn't handle case-insensitive match in the middle of a word.
	zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

	# Use Oh-My-Posh
	# shellcheck disable=SC2312
	eval "$(oh-my-posh init zsh --config "${HOME}/.config/alexvy86.omp.json")"
elif [[ -n "${BASH_VERSION}" ]]; then
	# Use Oh-My-Posh
	# shellcheck disable=SC2312
	eval "$(oh-my-posh init bash --config "${HOME}/.config/alexvy86.omp.json")"
fi
