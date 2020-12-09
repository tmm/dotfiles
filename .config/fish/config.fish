# ==========================
# Variables
# ==========================

set -gx EDITOR nvim

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CONFIG_HOME $HOME/.config

# Avoid issues with `gpg` as installed via Homebrew
# https://stackoverflow.com/a/42265848/96656
set -x GPG_TTY (tty)

# Turn off `brew` analytics
# https://docs.brew.sh/Analytics#opting-out
set HOMEBREW_NO_ANALYTICS 1

# Pure
# https://github.com/rafaelrinaldi/pure#configuration
set pure_color_primary white
set pure_color_success green

# Add `pg_config` to path
# https://fishshell.com/docs/current/tutorial.html?highlight=fish_user_path#path
set PG_CONFIG /Applications/Postgres.app/Contents/Versions/latest/bin
# Only add `PG_CONFIG` to `fish_user_paths` once
# https://github.com/fish-shell/fish-shell/issues/5834#issuecomment-485070486
contains $PG_CONFIG $fish_user_paths; or set -Ua fish_user_paths $PG_CONFIG $fish_user_paths

# ==========================
# Aliases
# ==========================

alias cat=bat
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias ls=exa
alias reload="exec $SHELL -l"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias vim=nvim

alias frc="nvim $XDG_CONFIG_HOME/fish/config.fish"
alias trc="nvim $XDG_CONFIG_HOME/tmux/tmux.conf"
alias vrc="nvim $XDG_CONFIG_HOME/nvim/init.vim"

# ==========================
# Abbreviations
# ==========================

abbr d "docker"
abbr dc "docker-compose"
abbr df "h git"
abbr g "git"
abbr home "cd ~"
abbr lsd "exa -d .*"
abbr t "tmux"
abbr tf "terraform"
abbr v "nvim"
abbr x "devx"

abbr dsr "docker stop (docker ps -a -q) && docker rm (docker ps -a -q)" # Stops and removes all running containers
abbr dex "docker exec -it"
abbr dcu "docker-compose up -d"
abbr dcub "docker-compose up -d --build"
abbr dra "docker rmi (docker images -q) --force"
abbr dl "docker logs -f"

# ==========================
# Other
# ==========================

eval (direnv hook fish)
source /usr/local/opt/asdf/asdf.fish
