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
make macos              # Set up macOS defaults
make npm                # Set up node
make nvim-packages      # Install neovim packages
make tmux-packages      # Install tmux packages
```

