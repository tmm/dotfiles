{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Pure
      # https://github.com/rafaelrinaldi/pure#configuration
      set pure_color_primary white
      set pure_color_success green

      # Add a line to my prompt?
      # https://github.com/pure-fish/pure/blob/master/conf.d/_pure_init.fish
      functions --query _pure_prompt_new_line

      # Add `pg_config` to path
      # https://fishshell.com/docs/current/tutorial.html?highlight=fish_user_path#path
      set PG_CONFIG /Applications/Postgres.app/Contents/Versions/latest/bin
      fish_add_path $PG_CONFIG

      # Set homebrew path
      switch (arch)
        case arm64
          set BREW /opt/homebrew/bin
        case x86_64
          set BREW /usr/local/bin
      end
      fish_add_path $BREW

      fnm env | source
      zoxide init fish | source

      set -gx PNPM_HOME "$HOME/.local/share/pnpm"
      set -gx PATH "$PNPM_HOME" $PATH

      set -gx FOUNDRY_DIR "$HOME/.foundry"
      set -gx PATH "$FOUNDRY_DIR" $PATH

      set FOUNDRY_BIN $HOME/.foundry/bin
      fish_add_path $FOUNDRY_BIN

      # bun
      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH
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
      # https://github.com/jethrokuan/fzf
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
          sha256 = "sha256-28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
        };
      }
      # https://github.com/pure-fish/pure
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "pure-fish";
          repo = "pure";
          rev = "f1b2c7049de3f5cb45e29c57a6efef005e3d03ff";
          sha256 = "sha256-MnlqKRmMNVp6g9tet8sr5Vd8LmJAbZqLIGoDE5rlu8E=";
        };
      }
    ];
    shellAbbrs = {
      a = "ambr";
      b = "bun";
      d = "devenv";
      e = "edgedb";
      df = "h git";
      g = "git";
      hm = "home-manager";
      home = "cd ~";
      jq = "jaq";
      lsd = "eza -d .*";
      p = "pnpm";
      v = "nvim";
    };
    shellAliases = {
      cat = "bat --style=numbers,changes --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo tokyonight_night || echo tokyonight_day)";
      find = "fd";
      fup = "echo $fish_user_paths | tr \" \" \"\n\" | nl";
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
      h = "env GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.files";
      ls = "eza";
      reload = "exec $SHELL -l";
      vim = "nvim";
      hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
      show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";

      nconf = "nvim ~/.config/nix/flake.nix";
      vconf = "nvim ~/.config/nvim/init.lua";
      drs = "darwin-rebuild switch --flake ~/.config/nix/";

      hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
      showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";
    };
  };
}

