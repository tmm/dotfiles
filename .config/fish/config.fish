# ==========================
# Aliases
# ==========================

alias cat=bat
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias ls=exa
alias reload="exec $SHELL -l"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"

alias frc="vim ~/.config/fish/config.fish"
alias trc="vim ~/.config/tmux/tmux.conf"
alias vrc="vim ~/.vim/vimrc"

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
abbr v "vim"
abbr vl "v -l"
abbr x "devx"

abbr dsr "docker stop (docker ps -a -q) && docker rm (docker ps -a -q)" # Stops and removes all running containers
abbr dex "docker exec -it"
abbr dcu "docker-compose up -d"
abbr dcub "docker-compose up -d --build"
abbr dra "docker rmi (docker images -q) --force"
abbr dl "docker logs -f"

# ==========================
# Variables
# ==========================

set -gx EDITOR vim
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git/**'"

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
set -U fish_user_paths /Applications/Postgres.app/Contents/Versions/latest/bin $fish_user_paths

# ==========================
# Functions
# ==========================

# Auto start tmux if using direnv and z
# https://github.com/direnv/direnv/wiki/Tmux-and-Fish
function autotmux --on-variable TMUX_SESSION_NAME
    if test -n "$TMUX_SESSION_NAME" #only if set
        if test -z $TMUX #not if in TMUX
            if tmux has-session -t $TMUX_SESSION_NAME
                exec tmux new-session -t "$TMUX_SESSION_NAME"
            else
                exec tmux new-session -s "$TMUX_SESSION_NAME"
            end
        end
    end
end

# ==========================
# Other
# ==========================

eval (direnv hook fish)
source /usr/local/opt/asdf/asdf.fish
