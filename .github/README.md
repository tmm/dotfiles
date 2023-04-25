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
make homebrew-packages  # Install tools
make macos              # Set up macOS defaults
make npm                # Set up Node
make nvim-packages      # Install Neovim packages
```
