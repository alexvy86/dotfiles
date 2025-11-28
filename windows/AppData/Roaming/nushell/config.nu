$env.config.buffer_editor = "code"

$env.config.completions.algorithm = "fuzzy"

$env.config.datetime_format.normal = "%Y-%m-%d %H:%M:%S %Z"

#----------------------------------------------------------
# Aliases
#----------------------------------------------------------

alias g = git

alias ga = git add
alias gaa = git add --all

alias gb = git branch
alias gba = git branch --all
alias gbd = git branch --delete
alias gbD = git branch --delete --force
alias gbv = git branch -vv

alias gc! = git commit --verbose --amend
alias gcn! = git commit --verbose --no-edit --amend
alias gcb = git checkout -b
alias gcf = git config --list
alias gco = git checkout
alias gcp = git cherry-pick
alias gcpa = git cherry-pick --abort
alias gcpc = git cherry-pick --continue

alias gf = git fetch
alias gfo = git fetch origin
alias gfu = git fetch upstream

alias gl = git pull

alias gm = git merge

alias gp = git push

alias grb = git rebase
alias grba = git rebase --abort
alias grbc = git rebase --continue
alias grbi = git rebase --interactive
alias grbo = git rebase --onto

alias gsta = git stash push
alias gstd = git stash drop
alias gstl = git stash list
alias gstp = git stash pop

alias gwt = git worktree
alias gwta = git worktree add
alias gwtls = git worktree list
alias gwtmv = git worktree move
alias gwtrm = git worktree remove

alias eza = eza --long --almost-all --links --header --follow-symlinks --total-size --time-style long-iso
alias ezat = eza --long --almost-all --links --header --follow-symlinks --total-size --time-style long-iso --tree

alias wlua = winget list --upgrade-available

alias cuaf = chezmoi update --apply=false



# Auto-completions for Winget
source ~/AppData/Roaming/nushell/nu_scripts/custom-completions/winget/winget-completions.nu

#----------------------------------------------------------
# FNM
#----------------------------------------------------------
# Assumes it was installed earlier.
# Discussion in https://github.com/Schniz/fnm/issues/463
# PR in https://github.com/Schniz/fnm/pull/801
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing --silent-if-unchanged}
        }
    )
}

#----------------------------------------------------------
# Prompt
#----------------------------------------------------------
oh-my-posh init nu --config "~/.config/alexvy86.omp.json"
