Clone the dotfiles:

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout master
```

Install tools:

```
make
```

Other commands:

```
make alfred            # Install Alfred workflows
make fish              # Change shell to fish
make fish-packages     # Install fish packages with fisher
make gpg               # Import GPG key from Keybase
make homebrew-packages # Install with homebrew, cask, mas
make macos             # Set up macOS defaults
make tmux-packages     # Install tmux packages with tpm
make vim-packages      # Install vim packages with plug
```

Not automated yet:

* Set up [1Password](https://1password.com)
* Configure SSH
* Change background color to #131415 or [classic macOS wallpaper](https://512pixels.net/projects/default-mac-wallpapers-in-5k/)
* Map `Caps Lock` to `Escape` (System Preferences > Keyboard > Modifier Keys)
* Install [AirBuddy](https://v2.airbuddy.app)
