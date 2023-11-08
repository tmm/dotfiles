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
      "git" = {
        source = ../files/git;
        recursive = true;
      };
    };
  };
}
