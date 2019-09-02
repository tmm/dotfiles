
local PROMPT_PREFIX=">"
local CURRENT_DIR='${PWD/#$HOME/~}'
local GIT_INFO='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

machine_name() { echo $HOST }

user_name() {
  if [[ "$USER" == "root" ]]; then
    echo "%{$bg[red]%}%{$fg[black]%}%n%{$reset_color%}";
  else
    echo "%{$fg[magenta]%}%n"
  fi
}

venv() {
  # Check if the current directory running via Virtualenv
  if [[ "$VIRTUAL_ENV" ]]; then
    echo "($VIRTUAL_ENV:t) "
  fi
}

# Prompt format:
#
# # USER at MACHINE in DIRECTORY on BRANCH STATE
# > COMMAND
#
# For example:
#
# # tom at mac.local in ~ on master*
# >
PROMPT="
%{$terminfo[bold]$fg[white]%}#%{$reset_color%} \
$(user_name) \
%{$fg[white]%}at \
%{$fg[green]%}$(machine_name) \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}${CURRENT_DIR}%{$reset_color%}\
${GIT_INFO}
$(venv)\
%{$terminfo[bold]$fg[white]%}${PROMPT_PREFIX} %{$reset_color%}"
