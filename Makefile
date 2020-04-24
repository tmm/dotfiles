PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW=/usr/local/bin/brew
BREW_BUNDLE=/usr/local/Homebrew/Library/Taps/homebrew/homebrew-bundle

OS := $(shell uname)

all: $(OS) vim-packages fish-packages tmux-packages

Darwin: homebrew-packages
Linux:

$(BREW):
	@echo Installing Homebrew
	@ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`"

$(BREW_BUNDLE): $(BREW)
	brew tap Homebrew/bundle

.PHONY: homebrew-packages
homebrew-packages: $(BREW_BUNDLE)
	brew bundle

.PHONY: vim-packages
vim-packages:
	@vim -c PlugUpgrade -c PlugInstall -c qall

fish:
	@chsh -s $(shell which fish)

.PHONY: fish-packages
fish-packages:
	@fish -c fisher

.PHONY: tmux-packages
tmux-packages:
	@rm -rf ~/.config/tmux/plugins/tpm
	@git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
	@tmux new -d -s tmux-packages
	@tmux source ~/.config/tmux/tmux.conf
	@bash -c ~/.config/tmux/plugins/tpm/bin/install_plugins
	@bash -c "~/.config/tmux/plugins/tpm/bin/update_plugins all"
	@tmux kill-ses -t tmux-packages

alfred:
	@bash -c ~/.config/alfred/install

macos:
	@bash -c ~/.config/macos

gpg:
	@open /Applications/Keybase.app
	@keybase pgp export -q 72072EC3ED191086 | gpg --import
	@keybase pgp export -q 72072EC3ED191086 --secret | gpg --allow-secret-key-import --import
