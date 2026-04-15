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

      # local bin (curl.md, etc.)
      fish_add_path $HOME/.local/bin

      # obsidian cli
      fish_add_path /Applications/Obsidian.app/Contents/MacOS

      fnm env | source
      fzf --fish | source

      function amp --wraps amp --description 'Run amp with PLUGINS=all and private visibility by default'
        env PLUGINS=all command amp --visibility private $argv
      end

      function drs --description 'Rebuild a darwin host'
        set -l darwin_host
        set -l extra_args $argv

        if test (count $argv) -gt 0
          if not string match -qr '^-' -- $argv[1]
            set darwin_host $argv[1]
            set extra_args $argv[2..-1]
          end
        end

        if test -z "$darwin_host"
          set darwin_host $DARWIN_HOST
        end

        if test -z "$darwin_host"
          set darwin_host (scutil --get LocalHostName)
        end

        sudo darwin-rebuild switch --flake "path:$DOTFILES_HOME/nix#$darwin_host" $extra_args
      end

      function drb --description 'Build a darwin host'
        set -l darwin_host
        set -l extra_args $argv

        if test (count $argv) -gt 0
          if not string match -qr '^-' -- $argv[1]
            set darwin_host $argv[1]
            set extra_args $argv[2..-1]
          end
        end

        if test -z "$darwin_host"
          set darwin_host $DARWIN_HOST
        end

        if test -z "$darwin_host"
          set darwin_host (scutil --get LocalHostName)
        end

        darwin-rebuild build --flake "path:$DOTFILES_HOME/nix#$darwin_host" $extra_args
      end
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

      dot = "pushd . && cd $DOTFILES_HOME && nvim";

      hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
      showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";
    };
  };
}
