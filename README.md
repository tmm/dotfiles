# dotfiles

My dotfiles with no symbolic links or set up scripts.

<img width="550" alt="screenshot" src="https://user-images.githubusercontent.com/6759464/60097430-64a8a680-9721-11e9-8bd8-12d580b1641d.png">

## Installation

The installation guide to setup on a new macOS.

1. Fetch `dotfiles`:

    ```sh
    alias home="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
    home init .dotfiles
    home remote add origin https://github.com/tmm/dotfiles
    home fetch
    home checkout master
    ```

    Then update submodules:

    ```sh
    home submodule update --init --recursive
    ```

1. Install Xcode command line tools and agree to license:

    ```sh
    xcode-select --install
    sudo xcodebuild -license
    ```

1. Install [Homebrew](https://brew.sh/) and [Brewfile](Brewfile) dependencies:

    ```sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

    Then install dependencies with Homebrew bundle:

    ```sh
    ./scripts/brew
    ```

1. Install [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh):

    ```sh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ```

1. Install any remaining software updates:

    ```sh
    sudo softwareupdate --install --all
    ```

1. Set up macOS defaults and FireVault:

    ```sh
    ./scripts/macos
    ```

1. Bootstrap nitpicky details:

    ```sh
    ./scripts/bootstrap
    ```

1. Setup 1Password and sync passwords.

And that's it! `~tom` is ready to go!

## Adding new `zsh` plugins

1. Add submodule to `.omz/plugins/`:

    ```sh
    home submodule add https://github.com/zsh-users/plugin-name .omz/plugins/plugin-name
    ```

1. Update `.zprofile` `plugins`:

    ```sh
    plugins=(
        ...
        # Custom plugins (`~/.omz/plugins`)
        ...
        plugin-name
    )
    ```

## Colophon

Inspired by:

-   [@kylef](https://github.com/kylef/)'s [Organising dotfiles in a git repository](https://fuller.li/posts/organising-dotfiles-in-a-git-repository/)
-   [thoughtbot](https://thoughtbot.com/)'s [Brewfile: a Gemfile, but for Homebrew](https://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew)
-   [@mathiasbynens](https://github.com/mathiasbynens)' [`.macos`](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
-   [@MikeMcQuaid](https://github.com/MikeMcQuaid)'s [`strap`](https://github.com/MikeMcQuaid/strap)
-   [@vinkla](https://github.com/vinkla)'s [`dotfiles`](https://github.com/vinkla/dotfiles)

## License

[MIT](LICENSE) © [Tom Meagher](https://meagher.co)
