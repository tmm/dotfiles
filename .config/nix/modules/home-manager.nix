{ pkgs, pkgsUnstable, ... }: {
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
    flyctl
    fnm
    fzf
    gh
    git
    httpie
    jq
    neovim
    ripgrep
    rustup
    zoxide
  ] ++ (with pkgsUnstable; [
    # TODO: Using latest version (elixir@1.17.3), replace once stable
    elixir
  ]);
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
