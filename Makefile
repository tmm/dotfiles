PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW := $(shell [ $$(uname -m) = arm64 ] && echo /opt/homebrew || echo /usr/local)/bin/brew
OS := $(shell uname)

all: $(OS) fish-packages vim-packages tmux-packages

Darwin: homebrew-packages
Linux:

$(BREW):
	@echo Installing Homebrew
	@sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

.PHONY: fish
fish:
	@if ! grep -q "$(shell which fish)" /etc/shells; then echo $(shell which fish) | sudo tee -a /etc/shells; fi;
	@chsh -s $(shell which fish)

.PHONY: fish-packages
fish-packages:
	@curl -fsSLo $$XDG_CONFIG_HOME/fish/functions/fisher.fish --create-dirs https://git.io/fisher
	@fish -c "fisher update"

.PHONY: gpg
gpg:
	@open /Applications/Keybase.app
	@keybase pgp export -q 72072EC3ED191086 | gpg --import
	@keybase pgp export -q 72072EC3ED191086 --secret | gpg --allow-secret-key-import --import

.PHONY: homebrew-packages
homebrew-packages: $(BREW)
	brew bundle

.PHONY: npm
npm-packages: $(BREW)
	@fnm install
	@npm i -g pnpm

macos:
	@bash -c $$XDG_CONFIG_HOME/macos/config

.PHONY: tmux-packages
tmux-packages:
	@rm -rf $$XDG_CONFIG_HOME/tmux/plugins/tpm
	@git clone https://github.com/tmux-plugins/tpm $$XDG_CONFIG_HOME/tmux/plugins/tpm
	@tmux new -d -s tmux-packages
	@tmux source $$XDG_CONFIG_HOME/tmux/tmux.conf
	@bash -c $$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins
	@bash -c "$$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/update_plugins all"
	@tmux kill-ses -t tmux-packages

.PHONY: vim-packages
vim-packages:
	@python3 -m pip install --user --upgrade pynvim
	@nvim -c qall
	@nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

