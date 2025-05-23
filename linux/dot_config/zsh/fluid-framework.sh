#############################################################
# Fluid Framework
#############################################################

# Sync my fork of the FF repo with upstream.
# Note that 'gh repo sync' does not sync tags, so we need to do that manually.
alias grsff="git fetch upstream && git push --tags origin && gh repo sync alexvy86/FluidFramework && git fetch origin"

# Common build commands
alias b='npm run build'
alias bc='npm run build:compile'
alias bf='npm run build:fast'

# Create a new Github Codespaces
alias new-codespace='gh codespace create --repo microsoft/FluidFramework --branch main --machine largePremiumLinux'

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

# Pushes the current branch to a branch named test/alejandrovi/<current-branch-name>
# in the 'upstream' remote.
function push-test-branch() {
    local CURRENT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    git push upstream $CURRENT_BRANCH_NAME\:test/alejandrovi/$CURRENT_BRANCH_NAME;
}
