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
make alfred # Install Alfred workflows
make fish   # Change shell to fish
make macos  # Set up macOS defaults
make gpg    # Import GPG key from Keybase
```

[Download a classic macOS
wallpaper.](https://512pixels.net/projects/default-mac-wallpapers-in-5k/)

<details>
    <summary>Not automated yet</summary>

<ul>
   <li>Map Caps lock to Escape</li>
   <li>Automatically show and hide the menu bar</li>
   <li>Automatically show and hide the dock</li>
   <li>Set trackpad tracking speed to fastest available</li>
   <li>Configure SSH</li>
   <li>Set up <a href="https://1password.com">1Password</a></li>
   <li>Set up <a href="https://www.alfredapp.com">Alfred</a></li>
   <li>Set up <a href="https://contexts.co">Contexts</a></li>
   <li>Install <a href="https://v2.airbuddy.app/">AirBuddy</a></li>
   <li>Change background color to `#131415`</li>
</ul>
</details>
