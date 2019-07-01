#!/bin/zsh

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.private can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,private}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done;
unset file;

# Set up oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh
ZSH_CUSTOM=$HOME/.omz
ZSH_THEME="tom"

plugins=(
	history
	man
	sudo
	wd
	# Custom plugins (`~/.omz/plugins`)
	zsh-autosuggestions
	zsh-interactive-cd
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
