local current_dir='${PWD/#$HOME/~}'

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$fg_bold[cyan]%}]"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

PROMPT_PREFIX="=>"

PROMPT='$(git_prompt_info)% %{$fg_bold[green]%}${PROMPT_PREFIX}%{$fg_bold[green]%}%p '
RPROMPT="%{$reset_color%}%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}"
