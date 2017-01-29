PIP_REQUIRE_VIRTUALENV=true

export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin"
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"
export ZSH=$HOME/.oh-my-zsh
#export PATH="$HOME/anaconda/bin:$PATH"

plugins=(osx web-search wd pip gem zsh-nvm)
ZSH_CUSTOM=$HOME/.zsh
ZSH_THEME="tom"

source $ZSH_CUSTOM/aliases.sh
source $ZSH/oh-my-zsh.sh

export NVM_DIR="/Users/thomasmeagher/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# added by travis gem
[ -f /Users/thomasmeagher/.travis/travis.sh ] && source /Users/thomasmeagher/.travis/travis.sh
