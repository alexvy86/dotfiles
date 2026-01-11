# shellcheck shell=bash

# Some stuff here is taken from OhMyZsh's git plugin (and git core lib).
# Extracted only the shell-agnostic pieces I care about so I can share them between bash and zsh.

# Aliases

alias g='git'

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbv='git branch -vv'

alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gf='git fetch'
alias gfo='git fetch origin'
alias gfu='git fetch upstream'

alias gl='git pull'

alias gm='git merge'

alias gp='git push'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbo='git rebase --onto'

alias gsta='git stash push'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'

alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# Functions

# Diff between current commit and common ancestor between it and the specified branch
function gdtool() {
    if [[ "$#" -ne 1 ]]; then
        cat << EndOfInstructions
Opens the git difftool comparing the current commit against the common ancestor
between it and the specified branch.

Usage: gdtool <branch-name | commit>
EndOfInstructions

        return 1;
    fi
    local COMMON_ANCESTOR
    COMMON_ANCESTOR=$(git merge-base HEAD "$1");
    echo "Diff between HEAD and ${COMMON_ANCESTOR}";
    git difftool -d HEAD "${COMMON_ANCESTOR}";
}
