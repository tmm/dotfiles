{ lib, pkgs, pkgsUnstable, ... }: {
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
  ] ++ (with pkgsUnstable; [
    # TODO: Using latest version (elixir@1.17.3), replace once stable
    elixir
  ]);
  home.shell.enableFishIntegration = true;
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./ghostty.nix
    ./git.nix
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
        format = "[$duration]($style) ";
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
      };
      git_status = {
        format = lib.concatStrings [
          "["
          "[(*"
          "$conflicted"
          "$untracked"
          "$modified"
          "$staged"
          "$renamed"
          "$deleted"
          ")](218) "
          "($ahead_behind"
          "$stashed"
          ")]"
          "($style)"
        ];
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
    };
  };
  programs.zoxide.enable = true;

  home.file = {
    ignore = {
      source = ../files/ignore;
      target = ".ignore";
    };
    ssh = {
      source = ../files/ssh;
      target = ".ssh";
      recursive = true;
    };
    xcode = {
      source = ../files/xcode;
      target = "Library/Developer/Xcode/UserData";
      recursive = true;
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "delta" = {
        source = ../files/delta;
        recursive = true;
      };
      "fish" = {
        source = ../files/fish;
        recursive = true;
      };
    };
  };
}
