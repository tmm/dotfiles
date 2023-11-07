# TODO

nix

## Plugins

- :checkhealth 
- toggle copilot
- https://github.com/echasnovski/mini.surround
- LSP set up https://github.com/LazyVim/LazyVim/blob/8c0e39c826f697d668aae336ea26a83be806a543/lua/lazyvim/plugins/lsp/init.lua#L90
- trouble quickfix https://github.com/LazyVim/LazyVim/blob/0801e52118ef5f48d4ae389d0cefd79814d28a42/lua/lazyvim/plugins/editor.lua#L415
- https://github.com/andymass/vim-matchup
- https://github.com/goolord/alpha-nvim
- https://github.com/folke/persistence.nvim
- https://github.com/folke/edgy.nvim lazyterm
- https://github.com/folke/noice.nvim
- https://github.com/b0o/incline.nvim
- https://github.com/lewis6991/satellite.nvim
- https://github.com/jackMort/ChatGPT.nvim

## Misc

- swap unimpaired mappings https://twitter.com/elijahmanor/status/1615927039529291776
- .files show up in telescope (e.g. `.env`)

## Links

- https://www.lazyvim.org
- https://github.com/folke/dot
- https://gist.github.com/rsms/fb463396c95ad8d9efa338a8050a01dc
- https://speakerdeck.com/cocopon/creating-your-lovely-color-scheme?slide=63
- https://dotfiles.substack.com/p/16-elijah-manor?post_id=135441075

- https://nix-community.github.io/home-manager/options.html
- https://daiderd.com/nix-darwin/manual/index.html
- https://search.nixos.org/packages

---

```
NSGlobalDomain.AppleHighlightColor = "0.764700 0.976500 0.568600";

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
defaults write com.apple.finder WarnOnEmptyTrash -bool false

chflags nohidden ~/Library

# Finder > Preferences
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Firefox.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "~/Downloads" --section others --sort name --view list

# Remove All Unavailable Simulators
xcrun simctl delete unavailable

brew 'gpg'
brew 'tmux'                       
brew 'mas' # App Store CLI (https://github.com/mas-cli/mas)


system.activationScripts
https://github.com/leonbreedt/nix-config/blob/15765e5aea9cce38fd1e342cf6df6799a11ef73e/macos/lib/dock.nix#L7
```
