# dotfiles

My dotfiles stored in a bare git repo.

## Installation

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

1. Import GPG key:

    ```sh
    keybase pgp export -q 72072EC3ED191086 | gpg --import
    keybase pgp export -q 72072EC3ED191086 --secret | gpg --allow-secret-key-import --import
    ```

1. Setup 1Password and `~tom` is ready to go!

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

## Alfred Workflows

A bunch of installed workflows and their hotkeys.

-   `⌃⌘W` [Dash](https://github.com/Kapeli/Dash-Alfred-Workflow)
-   `⌃⌘E` [Emoji](https://github.com/jsumners/alfred-emoji)
-   `⌃⌘G` [GitHub Repos](https://github.com/edgarjs/alfred-github-repos)
-   `⌃⌘N` [Numi](https://github.com/nikolaeu/Numi)
-   `⌃⌘S` [Spotify Mini Player](http://alfred-spotify-mini-player.com/)
-   `⌃⌘T` [TimeZones](https://github.com/jaroslawhartman/TimeZones-Alfred)
-   `⌃⌘C` [VS Code](https://github.com/nightgrey/alfred-open-vsc-project)

See [Packal](http://www.packal.org/) for more.

## License

[MIT](.github/LICENSE) © [Tom Meagher](https://meagher.co)
