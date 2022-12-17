## Install

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout main
```

## Commands

```
make                    # Bootstrap setup
make fish               # Change shell to fish
make fish-packages      # Install fish packages
make gpg                # Import GPG key
make homebrew-packages  # Install tools
make macos              # Set up macOS defaults
make tmux-packages      # Install tmux packages
make vim-packages       # Install vim packages
```
