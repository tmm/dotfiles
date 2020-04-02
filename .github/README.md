## Installation

Clone the dotfiles:

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files.git"
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
make fish  # Change shell to fish
make macos # Set up macOS defaults
make gpg   # Import GPG key from Keybase
```
