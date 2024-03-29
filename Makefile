PIP=PIP_REQUIRE_VIRTUALENV=false pip

BREW := $(shell [ $$(uname -m) = arm64 ] && echo /opt/homebrew || echo /usr/local)/bin/brew
OS := $(shell uname)

all: $(OS) nvim-packages tmux-packages

Darwin:
Linux:

$(BREW):
	@echo Installing Homebrew
	@sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

macos:
	@sudo swiftc $$XDG_CONFIG_HOME/macos/sync_system_appearance.swift -o /usr/local/bin/sync_system_appearance
	@ln -s $$XDG_CONFIG_HOME/macos/com.awkweb.sync_system_appearance.plist ~/Library/LaunchAgents/com.awkweb.sync_system_appearance.plist
	@launchctl load -w ~/Library/LaunchAgents/com.awkweb.sync_system_appearance.plist # run `launchctl unload path` if it fails

.PHONY: npm
npm: $(BREW)
	@fnm install 18
	@corepack enable
	@corepack prepare pnpm@latest --activate

.PHONY: nvim-packages
nvim-packages:
	@nvim -c qall
	@nvim --headless -c 'autocmd User LazyInstall quitall' -c 'Lazy install'

.PHONY: tmux-packages
tmux-packages:
	@rm -rf $$XDG_CONFIG_HOME/tmux/plugins/tpm
	@git clone https://github.com/tmux-plugins/tpm $$XDG_CONFIG_HOME/tmux/plugins/tpm
	@tmux new -d -s tmux-packages
	@tmux source $$XDG_CONFIG_HOME/tmux/tmux.conf
	@bash -c $$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins
	@bash -c "$$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/update_plugins all"
	@tmux kill-ses -t tmux-packages

extras:
	# bat
	@mkdir -p "$$(bat --config-dir)/themes"
	@cd "$$(bat --config-dir)/themes"
	@curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
	@curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_day.tmTheme
	@bat cache --build
