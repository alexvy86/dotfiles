# Case insensitive, partial-word, and substring completion.
# Doesn't handle case-insensitive match in the middle of a word.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

# Use Oh-My-Posh
eval "$(oh-my-posh init zsh --config "~/.config/alexvy86.omp.json")"
