local current_dir='${PWD/#$HOME/~}'

ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg_bold[green]%}✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg_bold[yellow]%}✗ "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

PROMPT_PREFIX="$"

PROMPT='%{$fg_bold[green]%}${PROMPT_PREFIX}%{$fg_bold[green]%}%p $(git_prompt_info)% %{$reset_color%}'
RPROMPT="%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}"
