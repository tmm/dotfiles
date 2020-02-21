## dotfiles

Tom Meagher's [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory)

## Installation

Cloning the dotfiles:

```
alias h="env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.dotfiles.git"
h git init
h git remote add origin https://github.com/tmm/dotfiles.git
h git fetch
h git checkout master
```

Installing tools:

```
make
```