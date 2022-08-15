# # vim:ft=zsh ts=2 sw=2 sts=2

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}(dirty)"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PREV_CMD_EXEC_TIME=""
function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    PREV_CMD_EXEC_TIME=$(($now-$timer))
    unset timer
  fi
}

function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function prompt_time() {
  echo "[%{$FG[214]%}%*%{$reset_color%}]"
}

function prompt_pwd() {
  echo "%{$fg_bold[green]%}%/%{$reset_color%}"
}

function prompt_user() {
  echo "%{$FG[154]%}%n%{$reset_color%}@%{$fg[magenta]%}%m%{$reset_color%}"
}

function prompt_cmdnumber() {
  echo -n "%{$fg_bold[cyan]%}%!%{$reset_color%}"
}

function prompt_execution_time() {
  if [ $PREV_CMD_EXEC_TIME ]; then
    echo -n "%{$fg_bold[cyan]%}%" \($PREV_CMD_EXEC_TIME ms\) "%{$reset_color%}"
  fi
}

PROMPT='$(prompt_time) $(prompt_user) $(prompt_pwd) $(git_prompt_info) $(prompt_execution_time)
$(prompt_cmdnumber) $ '

# RPROMPT=""
