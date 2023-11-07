{ pkgs, ... }: {
  home.packages = with pkgs; [
    babelfish
    bat
    diff-so-fancy
    direnv
    dockutil
    eza
    fd
    fnm
    fzf
    git
    gh
    jq
    neovim
    ripgrep
    zoxide
  ];
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bat = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    config = {
      load_dotenv = true;
    };
  };

  programs.eza = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Pure
      # https://github.com/rafaelrinaldi/pure#configuration
      set pure_color_primary white
      set pure_color_success green

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
          sha256 = "1x1h65l8582p7h7w5986sc9vfd7b88a7hsi68dbikm090gz8nlxx";
        };
      }
    ];
    shellAbbrs = {
      b = "bun";
      df = "h git";
      g = "git";
      hm = "home-manager";
      home = "cd ~";
      lsd = "eza -d .*";
      p = "pnpm";
      t = "tmux";
      v = "nvim";

      tn = "tmux new -s";
      ta = "tmux a -t";
      tks = "tmux kill-server";
      tls = "tmux ls";
    };
    shellAliases = {
      cat = "bat --style=numbers,changes --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo tokyonight_night || echo tokyonight_day)";
      find = "fd";
      fup = "echo $fish_user_paths | tr \" \" \"\n\" | nl";
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

  programs.git = {
    enable = true;

    aliases = {
      a = "add";
      aa = "add .";
      au = "add --update";
      b = "branch";
      c = "commit -m";
      cn = "commit --no-verify -m";
      ch = "checkout";
      l = "log";
      p = "push";
      pf = "push --force";
      pl = "pull";
      s = "status";

      amend = "commit --amend --reuse-message=HEAD";
      go = "!go() { git checkout -b $1 2> /dev/null || git checkout $1; }; go";
      hist = "log --pretty=oneline --pretty=format:'%Cred%h%Creset %C(yellow)%an%Creset %s%C(normal dim)%d%Creset %Cgreen(%cr)%Creset' --date=relative --abbrev-commit";
      monkeys = "shortlog --summary --numbered";
      undo = "reset --soft HEAD^";
      unstage = "reset HEAD --";
    };
    userName = "Tom Meagher";
    userEmail = "tom@meagher.co";

    extraConfig = {
      color.ui = "auto";
      commit.gpgsign = true;
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore_global";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      credential.helper = "osxkeychain";
      github.user = "tmm";
      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      init.defaultBranch = "main";
      push.default = "current";
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLwl9HCwJ1+kNCbrx3N15oIcNfW7SgZBTFlmQnQEVn4";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "fish" = {
        source = ../files/fish;
        recursive = true;
      };
      "git" = {
        source = ../files/git;
        recursive = true;
      };
    };
  };
}
