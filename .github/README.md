## Install

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout main
```

```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

## Commands

```
make                    # Bootstrap setup
make macos              # Set up macOS defaults
make nix                # Set up nix (nix-darwin and home-manager)
make npm                # Set up node
make nvim-packages      # Install neovim packages
```

