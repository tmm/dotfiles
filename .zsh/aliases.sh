# Core
alias tfm='cd ~'
alias lsd='ls -d .*'
alias rc='code ~/.zshrc'
alias home='git --work-tree=$HOME --git-dir=$HOME/.dotfiles/'

# Git
alias ga='git add -A'
alias gac='git add -A && git commit -m'
alias gb='git branch'
alias gbc='echo -n "$(git rev-parse --abbrev-ref HEAD)" | pbcopy; echo `tput setaf 5`"Branch name copied to clipboard!"`tput sgr0`'
alias gbd='git branch -D'
alias gc='git commit -m'
alias gch='git checkout'
alias gchb='git checkout -b'
alias gchm='git checkout master'
alias gd='stree'
alias gf='git fetch'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset %C(yellow)%an%d%Creset %s %Cgreen(%cr)%Creset" --date=relative'
alias gp='git push'
alias gpl='git pull'
alias gpr='open $(git remote -v | grep origin | grep push | cut -f 2 | cut -d " " -f 1 | sed -e "s/\.git//g")/pull/new/$(git rev-parse --abbrev-ref HEAD)'
alias gps='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gs='git status'
alias gss='git status -s'
alias gst='git status --untracked-files=no'
alias gsu='git status -uno'

# Docker
alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dex='docker exec -it'
alias dl='docker logs'
alias dps='docker ps'
alias dr='docker rm'
alias ds='docker stop'
alias dsr='ds $(dps -a -q) && dr $(dps -a -q)'

# Terraform
alias tf='terraform'

# Show/hide hidden files in Finder
alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

# Misc
alias dj='python manage.py '
