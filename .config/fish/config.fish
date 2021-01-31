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
set HOMEBREW_NO_EMOJI 1

# Turn off `Next.js` telemetry
# https://nextjs.org/telemetry
set NEXT_TELEMETRY_DISABLED 1

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

# Set homebrew path
switch (arch)
case arm64
    set BREW /opt/homebrew/bin
case x86_64
    set BREW /usr/local/bin
end
contains $BREW $fish_user_paths; or set -Ua fish_user_paths $BREW $fish_user_paths

# Move `asdf` config
# https://asdf-vm.com/#/core-configuration?id=environment-variables
set -gx ASDF_CONFIG_FILE $XDG_CONFIG_HOME/asdf/config
set -gx ASDF_DATA_DIR $HOME/.asdf

# ==========================
# Aliases
# ==========================

alias cat=bat
alias find=fd
alias fup="echo $fish_user_paths | tr \" \" \"\n\" | nl"
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
alias ls=exa
alias reload="exec $SHELL -l"
alias vim=nvim

# Quick edit config files
alias frc="nvim $XDG_CONFIG_HOME/fish/config.fish"
alias trc="nvim $XDG_CONFIG_HOME/tmux/tmux.conf"
alias vrc="nvim $XDG_CONFIG_HOME/nvim/init.vim"

# Hide/show hidden files in Finder
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

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
abbr y "yarn"

abbr dsr "docker stop (docker ps -a -q) && docker rm (docker ps -a -q)" # Stops and removes all running containers
abbr dex "docker exec -it"
abbr dcu "docker-compose up -d"
abbr dcub "docker-compose up -d --build"
abbr dra "docker rmi (docker images -q) --force"
abbr dl "docker logs -f"

# ==========================
# Other
# ==========================

direnv hook fish | source
source (brew --prefix)/opt/asdf/asdf.fish
