# dotfiles

My dotfiles with no symbolic links or set up scripts.

Inspired by [@kylef](https://github.com/kylef/)'s [Organising dotfiles in a git repository](https://fuller.li/posts/organising-dotfiles-in-a-git-repository/).

## Installation

```shell
alias home="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
home init
home remote add origin https://github.com/tmm/dotfiles
home fetch
home checkout master
```

## License

Released under the MIT license. See LICENSE for details.