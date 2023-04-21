#############################################################
# Misc
#############################################################

# Use ssh-ident
alias ssh="~/.local/bin/ssh-ident"

# Show open port information.
alias ports="ss --tcp --udp --all --processes"

# Print PATH entries, one per line
alias path='echo -e ${PATH//:/\\n}'

# Date/time shortcuts
alias nowtime='date +"%T"'
alias nowdate='date +"%Y-%m-%d"'

# Grep shortcuts
alias egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

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
