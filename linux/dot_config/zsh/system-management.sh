#############################################################
# System management
#############################################################

# Display the size of each file/folder at depth 1 in current location in human-readable form.
alias dud="du -d 1 -h"
# Display the total size of all files/folders in current location in human-readable form.
alias dus="du -sh"

# Process management
alias psd='ps -ww -fjp'
alias psall='ps -ww -efjH'

# Update/upgrade shortcuts
alias sau='sudo apt update'
alias sauu='sudo apt upgrade'
alias sausau='sudo apt update; sudo apt upgrade'
