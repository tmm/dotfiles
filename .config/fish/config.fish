# ==========================
# Aliases
# ==========================

alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
alias reload="exec $SHELL -l"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias frc="vim ~/.config/fish/config.fish"
alias trc="vim ~/.tmux.conf"
alias vrc="vim ~/.vim/vimrc"

# ==========================
# Abbreviations
# ==========================

abbr df "h git"
abbr g "git"
abbr home "cd ~"
abbr lsd "ls -d .*"
abbr t "tmux"
abbr v "vim"

# ==========================
# Variables
# ==========================

set -gx EDITOR vim
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git/*'"
set PIPENV_VENV_IN_PROJECT 1

# Avoid issues with `gpg` as installed via Homebrew
# https://stackoverflow.com/a/42265848/96656
set -x GPG_TTY (tty)

# Pure
# https://github.com/rafaelrinaldi/pure#configuration
set pure_color_primary white
set pure_color_success green

# ==========================
# Other
# ==========================

eval (direnv hook fish)
source /usr/local/opt/asdf/asdf.fish

