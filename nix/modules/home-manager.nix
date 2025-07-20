{ config, dotfilesDir, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    amber
    asciinema
    babelfish
    bat
    btop
    cachix
    delta
    direnv
    dockutil
    elixir
    erlang
    eza
    fd
    fnm
    fzf
    gh
    git
    httpie
    jq
    neovim
    ripgrep
    rustup
    starship
    zoxide
  ];
  home.file = {
    ".ignore".source = ../files/ignore;
    ".ssh/tom.pub".source = ../files/tom.pub;
  };
  home.shell.enableFishIntegration = true;
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    DOTFILES_HOME = "${config.home.homeDirectory}/${dotfilesDir}";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };
  imports = [
    ./ghostty.nix
    ./git.nix
    ./opencode.nix
    ./shell.nix
  ];
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      load_dotenv = true;
    };
  };
  programs.eza.enable = true;
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-copilot
      gh-poi
    ];
  };
  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = ''
      IdentityAgent "${config.home.sessionVariables.SSH_AUTH_SOCK}"
      StrictHostKeyChecking no
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](purple)";
      };
      cmd_duration = {
        format = "[( $duration)]($style)";
        style = "yellow";
      };
      directory = {
        style = "white";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_state = {
        format = lib.concatStrings [
          "\\("
          "[$state( $progress_current/$progress_total)]"
          "($style)"
          "\\) "
        ];
        style = "bright-black";
        merge = "■";
      };
      git_status = {
        format = lib.concatStrings [
          "[("
          "$conflicted"
          "$untracked"
          "$modified"
          "$staged"
          "$stashed"
          "$renamed"
          "$deleted"
          ")](218)"
          "[( "
          "$ahead_behind"
          ")](cyan)"
        ];
        ahead = "▲";
        behind = "▼";
        conflicted = "";
        deleted = "";
        diverged = "◆";
        modified = "*";
        renamed = "";
        staged = "";
        stashed = "≡";
        untracked = "";
      };
    };
  };
  programs.zoxide.enable = true;
  xdg = {
    enable = true;
    configFile = {
      nvim = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/nvim";
        recursive = true;
      };
    };
  };
}
