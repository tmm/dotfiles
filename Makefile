PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW := $(shell [ $$(uname -m) = arm64 ] && echo /opt/homebrew || echo /usr/local)/bin/brew
OS := $(shell uname)

all: $(OS) nix nvim

Darwin:
Linux:

$(BREW):
	@echo Installing Homebrew
	@sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

.PHONY: nix
nix:
	@sudo curl -fsSL https://nixos.org/nix/install | bash
	@nix run nix-darwin -- switch --flake $$DOTFILES_HOME/nix
	@darwin-rebuild switch --flake $$DOTFILES_HOME/nix

.PHONY: nvim
nvim:
	@nvim -c qall
	@nvim --headless -c 'autocmd User LazyInstall quitall' -c 'Lazy install'
