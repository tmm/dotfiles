# ==========================
# Aliases
# ==========================

alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
alias reload="exec $SHELL -l"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# ==========================
# Abbreviations
# ==========================

abbr g "git"
abbr home "cd ~"
abbr lsd "ls -d .*"

# ==========================
# Variables
# ==========================

set -x EDITOR vim
set PIPENV_VENV_IN_PROJECT 1
set NVM_DIR $HOME/.nvm

# Avoid issues with `gpg` as installed via Homebrew
# https://stackoverflow.com/a/42265848/96656
set -x GPG_TTY (tty)

# Pure
# https://github.com/rafaelrinaldi/pure#configuration
set pure_color_primary white
set pure_color_success green
