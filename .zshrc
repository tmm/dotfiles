export ZSH=$HOME/.oh-my-zsh

plugins=(git)

ZSH_CUSTOM=$HOME/.zsh
ZSH_THEME="tom"

source $ZSH_CUSTOM/aliases.sh
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH_CUSTOM/zsh-interactive-cd.plugin.zsh

eval $(thefuck --alias merp)
