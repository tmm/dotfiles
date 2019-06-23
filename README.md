# dotfiles

My dotfiles with no symbolic links or set up scripts.

## Installation

Cloning the repo:

```shell
> alias home="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
> home init .dotfiles
> home remote add origin https://github.com/tmm/dotfiles
> home fetch
> home checkout master
```

Install [`Oh My Zsh`](https://github.com/robbyrussell/oh-my-zsh):

```shell
> sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Install [Homebrew](https://brew.sh/) and [`Brewfile`](https://github.com/tmm/dotfiles/blob/master/Brewfile) dependencies:

```shell
> /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> brew tap homebrew/bundle
> brew bundle
```

Make macOS just the way I like it:

```shell
> bash .macos
```

Set up [Keybase.io, GPG, & Git to sign commits on GitHub](https://github.com/pstadler/keybase-gpg-github)

And that's it! `~tom` is ready to go!

## Colophon

Inspired by [@kylef](https://github.com/kylef/)'s [Organising dotfiles in a git repository](https://fuller.li/posts/organising-dotfiles-in-a-git-repository/) and [thoughtbot](https://thoughtbot.com/)'s [Brewfile: a Gemfile, but for Homebrew](https://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew). `.macos` inspired by [@mathiasbynens'](https://github.com/mathiasbynens) [`.macos`](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)

## License

Released under the MIT license. See [LICENSE](https://github.com/tmm/dotfiles/blob/master/LICENSE) for details.
