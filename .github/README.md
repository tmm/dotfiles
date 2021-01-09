## Set up

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout master
```

## Commands

```
make                    # Bootstrap setup
make alfred             # Install Alfred workflows
make fish               # Change shell to fish
make fish-packages      # Install fish packages with fisher
make gpg                # Import GPG key from Keybase
make homebrew-packages  # Install tools with homebrew, cask, mas
make macos              # Set up macOS defaults
make tmux-packages      # Install tmux packages with tpm
make vim-packages       # Install vim packages with vim-plug
```

## Not automated yet

* Set up [1Password](https://1password.com)
* Configure SSH
* Map `Caps Lock` to `Escape` (System Preferences > Keyboard > Modifier Keys)
* Nitpicky details: https://www.craft.do/s/dgb68JxSefmpSJ
