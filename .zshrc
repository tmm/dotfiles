export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

plugins=(
  django
  history
  pyenv
  sudo
  wd
  web-search
  yarn
  zsh-syntax-highlighting
)

ZSH_CUSTOM=$HOME/.zsh
ZSH_THEME="tom"

source $ZSH_CUSTOM/aliases.sh
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH_CUSTOM/zsh-interactive-cd.plugin.zsh

source ~/.zprofile
source ~/.zprofile-patreon
source ~/.zprofile-kit
source ~/.zprofile-budget
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "/usr/local/opt/nvm/nvm.sh"

eval "$(jenv init -)" # Load jenv
eval $(thefuck --alias merp)
