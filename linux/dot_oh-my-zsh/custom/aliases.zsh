# Show open port information.
alias ports="ss --tcp --udp --all --processes"

# Sync my fork of the FF repo with upstream.
# Needs a separate git fetch to be reflected locally.
alias grsff="gh repo sync alexvy86/FluidFramework"

# List all (A) files and directories recursively (R), in human-readable (h) format,
# with indicator suffix (F).
alias lar="ls -lARFh"

# Display the size of each file/folder at depth 1 in current location in human-readable form.
alias dud="du -d 1 -h"
# Display the total size of all files/folders in current location in human-readable form.
alias dus="du -sh"

# Print PATH entries, one per line
alias path='echo -e ${PATH//:/\\n}'

# Date/time shortcuts
alias nowtime='date +"%T"'
alias nowdate='date +"%Y-%m-%d"'
