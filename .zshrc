export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin"

PIP_REQUIRE_VIRTUALENV=true

export ZSH=$HOME/.oh-my-zsh
plugins=(osx web-search wd brew gem)
ZSH_CUSTOM=$HOME/.zsh_custom
ZSH_THEME="tom"

source .aliases
source $ZSH/oh-my-zsh.sh