# shellcheck shell=bash

# Load .profile
if [[ -r "${HOME}/.profile" ]]; then
  # shellcheck source=./dot_profile
  source "${HOME}/.profile"
fi

###############################
# Base configuration
###############################

# Prep so completion system (and potentially other plugins) can init correctly.
# Copied from OhMyZsh's main script.
autoload -U compaudit compinit zrecompile
# Need to actually call compinit so RaspiOS doesn't complain about compdef not being defined when sourcing zsh's git plugin.
compinit

# TODO: keep playing with fzf-tab, decide if we want it
# From fzf-tab's README:
# > fzf-tab needs to be loaded after compinit, but before plugins which will wrap widgets,
# > such as zsh-autosuggestions or fast-syntax-highlighting".
# > Completions should be configured before compinit, as stated in the zsh-completions manual installation guide.
# source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh

# shellcheck source=./dot_config/directories-and-navigation.sh
source ~/.config/directories-and-navigation.sh;
# shellcheck source=./dot_config/fluid-framework.sh
source ~/.config/fluid-framework.sh;
# shellcheck source=./dot_config/git.sh
source ~/.config/git.sh;
# shellcheck source=./dot_config/history.sh
source ~/.config/history.sh;
# shellcheck source=./dot_config/system-management.sh
source ~/.config/system-management.sh;
# shellcheck source=./dot_config/misc.sh.tmpl
source ~/.config/misc.sh;

###############################
# Key bindings
###############################

# Ctrl-backspace, delete word to the left of the cursor
bindkey "^H" backward-kill-word
# Ctrl + left/right arrows, move forward or backwards in the line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

###############################
# Tools & applications
###############################

# Use zsh-autocomplete
#source ~/.config/zsh/zsh-autocomplete.sh

# Enable fnm auto-use when opening a folder with a .node-version or .nvmrc file.
# shellcheck disable=SC2312
if [[ -n "$(command -v fnm)" ]]; then
  # Need to set --resolve-engines=false so --version-file-strategy works correctly.
  # See https://github.com/Schniz/fnm/issues/1464#issuecomment-3365904352
  # shellcheck disable=SC2312
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false)";
fi

# Use fzf
source <(fzf --zsh)

# Enable the navi widget
# shellcheck disable=SC2312
if [[ -n "$(command -v navi)" ]]; then
  # shellcheck disable=SC2312
  eval "$(navi widget zsh)";
fi

###############################
# Prompt
###############################

# Use Oh-My-Posh
# shellcheck source=./dot_config/use-ohmyposh.sh
source ~/.config/use-ohmyposh.sh

# Use Oh-My-Zsh
#source ~/.config/use-ohmyzsh.sh
