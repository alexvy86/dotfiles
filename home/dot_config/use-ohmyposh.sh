# shellcheck shell=bash

if [[ -n "${ZSH_VERSION}" ]]; then
	# Case insensitive, partial-word, and substring completion.
	# Doesn't handle case-insensitive match in the middle of a word.
	zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

	# Use Oh-My-Posh
	# When in a Copilot agent terminal (COPILOT_AGENT=1), use a config without the transient prompt
	# to prevent shell integration marker corruption. See: docs/notes/vscode-agent-output-capture-vs-oh-my-posh-transient-prompt.md
	# shellcheck disable=SC2154 # COPILOT_AGENT is set by VS Code when running in a Copilot agent terminal
	if [[ "${COPILOT_AGENT}" == "1" ]]; then
		# shellcheck disable=SC2312
		eval "$(oh-my-posh init zsh --config "${HOME}/.config/alexvy86-agent.omp.json")"
	else
		# shellcheck disable=SC2312
		eval "$(oh-my-posh init zsh --config "${HOME}/.config/alexvy86.omp.json")"
	fi
elif [[ -n "${BASH_VERSION}" ]]; then
	# Use Oh-My-Posh
	# When in a Copilot agent terminal (COPILOT_AGENT=1), use a config without the transient prompt
	if [[ "${COPILOT_AGENT}" == "1" ]]; then
		# shellcheck disable=SC2312
		eval "$(oh-my-posh init bash --config "${HOME}/.config/alexvy86-agent.omp.json")"
	else
		# shellcheck disable=SC2312
		eval "$(oh-my-posh init bash --config "${HOME}/.config/alexvy86.omp.json")"
	fi
fi
