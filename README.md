## dotfiles

Tom Meagher's [.files](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory)

## Installation

Cloning the dotfiles:

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files.git"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout master
```

Installing tools:

```
make
```

Change shell to [fish](https://fishshell.com/) and set up macOS defaults:

```
make fish
make macos
```
