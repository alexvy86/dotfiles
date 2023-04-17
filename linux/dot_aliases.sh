#############################################################
# Personal aliases and functions
#############################################################

# Show open port information.
alias ports="ss --tcp --udp --all --processes"

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

# System management
alias sau='sudo apt update'
alias sauu='sudo apt upgrade'
alias sausau='sudo apt update; sudo apt upgrade'

# Process management
alias psd='ps -ww -fjp'
alias psall='ps -ww -efjH'

# Diff between current commit and common ancestor between it and the specified branch
function gdtool() {
    if [ "$#" -ne 1 ]; then
        cat << EndOfInstructions
Opens the git difftool comparing the current commit against the common ancestor
between it and the specified branch.

Usage: gdtool <branch-name | commit>
EndOfInstructions

        return 1;
    fi
    local COMMON_ANCESTOR=$(git merge-base HEAD $1);
    echo "Diff between HEAD and $COMMON_ANCESTOR";
    git difftool -d HEAD $COMMON_ANCESTOR;
}

#############################################################
# Fluid Framework
#############################################################

# Sync my fork of the FF repo with upstream.
# Needs a separate git fetch to be reflected locally.
alias grsff="gh repo sync alexvy86/FluidFramework"

# Common build commands
alias ffb='npm run build'
alias ffbc='npm run build:compile'
alias ffbf='npm run build:fast'

# Toggles the push URL for the "upstream" remote between blank and the fetch URL.
# This is useful in repos where the expected workflow is to always work in a
# personal fork and then do a Pull Request to upstream, to minimize the chance of
# mistakenly pushing a branch directly to upstream but still retain the ability to
# easily enable it if required for a specific scenario.
# Must run in a folder that is part of a git repository.
function toggle-ff-upstream-push() {
    local ACTUAL_URL=$(git remote get-url upstream)
    local CURRENT_PUSH_URL=$(git remote get-url --push upstream)
    local NEW_PUSH_URL="no_push"
    if [ $CURRENT_PUSH_URL != $ACTUAL_URL ]
    then
        NEW_PUSH_URL=$ACTUAL_URL;
    fi

    echo "Setting upstream push URL to '$NEW_PUSH_URL'";
    git remote set-url --push upstream $NEW_PUSH_URL;
}
