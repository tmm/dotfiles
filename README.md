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

And that's it! `~tom` is ready to go!

---

<details>
    <summary>P.S. Some manual things that might also need doing (Click to expand)</summary>
    ✅ Install <a href="https://developer.apple.com/xcode/">Xcode</a><br>
    ✅ Install <a href="https://www.bywordapp.com/">Byword</a> from App Store<br>
    ✅ Install <a href="http://dayoneapp.com/">Day One</a> from App Store<br>
    ✅ Set up <a href="https://github.com/pstadler/keybase-gpg-github">Keybase.io, GPG, & Git to sign commits on GitHub</a><br>
</details>

## Colophon 

Inspired by [@kylef](https://github.com/kylef/)'s [Organising dotfiles in a git repository](https://fuller.li/posts/organising-dotfiles-in-a-git-repository/) and [thoughtbot](https://thoughtbot.com/)'s [Brewfile: a Gemfile, but for Homebrew](https://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew).

## License

Released under the MIT license. See [LICENSE](https://github.com/tmm/dotfiles/blob/master/LICENSE) for details.
