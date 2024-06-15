## Install

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout main
make
```

## Commands

```fish
make                    # Bootstrap setup
make macos              # Set up macOS defaults
make nix                # Set up nix (nix-darwin and home-manager)
make node               # Set up node
make nvim-packages      # Install neovim packages
```

