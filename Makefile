PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW := $(shell [ $$(uname -m) = arm64 ] && echo /opt/homebrew || echo /usr/local)/bin/brew
OS := $(shell uname)

all: $(OS) fish-packages nvim-packages

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

.PHONY: homebrew-packages
homebrew-packages: $(BREW)
	brew bundle

.PHONY: npm
npm: $(BREW)
	@fnm install 18
	@corepack enable
	@corepack prepare pnpm@latest --activate

macos:
	@bash -c $$XDG_CONFIG_HOME/macos/config

.PHONY: vim-packages
nvim-packages:
	@nvim -c qall
	@nvim --headless -c 'autocmd User LazyInstall quitall' -c 'Lazy install'

