export ZSH=$HOME/.oh-my-zsh

plugins=(git)
ZSH_CUSTOM=$HOME/.zsh
ZSH_THEME="tom"

source $ZSH_CUSTOM/aliases.sh
source $ZSH/oh-my-zsh.sh

export PATH="/Applications/Postgres.app/Contents/Versions/9.6/bin:$PATH"

export NVM_DIR="/Users/tom/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
