# shellcheck shell=bash

# Use fzf completion; then fall back to zsh's.
# ⚠️ NOTE: This setting can NOT be changed at runtime and requires that you have installed Fzf's shell extensions.
#zstyle ':autocomplete:*' fzf-completion yes

# Start each new command line in live history search mode.
zstyle ':autocomplete:*' default-context history-incremental-search-backward

# Wait until this many characters have been typed, before showing completions.
zstyle ':autocomplete:*' min-input 1  # int

# If there are fewer than this many lines below the prompt, move the prompt up
# to make room for showing this many lines of completions (approximately).
# Applies to autocompletion, history search, and history menu.
zstyle ':autocomplete:*' list-lines 8  # int

# In completion mode, skip using the common prefix first as a result if there are several possible matches.
# This inserts the first match instead.
zstyle ':autocomplete:*' insert-unambiguous no

# Source the plugin. The folder is created through .chezmoiexternal.toml
# so the file doesn't exist for shellcheck to verify.
# shellcheck disable=SC1090
source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Make Tab go straight to the menu and cycle there
#bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
#bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
