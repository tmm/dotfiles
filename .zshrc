export ZSH=$HOME/.oh-my-zsh

plugins=(git wd zsh-syntax-highlighting)

ZSH_CUSTOM=$HOME/.zsh
ZSH_THEME="tom"

source $ZSH_CUSTOM/aliases.sh
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH_CUSTOM/zsh-interactive-cd.plugin.zsh

eval $(thefuck --alias merp)

source ~/.zprofile
source ~/.zprofile-kit
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
