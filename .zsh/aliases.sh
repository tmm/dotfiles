alias home="git --work-tree=$HOME --git-dir=$HOME/.dotfiles/"

alias tfm="cd ~"
alias lsd="ls -d .*"
alias rc="$EDITOR ~/.zshrc"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
