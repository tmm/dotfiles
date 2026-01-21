{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Ghostty supports auto-injection but Nix-darwin hard overwrites XDG_DATA_DIRS
      # which make it so that we can't use the auto-injection. We have to source
      # manually.
      if set -q GHOSTTY_RESOURCES_DIR
        source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
      end

      # disable welcome message
      set -g fish_greeting

      # cargo
      fish_add_path $HOME/.cargo/bin

      # pnpm
      set -gx PNPM_HOME "$HOME/.local/share/pnpm"
      set -gx PATH "$PNPM_HOME" $PATH

      # foundry
      set -gx FOUNDRY_DIR "$HOME/.foundry"
      set -gx PATH "$FOUNDRY_DIR" $PATH
      set FOUNDRY_BIN $HOME/.foundry/bin
      set -gx FOUNDRY_DISABLE_NIGHTLY_WARNING true
      fish_add_path $FOUNDRY_BIN

      # Add `pg_config` to path
      # https://fishshell.com/docs/current/tutorial.html?highlight=fish_user_path#path
      set PG_CONFIG /Applications/Postgres.app/Contents/Versions/latest/bin
      fish_add_path $PG_CONFIG

      fnm env | source
      fzf --fish | source
    '';
    plugins = [
      # https://github.com/jorgebucaran/autopair.fish
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
        };
      }
    ];
    shellAbbrs = {
      a = "amp";
      b = "bun";
      d = "docker";
      de = "delta";
      dc = "docker compose";
      g = "git";
      i = "iex";
      lsd = "eza -d .*";
      m = "mix";
      n = "npm";
      o = "opencode";
      p = "pnpm";
      v = "nvim";
    };
    shellAliases = {
      cat = "bat --style=numbers,changes --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo dotfiles_dark || echo dotfiles_light)";
      find = "fd";
      fup = "echo $fish_user_paths | tr \" \" \"\n\" | nl";
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
      ls = "eza";
      reload = "exec $SHELL -l";
      vim = "nvim";
      hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
      show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";

      drs = "sudo darwin-rebuild switch --flake $DOTFILES_HOME/nix";
      dot = "pushd . && cd $DOTFILES_HOME && nvim";

      hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
      showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";
    };
  };
}
