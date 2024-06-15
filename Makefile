PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW := $(shell [ $$(uname -m) = arm64 ] && echo /opt/homebrew || echo /usr/local)/bin/brew
OS := $(shell uname)

all: $(OS) nix nvim-packages

Darwin:
Linux:

$(BREW):
	@echo Installing Homebrew
	@sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

macos:
	@sudo swiftc $$XDG_CONFIG_HOME/macos/sync_system_appearance.swift -o /usr/local/bin/sync_system_appearance
	@ln -s $$XDG_CONFIG_HOME/macos/com.awkweb.sync_system_appearance.plist ~/Library/LaunchAgents/com.awkweb.sync_system_appearance.plist
	@launchctl load -w ~/Library/LaunchAgents/com.awkweb.sync_system_appearance.plist # run `launchctl unload path` if it fails

.PHONY: nix
nix:
	@sudo curl -fsSL https://nixos.org/nix/install | bash
	@nix run nix-darwin -- switch --flake $$XDG_CONFIG_HOME/nix
	@darwin-rebuild switch --flake $$XDG_CONFIG_HOME/nix

.PHONY: node
node: $(BREW)
	@fnm install 22
	@corepack enable
	@corepack prepare pnpm@latest --activate

.PHONY: nvim-packages
nvim-packages:
	@nvim -c qall
	@nvim --headless -c 'autocmd User LazyInstall quitall' -c 'Lazy install'

extras:
	# bat
	@mkdir -p "$$(bat --config-dir)/themes"
	@cd "$$(bat --config-dir)/themes"
	@curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
	@curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_day.tmTheme
	@bat cache --build
