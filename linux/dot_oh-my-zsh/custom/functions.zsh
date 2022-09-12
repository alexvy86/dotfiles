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
