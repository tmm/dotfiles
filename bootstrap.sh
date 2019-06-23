#!/usr/bin/env zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install Homebrew and Brewfile dependencies:
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle

# Make macOS just the way I like it:
zsh .macos

# Create a hard link for code settings
ln -hf prefs/code/settings.json Library/Application\ Support/Code/User/settings.json