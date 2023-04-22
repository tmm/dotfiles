PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW := $(shell [ $$(uname -m) = arm64 ] && echo /opt/homebrew || echo /usr/local)/bin/brew
OS := $(shell uname)

all: $(OS) fish-packages vim-packages

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

.PHONY: vim-packages
vim-packages:
	@python3 -m pip install --user --upgrade pynvim
	@nvim -c qall
	@nvim --headless -c 'autocmd User LazyInstall quitall' -c 'Lazy install'

