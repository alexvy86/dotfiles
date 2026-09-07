# shellcheck shell=bash

# In an agent terminal, skip Oh-My-Posh entirely: the agent parses command output via
# OSC 633 markers and never renders the screen, so a themed prompt buys nothing, while
# its git-status segment can take ~20s to render in large monorepos.
# AI_AGENT is set generically by both GitHub Copilot's and Claude Code's VS Code agent
# terminals (and any other tool following the same convention).
# See: docs/notes/vscode-agent-output-capture-vs-oh-my-posh-transient-prompt.md
# shellcheck disable=SC2154 # AI_AGENT is set by the hosting tool, not this repo
_use_ohmyposh_is_agent=0
[[ -n "${AI_AGENT}" ]] && _use_ohmyposh_is_agent=1

if [[ -n "${ZSH_VERSION}" ]]; then
	# Case insensitive, partial-word, and substring completion.
	# Doesn't handle case-insensitive match in the middle of a word.
	zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

	if [[ "${_use_ohmyposh_is_agent}" -eq 0 ]]; then
		# Use Oh-My-Posh
		# shellcheck disable=SC2312
		eval "$(oh-my-posh init zsh --config "${HOME}/.config/alexvy86.omp.json")"
	fi
elif [[ -n "${BASH_VERSION}" ]]; then
	if [[ "${_use_ohmyposh_is_agent}" -eq 0 ]]; then
		# Use Oh-My-Posh
		# shellcheck disable=SC2312
		eval "$(oh-my-posh init bash --config "${HOME}/.config/alexvy86.omp.json")"
	fi
fi

unset _use_ohmyposh_is_agent
