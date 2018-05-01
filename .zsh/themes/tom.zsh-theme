local current_dir='${PWD/#$HOME/~}'

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[cyan]%}]"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

PROMPT_PREFIX="=>"

PROMPT='$(git_prompt_info)% %{$fg[green]%}${PROMPT_PREFIX}%{$fg[green]%}%p '
RPROMPT="%{$reset_color%}%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}"
