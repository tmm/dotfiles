# dotfiles

My dotfiles with no symbolic links or set up scripts.

Inspired by [@kylef](https://github.com/kylef/)'s [Organising dotfiles in a git repository](https://fuller.li/posts/organising-dotfiles-in-a-git-repository/).

## Installation

Cloning the repo:

```shell
> alias home="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
> home init .dotfiles
> home remote add origin https://github.com/tmm/dotfiles
> home fetch
> home checkout master
```

Install [Homebrew](https://brew.sh/) and [`Brewfile`](https://github.com/tmm/dotfiles/blob/master/Brewfile) dependencies:

```shell
> /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> brew tap homebrew/bundle
> brew bundle
```

Install [`Oh My Zsh`](https://github.com/robbyrussell/oh-my-zsh):

```shell
> sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## License

Released under the MIT license. See LICENSE for details.
