{ pkgs, ... }: {
  home.packages = with pkgs; [
    amber
    asciinema
    babelfish
    bat
    cachix
    diff-so-fancy
    direnv
    dockutil
    elixir
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
    zoxide
  ];
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
  programs.gh.enable = true;
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile = {
      "fish" = {
        source = ../files/fish;
        recursive = true;
      };
    };
  };
}
