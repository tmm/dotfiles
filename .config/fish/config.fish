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
fish_add_path $PG_CONFIG

# Set homebrew path
switch (arch)
    case arm64
        set BREW /opt/homebrew/bin
    case x86_64
        set BREW /usr/local/bin
end
fish_add_path $BREW

# ==========================
# Aliases
# ==========================

alias cat="bat --style=numbers,changes --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo tokyonight_night || echo tokyonight_day)"
alias find=fd
alias fup="echo $fish_user_paths | tr \" \" \"\n\" | nl"
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
alias ls=exa
alias reload="exec $SHELL -l"
alias vim=nvim

# Quick edit config files
alias brc="nvim $HOME/Brewfile"
alias frc="nvim $XDG_CONFIG_HOME/fish/config.fish"
alias mrc="nvim $HOME/Makefile"
alias trc="nvim $XDG_CONFIG_HOME/tmux/tmux.conf"
alias vrc="nvim $XDG_CONFIG_HOME/nvim/init.lua"

# Hide/show hidden files in Finder
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# ==========================
# Abbreviations
# ==========================

abbr c cargo
abbr b bun
abbr df "h git"
abbr f forge
abbr g git
abbr home "cd ~"
abbr lsd "exa -d .*"
abbr p pnpm
abbr t tmux
abbr v nvim

abbr tn "tmux new -s"
abbr ta "tmux a -t"
abbr tks "tmux kill-server"
abbr tls "tmux ls"

# ==========================
# Other
# ==========================

direnv hook fish | source
fnm env | source
zoxide init fish | source

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

set -gx FOUNDRY_DIR "$HOME/.foundry"
set -gx PATH "$FOUNDRY_DIR" $PATH

set FOUNDRY_BIN $HOME/.foundry/bin
fish_add_path $FOUNDRY_BIN

set CARGO_BIN $HOME/.cargo/bin
fish_add_path $CARGO_BIN

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
