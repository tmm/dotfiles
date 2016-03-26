alias home='git --work-tree=$HOME --git-dir=$HOME/.dotfiles/'
alias tfm="cd ~"
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

export ZSH=/Users/thomasmeagher/.oh-my-zsh
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin"

ZSH_THEME="dracula"
plugins=(git)

source $ZSH/oh-my-zsh.sh
