# ==========================
# Aliases
# ==========================

alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.dotfiles"
alias reload="exec $SHELL -l"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# ==========================
# Abbreviations
# ==========================

abbr g "git"
abbr ga "git add"
abbr gaa "git add -A"
abbr gau "git add --update"
abbr gb "git branch"
abbr gc "git commit -m"
abbr gca "git add -A && git commit -avm"
abbr gam "git commit --amend --reuse-message=HEAD"
abbr gch "git checkout"
abbr gchm "git checkout master"
abbr gd "git diff"
abbr gp "git push"
abbr gpl "git pull"
abbr gs "git status"

abbr home "cd ~"
abbr lsd "ls -d .*"

# ==========================
# Variables
# ==========================

set -x EDITOR vim
set PIPENV_VENV_IN_PROJECT 1
set NVM_DIR $HOME/.nvm

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
set -x GPG_TTY (tty)
