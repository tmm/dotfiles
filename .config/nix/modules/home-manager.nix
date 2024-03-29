{ pkgs, ... }: {
  home.packages = with pkgs; [
    amber
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
    fnm
    fzf
    gh
    git
    httpie
    jq
    neovim
    ripgrep
    websocat
    zoxide
  ];
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

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
