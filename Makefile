PIP=PIP_REQUIRE_VIRTUALENV=false pip

osx: homebrew-packages python-packages

/usr/local/bin/brew:
	@echo Installing Homebrew
	@ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`"

/usr/local/Library/Taps/homebrew/homebrew-bundle: /usr/local/bin/brew
	brew tap Homebrew/bundle

.PHONY: homebrew-packages
homebrew-packages: /usr/local/Library/Taps/homebrew/homebrew-bundle
	brew bundle

.PHONY: python-packages
python-packages: /usr/local/bin/virtualenv

/usr/local/bin/virtualenv:
	$(PIP) install virtualenv

zsh:
	@chsh -s $(which zsh)

oh-my-zsh:
	@echo Installing Oh My Zsh
	@sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"